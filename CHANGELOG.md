# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.9.0] - 2026-04-23

### Changed

- **starship prompt** — minimalist NERV-themed single-line prompt (479→140 lines): arch glyph + username + directory + git status on left, runtime context (k8s, aws, node, python, etc.) + duration/status/time on right

### Fixed

- **starship** — `home_symbol` now shows `~` instead of blank when in `$HOME`
- **starship** — git status uses optional group `(...)` to avoid empty `[]` when repo is clean
- **starship** — language versions wrapped in `($version)` to prevent empty brackets when binary absent
- **starship** — `stashed = '\$'` properly escaped to fix starship WARN

## [1.8.0] - 2026-04-21

### Added

- **wlogout cyberdeck-nerv** — power menu config (`layout_1`, `style_1.css`) with Tokyo Night theme
- **Wallpapers submodule** — Tokyo Night wallpapers tracked as git submodule under `configs/.config/hyde/themes/Tokyo Night/wallpapers`
- **qt6-virtualkeyboard** — added to `packages.lst` (required by SilentSDDM v1.4.2 for virtual keyboard support)

### Fixed

- **setup.sh** — git submodule init moved into `preflight()` to avoid duplicate step output; backup section now visible as `[0/7]`
- **setup.sh** — wlogout sync uses `mkdir -p` so it works on fresh installs (previously skipped silently)
- **setup.sh** — SDDM version pin bumped `v1.2.0` → `v1.4.2`; fixed copy step (upstream dropped `silent/` subdir layout)
- **setup.sh** — GRUB version pin bumped `v2.4.0` → `2025-03-25` (upstream switched to date-based tags)
- **setup.sh** — version pins extracted to named constants (`SILENT_SDDM_TAG`, `ELEGANT_GRUB_TAG`)
- **setup.sh** — waybar layout selection no longer crashes when source and destination are the same file
- **hyprlock.conf** — source path corrected `~/.local/share/hyde/` → `~/.local/share/hypr/` (HyDE upstream relocated boilerplate)
- **dunst.conf** — `default_icon` uses `~` instead of `$HOME` (dunst expands tilde, not env vars)
- **wlogout/layout_1** — lock actions use `hyde-shell lockscreen` instead of bare `lockscreen.sh`
- **dunst.conf** — Teams PWA notification grouping rule added

## [1.7.0] - 2026-03-26

### Fixed

- **dunst default icon** — gengar.png ahora aparece como icono por defecto en notificaciones
- **$HOME expansion** — dunst no expande variables de shell, se usa `~` en su lugar
- **wallbash dunst regeneration** — regla `[default_gengar]` sobrevive a la regeneración de hyde-shell

## [1.6.0] - 2026-03-22

### Added

- **hypr/keybindings.conf** — Keybindings with `hyde-shell` commands (v0.53+), prevents breakage after HyDE update
- **hypr/hyprland.conf** — Main config with sources, backed up in the repo
- **hypr/hypridle.conf** — Idle/suspend config
- **waybar/includes/includes.json** — Defines which modules waybar loads (required for layout)
- **bat/themes/tokyonight_night.tmTheme** — Tokyo Night theme for bat, automatically cached by setup.sh
- **Automatic backup** — setup.sh creates backup in `~/.config/cfg_backups/` before overwriting
- **Waybar includes sync** — setup.sh Step 2 now syncs `includes/`
- **bat cache rebuild** — setup.sh rebuilds bat theme cache after copying configs

### Fixed

- **Hardcoded `wlo1`** in `network.jsonc` and `custom-nerv.jsonc` — now autodetects active interface
- **Hardcoded `/home/cativo23/`** in `hyprlock.conf` and `dunst.conf` — replaced with `$HOME`
- **hyprlock layout path** — uses `$HOME` and name without spaces (`silent-rei.conf`)
- **Waybar auto-select** — uses `cp -f` instead of symlink (HyDE expects file, not link)
- **setup.sh backup bug** — `|| true` operator was swallowing `mkdir` failures
- **setup.sh SDDM rei variant** — broken logic accumulating lines; replaced with delete+append idempotent approach
- **setup.sh SC2155** — shellcheck warning resolved (separate declare and assign)
- **gengar.png** — replaced with correct version (black outline + transparent background)

