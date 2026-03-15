#!/bin/bash
set -euo pipefail

# =============================================================================
# HyDE Dotfiles Setup
# Idempotent install script for Arch Linux + HyDE (Hyprland)
# =============================================================================

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
HOME_DIR="$HOME"
VERSION="1.0.0"
CLEANUP_DIRS=()

# --- Helpers -----------------------------------------------------------------

if [[ -t 1 ]]; then
    OK="✓"; WARN="⚠"; ERR="✗"
    BOLD="\033[1m"; RESET="\033[0m"
else
    OK="OK"; WARN="WARNING"; ERR="ERROR"
    BOLD=""; RESET=""
fi

log_ok()   { echo "  $OK $*"; }
log_warn() { echo "  $WARN $*"; }
log_err()  { echo "  $ERR $*" >&2; }
log_step() { echo -e "\n${BOLD}[$1/$TOTAL_STEPS] $2${RESET}"; }

cleanup() {
    for dir in "${CLEANUP_DIRS[@]}"; do
        [[ -d "$dir" ]] && rm -rf "$dir"
    done
}
trap cleanup EXIT

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

HyDE Dotfiles Setup v$VERSION
Applies custom configs for Arch Linux + HyDE (Hyprland).

Options:
  --help        Show this help message
  --dry-run     Show what would be done without making changes
  --no-sddm     Skip SDDM theme setup (no sudo required)

Steps:
  1. Copy user configs to ~/.config/ and ~/.local/
  2. Regenerate dunst + restart waybar
  3. Apply extras (.gitconfig, .ssh/config)
  4. Install packages from packages.lst
  5. Install and configure SDDM Silent theme (requires sudo)
EOF
    exit 0
}

# --- Parse arguments ---------------------------------------------------------

DRY_RUN=false
SKIP_SDDM=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help)    usage ;;
        --dry-run) DRY_RUN=true; shift ;;
        --no-sddm) SKIP_SDDM=true; shift ;;
        *) log_err "Unknown option: $1"; usage ;;
    esac
done

TOTAL_STEPS=5
[[ "$SKIP_SDDM" == true ]] && TOTAL_STEPS=4

# --- Dependency checks -------------------------------------------------------

check_command() {
    if ! command -v "$1" &>/dev/null; then
        log_err "'$1' is required but not found"
        return 1
    fi
}

echo -e "${BOLD}=== HyDE Dotfiles Setup v$VERSION ===${RESET}"
echo "Repo: $REPO_DIR"
[[ "$DRY_RUN" == true ]] && echo "Mode: DRY RUN (no changes will be made)"

# Warn about sudo early if SDDM is not skipped
if [[ "$SKIP_SDDM" == false ]]; then
    check_command git
    echo ""
    echo "This script requires sudo for SDDM theme setup (step 5)."
    echo "Use --no-sddm to skip. You may be prompted for your password."
    if [[ "$DRY_RUN" == false ]]; then
        if ! sudo -v 2>/dev/null; then
            log_err "sudo access required for SDDM setup. Run with --no-sddm to skip."
            exit 1
        fi
    fi
fi

# =============================================================================
# Step 1: Apply user configs
# =============================================================================
STEP=1
log_step $STEP "Aplicando configs de usuario..."

if [[ -d "$REPO_DIR/configs/.config" ]]; then
    mkdir -p "$HOME_DIR/.config"
    if [[ "$DRY_RUN" == true ]]; then
        echo "  Would copy configs/.config/* → ~/.config/"
    else
        cp -af "$REPO_DIR/configs/.config/." "$HOME_DIR/.config/"
        log_ok "Configs aplicadas en ~/.config/"
    fi
else
    log_warn "Directorio configs/.config no encontrado"
fi

