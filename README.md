<div align="center">

```
    __  __      ____  ______       __      __  _____ __         
   / / / /_  __/ __ \/ ____/  ____/ /___  / /_/ __(_) /__  _____
  / /_/ / / / / / / / __/    / __  / __ \/ __/ /_/ / / _ \/ ___/
 / __  / /_/ / /_/ / /___   / /_/ / /_/ / /_/ __/ / /  __(__  ) 
/_/ /_/\__, /_____/_____/   \__,_/\____/\__/_/ /_/_/\___/____/  
      /____/                                                    
```

# My HyDE Dotfiles

Reproducible desktop setup with Tokyo Night theme · Waybar cyberdeck-nerv · Dunst notifications · Silent SDDM · Elegant GRUB

</div>

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=flat&logo=arch-linux&logoColor=white)](https://archlinux.org/)
[![Hyprland](https://img.shields.io/badge/Hyprland-Wayland_Compositor-5046e4?style=flat)](https://hyprland.org/)
[![ShellCheck](https://img.shields.io/badge/shellcheck-passing-brightgreen?style=flat)](https://github.com/cativo23/my-hyde-dotfiles/actions)

---

## Overview

**Production-ready HyDE dotfiles** demonstrating enterprise-grade Linux desktop configuration management. This repository provides a reproducible Arch Linux + Hyprland setup with the Tokyo Night theme, featuring automated installation, idempotent configs, and GitFlow-based release management.

> **Why this exists:** This isn't just another dotfiles collection. It's a demonstration of professional infrastructure practices: versioned releases, automated CI/CD, comprehensive documentation, security-first design, and configs that survive HyDE updates.

## Quick Installation

```bash
# Clone with submodules and run setup
git clone --recurse-submodules https://github.com/cativo23/my-hyde-dotfiles.git ~/my-hyde-dotfiles
cd ~/my-hyde-dotfiles
./setup.sh

# Available options
./setup.sh --help       # Show help
./setup.sh --dry-run    # Show what would be done without changes
./setup.sh --no-sddm    # Skip SDDM setup (no sudo required)
./setup.sh --no-grub    # Skip GRUB theme setup (no sudo required)
./setup.sh --no-sddm --no-grub  # Without sudo
```

### What does the script do?

| Step | Description                                                     |
| :--- | :-------------------------------------------------------------- |
| 0    | Backup current configs to `~/.config/cfg_backups/`              |
| 1    | Copy user configs (`~/.config/`, `~/.local/`) + rebuild bat cache |
| 2    | Sync waybar (layouts, modules, includes, styles) + dunst icons  |
| 3    | Regenerate dunst, patch critical timeout + restart waybar       |
| 4    | Apply extras (`.gitconfig`, `.ssh/config`)                      |
| 5    | Install packages from `packages.lst`                            |
| 6    | Install SDDM Silent theme (rei variant)                         |
| 7    | Install GRUB Elegant theme (mojave-float-left-dark)             |

**Auto-configurations:**
- Waybar `cyberdeck-nerv` layout is automatically selected
- Dunst Gengar icon is copied to `~/.config/dunst/icons/`
- Bat `tokyonight_night` theme is installed and cached automatically

## Requirements

- Arch Linux (or derivative with `yay`)
- HyDE installed (`~/HyDE`)
- zsh as default shell
- **sudo** required for SDDM and GRUB theme setup (omit with `--no-sddm --no-grub`)

## Repository Structure

```
my-hyde-dotfiles/
├── configs/
│   ├── .config/
│   │   ├── bat/themes/               # Tokyo Night theme for bat
│   │   ├── zsh/                      # Aliases, functions, NVM setup
│   │   ├── hypr/
│   │   │   ├── hyprland.conf         # Main config with sources
│   │   │   ├── keybindings.conf      # Keybindings (hyde-shell commands)
│   │   │   ├── hypridle.conf         # Idle/suspend config
│   │   │   ├── hyprlock.conf         # Pointer → silent-rei layout
│   │   │   ├── hyprlock/silent-rei.conf  # Lock screen custom (lavender/dark)
│   │   │   ├── hyprlock/backgrounds/ # rei.png + profile_square.png
│   │   │   └── userprefs.conf        # Keyboard latam/us, touchpad, swallowing
│   │   ├── kitty/                    # Terminal emulator config
│   │   ├── fastfetch/                # Custom logo + modules
│   │   ├── starship/                 # Prompt theme (TokyoNight)
│   │   ├── hyde/config.toml          # HyDE config (weather, cursor)
│   │   ├── dunst/                    # Custom notifications + Gengar icon
│   │   ├── waybar/
│   │   │   ├── modules/              # Modules: network, nerv, uptime, separators, claude-code
│   │   │   ├── includes/             # includes.json — defines which modules waybar loads
│   │   │   ├── layouts/              # Layout cyberdeck-nerv
│   │   │   ├── theme.css             # Tokyo Night color definitions
│   │   │   └── user-style.css        # CSS overrides custom
│   │   └── git/ignore                # Git global ignore
│   └── .local/share/waybar/styles/   # CSS for cyberdeck-nerv theme
├── extras/
│   ├── .gitconfig                    # Git configuration
│   └── .ssh/config                   # SSH multi-account
├── packages.lst                      # Extra packages (organized by category)
├── setup.sh                          # Installation script
├── AGENTS.md                         # Conventions for AI agents
├── CLAUDE.md                         # Entry point for Claude Code
├── CHANGELOG.md                      # Changelog
└── README.md
```

## Included Files

### Hyprland

| File                          | Description                                                                    |
| :---------------------------- | :----------------------------------------------------------------------------- |
| `hypr/hyprland.conf`          | Main config with sources to keybindings, windowrules, monitors, userprefs      |
| `hypr/keybindings.conf`       | Updated keybindings (uses `hyde-shell` commands, compatible v0.53+)            |
| `hypr/hypridle.conf`          | Idle/suspend config                                                            |
| `hypr/hyprlock.conf`          | Pointer to silent-rei layout                                                   |
| `hypr/hyprlock/silent-rei.conf` | Lock screen dark + lavender (#C3C6FB), matches SDDM Silent rei               |
| `hypr/userprefs.conf`         | Latam/us keyboard (Super+Space), touchpad natural scroll, window swallowing, gnome-keyring |

### Waybar

| File                                    | Description                                                                |
| :-------------------------------------- | :------------------------------------------------------------------------- |
| `waybar/layouts/cyberdeck-nerv.jsonc`   | Tokyo Night cyberpunk layout — selectable in HyDE                          |
| `waybar/includes/includes.json`         | Defines which modules waybar loads (required for layout to work)           |
| `waybar/modules/network.jsonc`          | Network autodetect, right-click opens nm-connection-editor                 |
| `waybar/modules/custom-nerv.jsonc`      | MAGI.SYS identifier with tooltip hostname/kernel/IP                        |
| `waybar/modules/custom-uptime.jsonc`    | SYS.ONLINE uptime display                                                  |
| `waybar/modules/custom-separator.jsonc` | Separators with variants (l1, l2, c1, r1-r4)                               |
| `waybar/modules/custom-claude-code.jsonc` | Claude CLI module — click opens terminal with claude                     |
| `waybar/theme.css`                      | Tokyo Night color variables for waybar                                     |
| `waybar/user-style.css`                 | Custom CSS overrides (claude-code styling)                                 |
| `.local/share/waybar/styles/cyberdeck-nerv.css` | Theme CSS: micro-pills, neon glow, TokyoNight colors           |

> **Note:** `waybar/style.css` is auto-generated by HyDE when switching layouts — not included in the repo.

### Notifications

| File                 | Description                                  |
| :------------------- | :------------------------------------------- |
| `dunst/dunst.conf`   | Brave auto-dismiss 10s, Gengar as default icon |
| `dunst/icons/gengar.png` | Gengar icon with transparency              |

### Shell and Terminal

| File                            | Description                                                |
| :------------------------------ | :--------------------------------------------------------- |
| `zsh/user.zsh`                  | Navigation aliases, VPN, `mkpersonal`/`mkwork` functions, NVM setup |
| `kitty/kitty.conf`              | Tab bar powerline, touch scroll multiplier, custom styled URLs |
| `bat/themes/tokyonight_night.tmTheme` | Tokyo Night theme for bat (used by `cat` alias)          |
| `starship/starship.toml`        | Extended prompt with 40+ language modules                  |
| `fastfetch/config.jsonc`        | Custom logo (Pokémon)                                      |

### Theme and Appearance

| File               | Description                                                        |
| :----------------- | :----------------------------------------------------------------- |
| `hyde/config.toml` | Weather in Celsius, San Salvador, 24h format, phinger-cursors-dark cursor |
| `git/ignore`       | Global gitignore (excludes .claude/settings.local.json)            |

### SDDM (Login Screen)

The setup automatically installs the [Silent SDDM](https://github.com/uiriansan/SilentSDDM) theme and configures it with the **rei** variant (dark + lavender, matches hyprlock).

### GRUB (Bootloader)

The setup installs the [Elegant GRUB2](https://github.com/vinceliuice/Elegant-grub2-themes) theme with the **mojave-float-left-dark** variant. Requires sudo. Omit with `--no-grub`.

### Extras (outside HyDE)

| File            | Description                                                  |
| :-------------- | :----------------------------------------------------------- |
| `.gitconfig`    | Git user and credential helpers (GitHub + Bitbucket)         |
| `.ssh/config`   | SSH multi-account (personal/work for GitHub and Bitbucket)   |

## Required Environment Variables

After installing, configure in your `~/.config/zsh/user.local.zsh`:

```bash
# Anthropic token (required for claude-code)
export ANTHROPIC_AUTH_TOKEN="your-token-here"

# Base URL (optional, if using local proxy)
export ANTHROPIC_BASE_URL="http://localhost:8317"
```

## Required Fonts

- **mononoki Nerd Font** — cyberdeck-nerv layout
- **Red Hat Display** — hyprlock silent-rei
- **CaskaydiaCove Nerd Font Mono** — kitty terminal, Qt apps
- **JetBrainsMono Nerd Font** — waybar, hyprlock widgets

All are automatically installed via `packages.lst`.

## Intentionally Excluded

- `hypr/monitors.conf` — hardware-specific (generated by `nwg-displays`)
- `hypr/windowrules.conf` — HyDE default, not customized
- `waybar/config.jsonc` — active layout, generated by `setup.sh` (copy of `cyberdeck-nerv.jsonc`)
- `waybar/style.css` — auto-generated by HyDE when switching layouts
- Credentials, tokens, SSH keys

## Security

This repo does **NOT** contain:
- Hardcoded tokens or passwords
- Private or public SSH keys
- `.env` files or credentials

Tokens must be configured as environment variables after installing.

See [SECURITY.md](./SECURITY.md) for the full security policy.

## Update Existing Setup

```bash
cd ~/my-hyde-dotfiles
git pull
./setup.sh
```

The script is idempotent: you can run it multiple times safely. A backup is automatically created before applying changes.

## Recover After a HyDE Update

If HyDE's `./install.sh -r` overwrote your configs:

```bash
cd ~/my-hyde-dotfiles
./setup.sh --no-sddm --no-grub
```

This restores keybindings, waybar layout, includes, modules, and other configs without requiring sudo.

## Troubleshooting

### "yay not found" or "paru not found" warning
**Cause:** Script requires an AUR helper for package installation.
**Fix:** Install yay or paru first:
```bash
git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay && makepkg -si
```
Or run with `--no-sddm --no-grub` to skip package install.

### SDDM theme not appearing after install
**Cause:** Theme installed but SDDM service needs restart.
**Fix:** `sudo systemctl restart sddm`

### Waybar not starting after install
**Cause:** Waybar needs manual restart after config changes.
**Fix:** `killall waybar && waybar &` or log out and back in.

### "Backup directory is empty" warning
**Cause:** No existing configs found to backup (first install).
**Fix:** This is normal on first install — safe to ignore.

### GRUB theme not showing at boot
**Cause:** GRUB config needs regeneration after theme install.
**Fix:** `sudo grub-mkconfig -o /boot/grub/grub.cfg`

### Dunst notifications not working
**Cause:** dunstrc may need regeneration after HyDE update.
**Fix:** `hyde-shell wallbash dunst`

### Backup restoration
```bash
# List available backups
ls ~/.config/cfg_backups/

# Restore from a specific backup
cp -a ~/.config/cfg_backups/my-hyde-YYYYMMDD_HHMMSS/* ~/.config/
```

## Additional Documentation

- **[Release Workflow](./.github/CONTRIBUTING.md)**: GitFlow workflow and release process
- **[Security Policy](./SECURITY.md)**: Security guidelines and vulnerability reporting
- **[Changelog](./CHANGELOG.md)**: Version history and release notes
- **[Agents Guide](./AGENTS.md)**: Project conventions and HyDE domain knowledge

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes using [gitmoji](https://gitmoji.dev/) (`git commit -m ':sparkles: feat(scope): description'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

See [CONTRIBUTING.md](./.github/CONTRIBUTING.md) for the full contribution guide.

## Recent Versions

| Version | Date       | Changes                                                        |
| :------ | :--------- | :------------------------------------------------------------- |
| [v1.7.0](https://github.com/cativo23/my-hyde-dotfiles/releases/tag/v1.7.0) | 2026-03-26 | Fix dunst gengar default icon, markdown lint fixes               |
| [v1.6.0](https://github.com/cativo23/my-hyde-dotfiles/releases/tag/v1.6.0) | 2026-03-22 | Dunst critical timeout fix, ShellCheck fixes, docs translation   |
| [v1.5.0](https://github.com/cativo23/my-hyde-dotfiles/releases/tag/v1.5.0) | 2026-03-16 | Docs, GitFlow, CONTRIBUTING                                      |
| [v1.4.0](https://github.com/cativo23/my-hyde-dotfiles/releases/tag/v1.4.0) | 2026-03-16 | Sync dunst icons (Gengar)                                        |
| [v1.3.0](https://github.com/cativo23/my-hyde-dotfiles/releases/tag/v1.3.0) | 2026-03-16 | Sync waybar configs + auto-select layout                         |
| [v1.2.0](https://github.com/cativo23/my-hyde-dotfiles/releases/tag/v1.2.0) | 2026-03-15 | Waybar tray module                                               |
| [v1.1.0](https://github.com/cativo23/my-hyde-dotfiles/releases/tag/v1.1.0) | 2026-03-15 | GRUB Elegant theme                                               |
| [v1.0.0](https://github.com/cativo23/my-hyde-dotfiles/releases/tag/v1.0.0) | 2026-03-15 | Initial release                                                  |

See [CHANGELOG.md](./CHANGELOG.md) for the full history.

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