### Changed

- **Waybar height** — increased from 28 to 34
- **kitty.conf** — added `touch_scroll_multiplier 4.0`
- **user.zsh** — added `vpn` alias and NVM init
- **packages.lst** — organized by category, base packages commented
- **README.md** — updated structure, post-HyDE update recovery section, v1.5.0 in table
- **AGENTS.md** — HyDE update breakage docs, machines table, windowrules.conf documented as excluded

## [1.5.0] - 2026-03-16

### Added

- **CONTRIBUTING.md** — Contributor guide with GitFlow workflow
- **GitFlow workflow documentation** — Complete release process in AGENTS.md
- **setup.sh steps table** — Detailed table of 7 steps in README.md and AGENTS.md
- **Recent releases table** — Version history in README.md with links to releases

### Changed

- **AGENTS.md** — Expanded with sync patterns, HyDE domain knowledge, updated boundaries
- **PULL_REQUEST_TEMPLATE.md** — All gitmoji types, expanded checklists, maintainer checklist
- **README.md** — Auto-configurations note, steps table

### Improved

- **Documentation structure** — Clear separation between user docs (README) and agent docs (AGENTS)
- **Contributor experience** — Complete guides for new contributors

## [1.4.0] - 2026-03-16

### Fixed

- **Dunst icons sync** — Gengar icon now copies to `~/.config/dunst/icons/` during setup
- **Default icon availability** — custom dunst icons properly synced

## [1.3.0] - 2026-03-16

### Fixed

- **Waybar configs sync** — layouts, modules, and styles now sync correctly when destination directory exists
- **Auto-select layout** — `cyberdeck-nerv` layout is automatically selected if available
- **Waybar restart timing** — now restarts after configs are synced, not before

### Changed

- **setup.sh Step 2** — dedicated waybar sync step (layouts, modules, styles with `cp -f`)
- **setup.sh steps** — now 7 steps total (was 6)

## [1.2.0] - 2026-03-15

### Added

- **Waybar tray module** — system tray in cyberdeck-nerv layout (between backlight and network) for udiskie USB icons and other tray apps
- **Tray CSS styling** — passive/needs-attention states matching Tokyo Night palette

## [1.1.0] - 2026-03-15

### Added

- **GRUB Elegant theme** — auto-install [Elegant-grub2-themes](https://github.com/vinceliuice/Elegant-grub2-themes) (mojave-float-left-dark variant)
- **`--no-grub` flag** — skip GRUB theme setup (no sudo required)

### Improved

- **Error handling** — graceful `git clone` failure for SDDM and GRUB steps
- **GRUB safety** — install runs in subshell, `grub-mkconfig` only after successful install
- **ShellCheck clean** — fixed SC2088 (`$HOME` instead of `~` in quotes), quoted `$STEP`

## [1.0.0] - 2026-03-15

### Added

- **Waybar cyberdeck-nerv layout** — Tokyo Night cyberpunk theme selectable in HyDE
  - Custom modules: MAGI.SYS identifier, SYS.ONLINE uptime, network (wlo1), separators, claude-code
  - CSS with micro-pills, neon glow, and TokyoNight color palette
  - `theme.css` with `@define-color` variables and `user-style.css` overrides
- **Hyprlock silent-rei layout** — dark + lavender (#C3C6FB) lock screen matching SDDM Silent rei
  - Dynamic greeting, now playing, battery, keyboard layout widgets
  - Font: Red Hat Display
- **Hyprland userprefs** — latam/us keyboard toggle (Super+Space), touchpad natural scroll, window swallowing, gnome-keyring, lid switch suspend
- **Dunst config** — Brave auto-dismiss 10s, Gengar PNG as default icon
- **HyDE config.toml** — weather in Celsius, San Salvador, 24h format
- **SDDM Silent theme** — auto-install + rei variant configuration in `setup.sh`
- **Git global ignore** — excludes `.claude/settings.local.json`
- **Packages** — full `packages.lst` with fonts, tools, and AUR packages
- **setup.sh** — idempotent installer with `--help`, `--dry-run`, `--no-sddm` flags
- **Project governance** — CI (syntax + ShellCheck), auto-release workflow, PR/issue templates
- **AGENTS.md** — agent conventions, boundaries, and architecture docs
