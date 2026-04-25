#!/bin/bash
set -euo pipefail

# =============================================================================
# HyDE Dotfiles Setup
# Idempotent install script for Arch Linux + HyDE (Hyprland)
# =============================================================================

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
HOME_DIR="$HOME"
VERSION="1.9.0"
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
  --no-grub     Skip GRUB theme setup (no sudo required)

Steps:
  1. Copy user configs to ~/.config/ and ~/.local/
  2. Sync waybar configs (layouts, modules, styles) + auto-select layout
  3. Regenerate dunst + restart waybar
  4. Apply extras (.gitconfig, .ssh/config)
  5. Install packages from packages.lst
  6. Install and configure SDDM Silent theme (requires sudo)
  7. Install Elegant GRUB theme (requires sudo)
EOF
    exit 0
}

# --- Parse arguments ---------------------------------------------------------

DRY_RUN=false
SKIP_SDDM=false
SKIP_GRUB=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help)    usage ;;
        --dry-run) DRY_RUN=true; shift ;;
        --no-sddm) SKIP_SDDM=true; shift ;;
        --no-grub) SKIP_GRUB=true; shift ;;
        *) log_err "Unknown option: $1"; usage ;;
    esac
done

TOTAL_STEPS=7
[[ "$SKIP_SDDM" == true ]] && TOTAL_STEPS=$((TOTAL_STEPS - 1))
[[ "$SKIP_GRUB" == true ]] && TOTAL_STEPS=$((TOTAL_STEPS - 1))

# --- Dependency checks -------------------------------------------------------

check_command() {
    if ! command -v "$1" &>/dev/null; then
        log_err "'$1' is required but not found"
        return 1
    fi
}

# Preflight checks - run before any installation
preflight() {
    echo -e "\n${BOLD}[preflight] Running checks...${RESET}"
    local missing=()
    local cmds=(git cp mkdir sed tee sudo bash diff)

    for cmd in "${cmds[@]}"; do
        command -v "$cmd" &>/dev/null || missing+=("$cmd")
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        log_err "Missing commands: ${missing[*]}"
        log_err "Install missing commands and re-run setup"
        return 1
    fi

    # Check for AUR helper (yay or paru)
    if ! command -v yay &>/dev/null && ! command -v paru &>/dev/null; then
        log_warn "No AUR helper found (yay or paru required for package install)"
        log_warn "Install yay or paru, or run with --no-sddm --no-grub and skip package install"
    fi

    # Check disk space (need ~2GB free)
    local available_kb
    available_kb=$(df -k "$HOME_DIR" 2>/dev/null | awk 'NR==2 {print $4}') || true
    if [[ -n "$available_kb" ]] && [[ "$available_kb" -lt 2000000 ]]; then
        log_warn "Low disk space (< 2GB free)"
    fi

    log_ok "Preflight checks passed"

    # Initialize git submodules (wallpapers and other tracked submodules)
    if git -C "$REPO_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        if [[ "$DRY_RUN" == true ]]; then
            echo "  Would run: git submodule update --init --recursive"
        else
            git -C "$REPO_DIR" submodule update --init --recursive
            log_ok "Git submodules initialized"
        fi
    fi
}

backup_configs() {
    local backup_dir failed=0
    backup_dir="$HOME_DIR/.config/cfg_backups/my-hyde-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    for dir in hypr waybar dunst kitty fastfetch starship zsh hyde; do
        if [[ -d "$HOME_DIR/.config/$dir" ]]; then
            if ! cp -a "$HOME_DIR/.config/$dir" "$backup_dir/" 2>/dev/null; then
                log_warn "Failed to backup $dir"
                failed=1
            fi
        fi
    done
    if [[ -d "$HOME_DIR/.local/share/waybar" ]]; then
        mkdir -p "$backup_dir/.local/share"
        if ! cp -a "$HOME_DIR/.local/share/waybar" "$backup_dir/.local/share/" 2>/dev/null; then
            log_warn "Failed to backup waybar styles"
            failed=1
        fi
    fi
    # Verify backup has content
    if [[ ! "$(ls -A "$backup_dir")" ]]; then
        log_warn "Backup directory is empty"
        failed=1
    fi
    echo "$backup_dir"
    return $failed
}

echo -e "${BOLD}=== HyDE Dotfiles Setup v$VERSION ===${RESET}"
echo "Repo: $REPO_DIR"
[[ "$DRY_RUN" == true ]] && echo "Mode: DRY RUN (no changes will be made)"

