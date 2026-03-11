#!/bin/bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
HOME_DIR="$HOME"

echo "=== HyDE Dotfiles Setup ==="
echo "Repo directory: $REPO_DIR"
echo ""

# 1. Aplicar configs de HyDE (solo archivos preserved customizados)
echo "[1/4] Aplicando configs de HyDE..."
if [[ -d "$REPO_DIR/configs/.config" ]]; then
    # Copiar archivos preservados de HyDE (sobreescribe los defaults)
    cp -rf "$REPO_DIR/configs/.config/"* "$HOME_DIR/.config/"
    echo "  ✓ Configs aplicadas en ~/.config/"
else
    echo "  ⚠ Directorio configs/.config no encontrado"
fi

# 2. Aplicar extras (dotfiles fuera de HyDE)
echo ""
echo "[2/4] Aplicando dotfiles extras..."

# Git config
if [[ -f "$REPO_DIR/extras/.gitconfig" ]]; then
    # Fusionar con .gitconfig existente si existe
    if [[ -f "$HOME_DIR/.gitconfig" ]]; then
        echo "  ⚠ ~/.gitconfig ya existe, se fusionará manualmente"
        echo "     Revisa: diff -u ~/.gitconfig $REPO_DIR/extras/.gitconfig"
    else
        cp "$REPO_DIR/extras/.gitconfig" "$HOME_DIR/.gitconfig"
        echo "  ✓ .gitconfig copiado"
    fi
fi

# SSH config
if [[ -f "$REPO_DIR/extras/.ssh/config" ]]; then
    mkdir -p "$HOME_DIR/.ssh"
    chmod 700 "$HOME_DIR/.ssh"
    # Verificar si ya existe config
    if [[ -f "$HOME_DIR/.ssh/config" ]]; then
        echo "  ⚠ ~/.ssh/config ya existe"
        echo "     Revisa: diff -u ~/.ssh/config $REPO_DIR/extras/.ssh/config"
    else
        cp "$REPO_DIR/extras/.ssh/config" "$HOME_DIR/.ssh/config"
        chmod 600 "$HOME_DIR/.ssh/config"
        echo "  ✓ SSH config copiado"
    fi
fi

# 3. Instalar paquetes extra (solo si yay está disponible)
echo ""
echo "[3/4] Instalando paquetes extra..."
if command -v yay &>/dev/null; then
    if [[ -f "$REPO_DIR/packages.lst" ]]; then
        echo "  Instalando paquetes desde packages.lst..."
        yay -S --needed --noconfirm - < "$REPO_DIR/packages.lst"
        echo "  ✓ Paquetes instalados"
    else
        echo "  ⚠ packages.lst no encontrado"
    fi
else
    echo "  ⚠ yay no encontrado (solo disponible en Arch/Manjaro)"
fi

# 4. Post-install: Verificar variables de entorno requeridas
echo ""
echo "[4/4] Verificando variables de entorno..."
echo ""
echo "  IMPORTANTE: Debes configurar las siguientes variables en tu shell RC:"
echo ""
echo "  # Agrega esto a ~/.config/zsh/user.zsh o ~/.zshrc:"
echo "  export ANTHROPIC_AUTH_TOKEN=\"tu-token-aqui\""
echo "  export ANTHROPIC_BASE_URL=\"http://localhost:8317\"  # si usas proxy local"
echo ""

echo "=== Setup completo! ==="
echo ""
echo "Próximos pasos:"
echo "  1. Reinicia tu shell o ejecuta: source ~/.zshrc"
echo "  2. Configura tus variables de entorno (ver arriba)"
echo "  3. Verifica archivos mergeados: .gitconfig, .ssh/config"
echo "  4. Ejecuta: hyde-shell wallpaper --apply  # para aplicar wallpaper"
