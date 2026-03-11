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
```

## Estructura del repo

```
my-hyde-dotfiles/
├── configs/.config/    # Archivos preserved de HyDE customizados
│   ├── zsh/           # Alias y funciones personales
│   ├── hypr/          # Configuración de hyprlock
│   ├── kitty/         # Terminal emulator config
│   ├── rofi/          # Tema personalizado
│   ├── fastfetch/     # Logo y módulos custom
│   └── starship/      # Prompt theme (TokyoNight)
├── extras/            # Dotfiles fuera de HyDE
│   ├── .gitconfig     # Config de Git
│   └── .ssh/config    # SSH multi-cuenta
├── packages.lst       # Paquetes extra (no incluidos en HyDE)
├── setup.sh           # Script de instalación
└── README.md
```

## Archivos incluidos

### HyDE Preserved (customizados)

| Archivo | Descripción |
|---------|-------------|
| `zsh/user.zsh` | Alias de navegación, funciones `mkpersonal`/`mkwork`, configuración de Anthropic |
| `hypr/hyprlock.conf` | Layout personalizado (`greetd-wallbash.conf`) |
| `kitty/kitty.conf` | Tab bar powerline, URLs con estilo custom |
| `rofi/theme.rasi` | Tema con paleta TokyoNight |
| `fastfetch/config.jsonc` | Logo personalizado (Pokémon) |
| `starship/starship.toml` | Prompt extenso con 40+ módulos de lenguajes |

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

## Excluidos intencionalmente

Los siguientes archivos **NO** se incluyen porque son específicos de cada hardware/setup:

- `hypr/monitors.conf` - Configuración de monitores (generada por `nwg-displays`)
- `hypr/hypridle.conf` - Timeouts de idle (configuración personal)
- `waybar/config.jsonc` - Layout de waybar (depende del setup)

## Seguridad

Este repo **NO** contiene:
- ❌ Tokens ni contraseñas hardcodeados
- ❌ Keys SSH privadas o públicas
- ❌ Archivos `.env` ni credenciales

Los tokens deben configurarse como variables de entorno después de instalar.

## Actualizar setup existente

```bash
cd ~/my-hyde-dotfiles
git pull
./setup.sh
```

El script es idempotente: puedes ejecutarlo múltiples veces sin riesgo.