# Preflight checks
if ! preflight; then
    exit 1
fi

# Warn about sudo early if SDDM or GRUB is not skipped
if [[ "$SKIP_SDDM" == false || "$SKIP_GRUB" == false ]]; then
    echo ""
    echo "This script requires sudo for theme setup (SDDM/GRUB)."
    echo "Use --no-sddm and/or --no-grub to skip. You may be prompted for your password."
    if [[ "$DRY_RUN" == false ]]; then
        if ! sudo -v 2>/dev/null; then
            log_err "sudo access required. Run with --no-sddm --no-grub to skip."
            exit 1
        fi
    fi
fi

# =============================================================================
# Step 0: Backup current configs
# =============================================================================
log_step "0" "Backing up current configs..."

if [[ "$DRY_RUN" == true ]]; then
    echo "  Would backup current configs to ~/.config/cfg_backups/"
else
    BACKUP_DIR=$(backup_configs)
    log_ok "Backup created at $BACKUP_DIR"
fi

# =============================================================================
# Step 1: Apply user configs
# =============================================================================
STEP=1
log_step "$STEP" "Applying user configs..."

if [[ -d "$REPO_DIR/configs/.config" ]]; then
    mkdir -p "$HOME_DIR/.config"
    if [[ "$DRY_RUN" == true ]]; then
        echo "  Would copy configs/.config/* → ~/.config/"
        echo "  Would preserve: ~/.config/zsh/user.local.zsh (machine-specific)"
    else
        # Preserve machine-specific files before copying
        if [[ -f "$HOME_DIR/.config/zsh/user.local.zsh" ]]; then
            cp "$HOME_DIR/.config/zsh/user.local.zsh" "$HOME_DIR/.config/zsh/user.local.zsh.bak"
        fi

        cp -af "$REPO_DIR/configs/.config/." "$HOME_DIR/.config/"
        log_ok "Configs applied to ~/.config/"

        # Restore machine-specific files
        if [[ -f "$HOME_DIR/.config/zsh/user.local.zsh.bak" ]]; then
            mv "$HOME_DIR/.config/zsh/user.local.zsh.bak" "$HOME_DIR/.config/zsh/user.local.zsh"
            log_ok "user.local.zsh preserved (machine-specific)"
        fi

        # Rebuild bat theme cache if bat themes were copied
        if [[ -d "$HOME_DIR/.config/bat/themes" ]] && command -v bat &>/dev/null; then
            bat cache --build &>/dev/null && log_ok "bat theme cache rebuilt" || log_warn "bat cache --build failed"
        fi
    fi
else
    log_warn "configs/.config directory not found"
fi

if [[ -d "$REPO_DIR/configs/.local" ]]; then
    mkdir -p "$HOME_DIR/.local"
    if [[ "$DRY_RUN" == true ]]; then
        echo "  Would copy configs/.local/* → ~/.local/"
    else
        cp -af "$REPO_DIR/configs/.local/." "$HOME_DIR/.local/"
        log_ok "Configs applied to ~/.local/"
    fi
fi

# =============================================================================
# Step 2: Sync waybar configs (layouts, modules, styles)
# =============================================================================
STEP=2
log_step "$STEP" "Syncing waybar configs..."

if [[ -d "$REPO_DIR/configs/.config/waybar" ]]; then
    if [[ "$DRY_RUN" == true ]]; then
        echo "  Would sync waybar layouts, modules, and styles..."
    else
        # Sync layouts
        if [[ -d "$REPO_DIR/configs/.config/waybar/layouts" ]]; then
            mkdir -p "$HOME_DIR/.config/waybar/layouts"
            cp -af "$REPO_DIR/configs/.config/waybar/layouts/"* "$HOME_DIR/.config/waybar/layouts/" 2>/dev/null || true
        fi

        # Sync modules
        if [[ -d "$REPO_DIR/configs/.config/waybar/modules" ]]; then
            mkdir -p "$HOME_DIR/.config/waybar/modules"
            cp -af "$REPO_DIR/configs/.config/waybar/modules/"* "$HOME_DIR/.config/waybar/modules/" 2>/dev/null || true
        fi

        # Sync styles
        if [[ -d "$REPO_DIR/configs/.local/share/waybar/styles" ]]; then
            mkdir -p "$HOME_DIR/.local/share/waybar/styles"
            cp -af "$REPO_DIR/configs/.local/share/waybar/styles/"* "$HOME_DIR/.local/share/waybar/styles/" 2>/dev/null || true
        fi

        # Sync includes
        if [[ -d "$REPO_DIR/configs/.config/waybar/includes" ]]; then
            mkdir -p "$HOME_DIR/.config/waybar/includes"
            cp -af "$REPO_DIR/configs/.config/waybar/includes/"* "$HOME_DIR/.config/waybar/includes/" 2>/dev/null || true
        fi

        # Copy theme files (force update)
        cp -f "$REPO_DIR/configs/.config/waybar/theme.css" "$HOME_DIR/.config/waybar/" 2>/dev/null || true
        cp -f "$REPO_DIR/configs/.config/waybar/user-style.css" "$HOME_DIR/.config/waybar/" 2>/dev/null || true

        log_ok "Waybar configs synced"
    fi
