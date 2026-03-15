# My HyDE Dotfiles

Mis configuraciones custom de HyDE para replicar mi setup en otra máquina.

## Requisitos

- Arch Linux (o derivado con `yay`)
- HyDE instalado (`~/HyDE`)
- zsh como shell predeterminado

## Instalación rápida

```bash
# Clonar y ejecutar setup
git clone https://github.com/TU-USUARIO/my-hyde-dotfiles.git ~/my-hyde-dotfiles
cd ~/my-hyde-dotfiles
./setup.sh

# Opciones disponibles
./setup.sh --help       # Ver ayuda
./setup.sh --dry-run    # Ver qué haría sin hacer cambios
./setup.sh --no-sddm    # Omitir setup de SDDM (no requiere sudo)
```

## Estructura del repo

```
my-hyde-dotfiles/
├── configs/
│   ├── .config/
│   │   ├── zsh/                      # Alias y funciones personales
│   │   ├── hypr/
│   │   │   ├── hyprlock.conf         # Pointer → silent-rei layout
│   │   │   ├── hyprlock/silent-rei.conf  # Lock screen custom (lavender/dark)
│   │   │   ├── hyprlock/backgrounds/ # rei.png + profile_square.png
│   │   │   └── userprefs.conf        # Teclado latam, touchpad, swallowing
│   │   ├── kitty/                    # Terminal emulator config
│   │   ├── rofi/                     # Tema personalizado
│   │   ├── fastfetch/                # Logo y módulos custom
│   │   ├── starship/                 # Prompt theme (TokyoNight)
│   │   ├── hyde/config.toml          # HyDE config (clima, cursor)
│   │   ├── dunst/                    # Notificaciones custom + Gengar icon
│   │   ├── waybar/
│   │   │   ├── modules/              # Módulos: network, nerv, uptime, separators, claude-code
│   │   │   ├── layouts/              # Layout cyberdeck-nerv
│   │   │   ├── theme.css             # Tokyo Night color definitions
│   │   │   └── user-style.css        # CSS overrides custom
│   │   └── git/ignore                # Git global ignore
│   └── .local/share/waybar/styles/   # CSS del tema cyberdeck-nerv
├── extras/
│   ├── .gitconfig                    # Config de Git
│   └── .ssh/config                   # SSH multi-cuenta
├── packages.lst                      # Paquetes extra (no incluidos en HyDE)
├── setup.sh                          # Script de instalación
└── README.md
```

## Archivos incluidos

### Hyprland

| Archivo | Descripción |
|---------|-------------|
| `hypr/hyprlock.conf` | Pointer al layout silent-rei |
| `hypr/hyprlock/silent-rei.conf` | Lock screen dark + lavender (#C3C6FB), matchea SDDM Silent rei |
| `hypr/userprefs.conf` | Teclado latam/us (Super+Space), touchpad natural scroll, window swallowing, gnome-keyring |

### Waybar

| Archivo | Descripción |
|---------|-------------|
| `waybar/layouts/cyberdeck-nerv.jsonc` | Layout Tokyo Night cyberpunk — seleccionable en HyDE |
| `waybar/modules/network.jsonc` | Network fijado a wlo1, click derecho abre nm-connection-editor |
| `waybar/modules/custom-nerv.jsonc` | MAGI.SYS identifier con tooltip hostname/kernel/IP |
| `waybar/modules/custom-uptime.jsonc` | SYS.ONLINE uptime display |
| `waybar/modules/custom-separator.jsonc` | Separadores con variantes (l1, l2, c1, r1-r4) |
| `waybar/modules/custom-claude-code.jsonc` | Módulo Claude CLI — click abre terminal con claude |
| `waybar/theme.css` | Variables de color Tokyo Night para waybar |
| `waybar/user-style.css` | CSS overrides custom (claude-code styling) |
| `.local/share/waybar/styles/cyberdeck-nerv.css` | CSS del tema: micro-pills, neon glow, colores TokyoNight |

### Notificaciones

| Archivo | Descripción |
|---------|-------------|
| `dunst/dunst.conf` | Brave auto-dismiss 10s, Gengar como ícono default |
| `dunst/icons/gengar.png` | Ícono Gengar con transparencia |

### Shell y Terminal

| Archivo | Descripción |
|---------|-------------|
| `zsh/user.zsh` | Alias de navegación, funciones `mkpersonal`/`mkwork`, NVM setup |
| `kitty/kitty.conf` | Tab bar powerline, URLs con estilo custom |
| `starship/starship.toml` | Prompt extenso con 40+ módulos de lenguajes |
| `fastfetch/config.jsonc` | Logo personalizado (Pokémon) |

### Tema y Apariencia

| Archivo | Descripción |
|---------|-------------|
| `hyde/config.toml` | Clima en Celsius, San Salvador, formato 24h |
| `git/ignore` | Global gitignore (excluye .claude/settings.local.json) |

### SDDM (Login Screen)

El setup instala automáticamente el tema [Silent SDDM](https://github.com/uiriansan/SilentSDDM) y lo configura con la variante **rei** (dark + lavender, matchea hyprlock).

### Extras (fuera de HyDE)

| Archivo | Descripción |
|---------|-------------|
| `.gitconfig` | Usuario Git y credential helpers (GitHub + Bitbucket) |
| `.ssh/config` | SSH multi-cuenta (personal/work para GitHub y Bitbucket) |

## Variables de entorno requeridas

Después de instalar, configura en tu `~/.zshrc` o `~/.config/zsh/user.zsh`:

```bash
# Token de Anthropic (requerido para claude-code)
export ANTHROPIC_AUTH_TOKEN="tu-token-aqui"

# URL base (opcional, si usas proxy local)
export ANTHROPIC_BASE_URL="http://localhost:8317"

# Modelo preferido
export ANTHROPIC_DEFAULT_SONNET_MODEL="claude-sonnet-4-5-20250929"
```

## Fuentes requeridas

- **mononoki Nerd Font** — layout cyberdeck-nerv
- **Red Hat Display** — hyprlock silent-rei
- **CaskaydiaCove Nerd Font Mono** — kitty terminal, Qt apps
- **JetBrainsMono Nerd Font** — waybar, hyprlock widgets

Todas se instalan automáticamente via `packages.lst`.

## Excluidos intencionalmente

- `hypr/monitors.conf` — específico de cada hardware (generado por `nwg-displays`)
- `waybar/config.jsonc` — layout de waybar activo (depende del setup)
- Credenciales, tokens, keys SSH

## Seguridad

Este repo **NO** contiene:
- Tokens ni contraseñas hardcodeados
- Keys SSH privadas o públicas
- Archivos `.env` ni credenciales

Los tokens deben configurarse como variables de entorno después de instalar.

## Actualizar setup existente

```bash
cd ~/my-hyde-dotfiles
git pull
./setup.sh
```

El script es idempotente: puedes ejecutarlo múltiples veces sin riesgo.