if [[ -d "$REPO_DIR/configs/.local" ]]; then
    mkdir -p "$HOME_DIR/.local"
    if [[ "$DRY_RUN" == true ]]; then
        echo "  Would copy configs/.local/* → ~/.local/"
    else
        cp -af "$REPO_DIR/configs/.local/." "$HOME_DIR/.local/"
        log_ok "Configs aplicadas en ~/.local/"
    fi
fi

# =============================================================================
# Step 2: Regenerate dunst + restart waybar
# =============================================================================
STEP=2
log_step $STEP "Regenerando dunst y reiniciando waybar..."

if [[ "$DRY_RUN" == true ]]; then
    echo "  Would run: hyde-shell wallbash dunst"
    echo "  Would run: killall waybar"
else
    if command -v hyde-shell &>/dev/null; then
        hyde-shell wallbash dunst 2>/dev/null && log_ok "dunstrc regenerado" || log_warn "Ejecutar manualmente: hyde-shell wallbash dunst"
    else
        log_warn "hyde-shell no encontrado, omitiendo regeneración de dunst"
    fi

    killall waybar 2>/dev/null && log_ok "waybar reiniciado (HyDE lo relanzará)" || true
fi

# =============================================================================
# Step 3: Apply extras (.gitconfig, .ssh/config)
# =============================================================================
STEP=3
log_step $STEP "Aplicando dotfiles extras..."

if [[ -f "$REPO_DIR/extras/.gitconfig" ]]; then
    if [[ -f "$HOME_DIR/.gitconfig" ]]; then
        log_warn "~/.gitconfig ya existe — revisa: diff -u ~/.gitconfig $REPO_DIR/extras/.gitconfig"
    elif [[ "$DRY_RUN" == false ]]; then
        cp "$REPO_DIR/extras/.gitconfig" "$HOME_DIR/.gitconfig"
        log_ok ".gitconfig copiado"
    else
        echo "  Would copy extras/.gitconfig → ~/.gitconfig"
    fi
fi

if [[ -f "$REPO_DIR/extras/.ssh/config" ]]; then
    if [[ -f "$HOME_DIR/.ssh/config" ]]; then
        log_warn "~/.ssh/config ya existe — revisa: diff -u ~/.ssh/config $REPO_DIR/extras/.ssh/config"
    elif [[ "$DRY_RUN" == false ]]; then
        mkdir -p "$HOME_DIR/.ssh"
        chmod 700 "$HOME_DIR/.ssh"
        cp "$REPO_DIR/extras/.ssh/config" "$HOME_DIR/.ssh/config"
        chmod 600 "$HOME_DIR/.ssh/config"
        log_ok "SSH config copiado"
    else
        echo "  Would copy extras/.ssh/config → ~/.ssh/config"
    fi
fi

# =============================================================================
# Step 4: Install packages
# =============================================================================
STEP=4
log_step $STEP "Instalando paquetes extra..."

if command -v yay &>/dev/null; then
    if [[ -f "$REPO_DIR/packages.lst" ]]; then
        # Filter comments, blank lines, and validate package names
        packages=$(grep -v '^\s*#' "$REPO_DIR/packages.lst" | grep -v '^\s*$' | grep -P '^[a-zA-Z0-9][a-zA-Z0-9._+-]*$' || true)
        if [[ -n "$packages" ]]; then
            if [[ "$DRY_RUN" == true ]]; then
                echo "  Would install $(echo "$packages" | wc -l) packages via yay"
            else
                echo "$packages" | yay -S --needed --noconfirm - || log_warn "Algunos paquetes fallaron — revisa el output"
                log_ok "Paquetes procesados"
            fi
        else
            log_warn "packages.lst está vacío o no tiene paquetes válidos"
        fi
    else
        log_warn "packages.lst no encontrado"
    fi
else
    log_warn "yay no encontrado (solo disponible en Arch/Manjaro)"
fi