else
    log_warn "Waybar directory not found in repo"
fi

# Auto-select cyberdeck-nerv layout if available
if [[ -f "$HOME_DIR/.config/waybar/layouts/cyberdeck-nerv.jsonc" ]]; then
    if [[ "$DRY_RUN" == true ]]; then
        echo "  Would auto-select cyberdeck-nerv layout"
    else
        # Prevent "same file" error if it's already a symlink or identical
        if [[ ! "$HOME_DIR/.config/waybar/layouts/cyberdeck-nerv.jsonc" -ef "$HOME_DIR/.config/waybar/config.jsonc" ]]; then
            cp -f "$HOME_DIR/.config/waybar/layouts/cyberdeck-nerv.jsonc" "$HOME_DIR/.config/waybar/config.jsonc"
            log_ok "cyberdeck-nerv layout auto-selected"
        else
            log_ok "cyberdeck-nerv layout already selected"
        fi
    fi
fi

# Sync dunst icons
if [[ -d "$REPO_DIR/configs/.config/dunst/icons" ]]; then
    if [[ "$DRY_RUN" == true ]]; then
        echo "  Would sync dunst icons..."
    else
        mkdir -p "$HOME_DIR/.config/dunst/icons"
        cp -af "$REPO_DIR/configs/.config/dunst/icons/"* "$HOME_DIR/.config/dunst/icons/" 2>/dev/null || true
        log_ok "Dunst icons synced"
    fi
else
    log_warn "Dunst icons directory not found in repo"
fi

# Sync wlogout layout and style
if [[ -d "$REPO_DIR/configs/.config/wlogout" ]]; then
    if [[ "$DRY_RUN" == true ]]; then
        echo "  Would sync wlogout layout and style..."
    else
        mkdir -p "$HOME_DIR/.config/wlogout"
        cp -f "$REPO_DIR/configs/.config/wlogout/layout_1" "$HOME_DIR/.config/wlogout/layout_1"
        cp -f "$REPO_DIR/configs/.config/wlogout/style_1.css" "$HOME_DIR/.config/wlogout/style_1.css"
        log_ok "wlogout layout and style synced"
    fi
else
    log_warn "wlogout directory not found in repo"
fi

# =============================================================================
# Step 3: Regenerate dunst + restart waybar
# =============================================================================
STEP=3
log_step "$STEP" "Regenerating dunst and restarting waybar..."

if [[ "$DRY_RUN" == true ]]; then
    echo "  Would run: hyde-shell wallbash dunst"
    echo "  Would patch: urgency_critical timeout 0 → 15 in dunstrc"
    echo "  Would inject: [urgency_critical] timeout = 15 into wallbash cache"
    echo "  Would run: killall waybar"
else
    if command -v hyde-shell &>/dev/null; then
        hyde-shell wallbash dunst 2>/dev/null && log_ok "dunstrc regenerated" || log_warn "Run manually: hyde-shell wallbash dunst"
        # Patch: HyDE sets urgency_critical timeout = 0 (never dismiss), override to 15s
        # 1) Immediate fix: patch current dunstrc
        if [[ -f "$HOME_DIR/.config/dunst/dunstrc" ]]; then
            sed -i '/^\[urgency_critical\]$/,/^timeout = 0$/{s/^timeout = 0$/timeout = 15/}' "$HOME_DIR/.config/dunst/dunstrc"
            log_ok "urgency_critical timeout patched to 15s"
        fi
        # 2) Permanent fix: inject into wallbash cache so every regeneration includes it
        WALLBASH_DUNST="${XDG_CACHE_HOME:-$HOME_DIR/.cache}/hyde/wallbash/dunst.conf"
        if [[ -f "$WALLBASH_DUNST" ]] && ! grep -q '^\[urgency_critical\]' "$WALLBASH_DUNST"; then
            printf '\n[urgency_critical]\n    timeout = 15\n' >> "$WALLBASH_DUNST"
            log_ok "urgency_critical timeout injected into wallbash cache (permanent)"
        fi
    else
        log_warn "hyde-shell not found, skipping dunst regeneration"
    fi

    killall waybar 2>/dev/null && log_ok "waybar reiniciado (HyDE lo relanzará)" || true
