# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