# =============================================================================
# Step 5: SDDM Silent theme
# =============================================================================
if [[ "$SKIP_SDDM" == false ]]; then
    STEP=5
    log_step $STEP "Configurando SDDM Silent theme..."

    SDDM_THEME_DIR="/usr/share/sddm/themes/silent"
    SDDM_CONF_DIR="/etc/sddm.conf.d"

    # 5a. Install theme if not present
    if [[ -d "$SDDM_THEME_DIR" ]]; then
        log_ok "SDDM Silent theme ya está instalado"
    else
        if [[ "$DRY_RUN" == true ]]; then
            echo "  Would clone SilentSDDM and install to $SDDM_THEME_DIR"
        else
            TEMP_DIR=$(mktemp -d)
            CLEANUP_DIRS+=("$TEMP_DIR")
            git clone --depth 1 https://github.com/uiriansan/SilentSDDM.git "$TEMP_DIR/SilentSDDM"
            if [[ -d "$TEMP_DIR/SilentSDDM/silent" ]]; then
                sudo cp -r "$TEMP_DIR/SilentSDDM/silent" "$SDDM_THEME_DIR"
                sudo chmod -R 755 "$SDDM_THEME_DIR"
                sudo chown -R root:root "$SDDM_THEME_DIR"
                log_ok "SDDM Silent theme instalado"
            else
                log_err "El repo SilentSDDM no contiene el directorio 'silent/'"
            fi
        fi
    fi

    # 5b. Configure SDDM to use Silent theme
    if [[ "$DRY_RUN" == true ]]; then
        echo "  Would configure SDDM to use Silent theme with rei variant"
    else
        sudo mkdir -p "$SDDM_CONF_DIR"

        if ! grep -rq "Current=silent" "$SDDM_CONF_DIR"/ 2>/dev/null; then
            sudo tee "$SDDM_CONF_DIR/theme.conf" > /dev/null <<'SDDMEOF'
[Theme]
Current=silent

[General]
InputMethod=qtvirtualkeyboard
GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard
SDDMEOF
            log_ok "SDDM configurado para usar Silent theme"
        else
            log_ok "SDDM ya usa Silent theme"
        fi

        # 5c. Configure rei variant in metadata.desktop
        METADATA_FILE="$SDDM_THEME_DIR/metadata.desktop"
        if [[ -f "$METADATA_FILE" ]]; then
            if grep -q "^ConfigFile=configs/rei.conf" "$METADATA_FILE"; then
                log_ok "SDDM Silent ya usa variante 'rei'"
            else
                sudo sed -i.bak '/^ConfigFile=/s/^/#/' "$METADATA_FILE"
                if grep -q "^#ConfigFile=configs/rei.conf" "$METADATA_FILE"; then
                    sudo sed -i 's|^#ConfigFile=configs/rei.conf|ConfigFile=configs/rei.conf|' "$METADATA_FILE"
                else
                    echo "ConfigFile=configs/rei.conf" | sudo tee -a "$METADATA_FILE" > /dev/null
                fi
                log_ok "SDDM Silent configurado con variante 'rei'"
            fi
        else
            log_warn "metadata.desktop no encontrado — configurar manualmente"
        fi
    fi
fi

# =============================================================================
# Done
# =============================================================================
echo ""
echo -e "${BOLD}=== Setup completo! ===${RESET}"
echo ""
echo "Próximos pasos:"
echo "  1. Reinicia tu shell: source ~/.zshrc"
echo "  2. Configura variables de entorno en ~/.config/zsh/user.zsh:"
echo "     export ANTHROPIC_AUTH_TOKEN=\"tu-token-aqui\""
echo "  3. Verifica archivos mergeados: .gitconfig, .ssh/config"
echo "  4. Selecciona waybar layout: hyde-shell waybar --select"
if [[ "$SKIP_SDDM" == false ]]; then
    echo "  5. Reinicia SDDM para ver cambios: sudo systemctl restart sddm"
fi
echo ""
echo "Fuentes requeridas (instaladas via packages.lst):"
echo "  mononoki Nerd Font, Red Hat Display, CaskaydiaCove Nerd Font Mono"