fi

# =============================================================================
# Step 4: Apply extras (.gitconfig, .ssh/config)
# =============================================================================
STEP=4
log_step "$STEP" "Applying extra dotfiles..."

if [[ -f "$REPO_DIR/extras/.gitconfig" ]]; then
    if [[ -f "$HOME_DIR/.gitconfig" ]]; then
        log_warn "$HOME/.gitconfig ya existe — revisa: diff -u $HOME/.gitconfig $REPO_DIR/extras/.gitconfig"
    elif [[ "$DRY_RUN" == false ]]; then
        cp "$REPO_DIR/extras/.gitconfig" "$HOME_DIR/.gitconfig"
        log_ok ".gitconfig copiado"
    else
        echo "  Would copy extras/.gitconfig → ~/.gitconfig"
    fi
fi

if [[ -f "$REPO_DIR/extras/.ssh/config" ]]; then
    if [[ -f "$HOME_DIR/.ssh/config" ]]; then
        log_warn "$HOME/.ssh/config ya existe — revisa: diff -u $HOME/.ssh/config $REPO_DIR/extras/.ssh/config"
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
# Step 5: Install packages
# =============================================================================
STEP=5
log_step "$STEP" "Installing extra packages..."

if command -v yay &>/dev/null; then
    if [[ -f "$REPO_DIR/packages.lst" ]]; then
        # Filter comments, blank lines, and validate package names
        packages=$(grep -v '^\s*#' "$REPO_DIR/packages.lst" | grep -v '^\s*$' | grep -P '^[a-zA-Z0-9][a-zA-Z0-9._+-]*$' || true)
        if [[ -n "$packages" ]]; then
            if [[ "$DRY_RUN" == true ]]; then
                echo "  Would install $(echo "$packages" | wc -l) packages via yay"
            else
                echo "$packages" | yay -S --needed --noconfirm - || log_warn "Some packages failed — check output"
                log_ok "Packages processed"
            fi
        else
            log_warn "packages.lst is empty or has no valid packages"
        fi
    else
        log_warn "packages.lst no encontrado"
    fi
else
    log_warn "yay no encontrado (solo disponible en Arch/Manjaro)"
fi

# =============================================================================
# Step 6: SDDM Silent theme
# =============================================================================
if [[ "$SKIP_SDDM" == false ]]; then
    STEP=6
    log_step "$STEP" "Configuring SDDM Silent theme..."

    SDDM_THEME_DIR="/usr/share/sddm/themes/silent"
    SDDM_CONF_DIR="/etc/sddm.conf.d"

    SILENT_SDDM_TAG="v1.4.2"

    # 6a. Install theme if not present
    if [[ -d "$SDDM_THEME_DIR" ]]; then
        log_ok "SDDM Silent theme already installed"
    else
        if [[ "$DRY_RUN" == true ]]; then
            echo "  Would clone SilentSDDM $SILENT_SDDM_TAG and install to $SDDM_THEME_DIR"
        else
            SDDM_TEMP=$(mktemp -d)
            CLEANUP_DIRS+=("$SDDM_TEMP")
            if git clone --depth 1 --branch "$SILENT_SDDM_TAG" https://github.com/uiriansan/SilentSDDM.git "$SDDM_TEMP/SilentSDDM"; then
                if [[ -f "$SDDM_TEMP/SilentSDDM/metadata.desktop" ]]; then
                    sudo mkdir -p "$SDDM_THEME_DIR"
                    sudo cp -r "$SDDM_TEMP/SilentSDDM/." "$SDDM_THEME_DIR"
                    sudo rm -rf "$SDDM_THEME_DIR/.git"  # strip git metadata from installed theme
                    sudo chmod -R 755 "$SDDM_THEME_DIR"
                    sudo chown -R root:root "$SDDM_THEME_DIR"
                    log_ok "SDDM Silent theme installed"
                else
                    log_err "SilentSDDM repo missing metadata.desktop (unexpected layout)"
                fi
            else
                log_warn "Could not clone SilentSDDM — check internet connection"
            fi
        fi
    fi

    # 6b. Configure SDDM to use Silent theme
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
            log_ok "SDDM configured to use Silent theme"
        else
            log_ok "SDDM already uses Silent theme"
        fi

        # 6c. Configure rei variant in metadata.desktop
        METADATA_FILE="$SDDM_THEME_DIR/metadata.desktop"
        if [[ -f "$METADATA_FILE" ]]; then
            if grep -q "^ConfigFile=configs/rei.conf" "$METADATA_FILE"; then
                log_ok "SDDM Silent already uses 'rei' variant"
            else
                sudo sed -i '/^[#]*ConfigFile=/d' "$METADATA_FILE"
                echo "ConfigFile=configs/rei.conf" | sudo tee -a "$METADATA_FILE" > /dev/null
                log_ok "SDDM Silent configured with 'rei' variant"
            fi
        else
            log_warn "metadata.desktop not found — configure manually"
        fi
    fi
fi

# =============================================================================
# Step 7: GRUB Elegant theme
# =============================================================================
if [[ "$SKIP_GRUB" == false ]]; then
    STEP=7
    log_step "$STEP" "Installing GRUB Elegant theme..."

    ELEGANT_GRUB_TAG="2025-03-25"  # upstream switched to date-based tags after v2.4.0

    GRUB_THEME_DIR="/usr/share/grub/themes/Elegant-mojave-float-left-dark"
    GRUB_INSTALLED=false

    if [[ -d "$GRUB_THEME_DIR" ]]; then
        log_ok "GRUB Elegant theme already installed"
    else
        if [[ "$DRY_RUN" == true ]]; then
            echo "  Would clone Elegant-grub2-themes $ELEGANT_GRUB_TAG and install mojave-float-left-dark"
            echo "  Would run: sudo grub-mkconfig -o /boot/grub/grub.cfg"
        else
            GRUB_TEMP=$(mktemp -d)
            CLEANUP_DIRS+=("$GRUB_TEMP")
            if git clone --depth 1 --branch "$ELEGANT_GRUB_TAG" https://github.com/vinceliuice/Elegant-grub2-themes.git "$GRUB_TEMP/Elegant-grub2-themes"; then
                if [[ -f "$GRUB_TEMP/Elegant-grub2-themes/install.sh" ]]; then
                    if (cd "$GRUB_TEMP/Elegant-grub2-themes" && sudo bash install.sh -t mojave -p float -i left -c dark); then
                        log_ok "GRUB Elegant theme installed (mojave-float-left-dark)"
                        GRUB_INSTALLED=true
                    else
                        log_err "install.sh failed — GRUB theme not installed"
                    fi
                else
                    log_err "Elegant-grub2-themes repo does not contain install.sh"
                fi
            else
                log_warn "Could not clone Elegant-grub2-themes — check internet connection"
            fi
        fi
    fi

    # Regenerate GRUB config only after successful install
    if [[ "$GRUB_INSTALLED" == true ]]; then
        sudo grub-mkconfig -o /boot/grub/grub.cfg && log_ok "GRUB config regenerated" || log_warn "Run manually: sudo grub-mkconfig -o /boot/grub/grub.cfg"
    fi
fi

# =============================================================================
# Done
# =============================================================================
echo ""
echo -e "${BOLD}=== Setup complete! ===${RESET}"
echo ""
echo "Next steps:"
echo "  1. Restart your shell: source ~/.zshrc"
echo "  2. Configure environment variables in ~/.config/zsh/user.local.zsh:"
echo "     export ANTHROPIC_AUTH_TOKEN=\"your-token-here\""
echo "  3. Check merged files: .gitconfig, .ssh/config"
echo "  4. Select waybar layout: hyde-shell waybar --select"
if [[ "$SKIP_SDDM" == false ]]; then
    echo "  5. Restart SDDM to see changes: sudo systemctl restart sddm"
fi
if [[ "$SKIP_GRUB" == false ]]; then
    echo "  6. Reboot to see GRUB theme"
fi
echo ""
echo "Required fonts (installed via packages.lst):"
echo "  mononoki Nerd Font, Red Hat Display, CaskaydiaCove Nerd Font Mono"
