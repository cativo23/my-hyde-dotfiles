# AGENTS.md — my-hyde-dotfiles

## Agent Role

Dotfiles maintenance agent for HyDE (Hyprland). Specialist in shell scripting, Linux desktop configs, and Arch Linux packaging.

**Mission:** Provide a reproducible HyDE desktop setup (Arch Linux + Hyprland + Waybar + Dunst + Tokyo Night) deployable on any machine with a single script.

**Philosophy:** Configs survive HyDE updates. `setup.sh` is idempotent and non-destructive. User always has control (`--dry-run`, `--no-sddm`).

## Key Commands

```bash
# Validate syntax
bash -n setup.sh

# Lint
shellcheck --severity=warning setup.sh

# Dry run (shows what would be done without changes)
./setup.sh --dry-run

# Full install
./setup.sh

# Install without SDDM (no sudo needed)
./setup.sh --no-sddm
```

## Project Structure

```
my-hyde-dotfiles/
├── .github/
│   ├── workflows/
│   │   ├── ci.yml              # Syntax check + ShellCheck
│   │   └── release.yml         # Auto GitHub Release on release/* → main merge
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── ISSUE_TEMPLATE/
│       ├── bug_report.md
│       └── config_request.md
├── configs/
│   ├── .config/
│   │   ├── dunst/              # Notifications (dunst.conf + Gengar icon)
│   │   ├── fastfetch/          # System info (custom Pokémon logo)
│   │   ├── git/ignore          # Global gitignore
│   │   ├── hyde/config.toml    # HyDE settings (weather, cursor, format)
│   │   ├── hypr/
│   │   │   ├── hyprlock.conf   # Pointer → silent-rei layout
│   │   │   ├── hyprlock/       # Custom lock screen layouts + backgrounds
│   │   │   └── userprefs.conf  # Keyboard, touchpad, swallowing, keyring
│   │   ├── kitty/              # Terminal emulator
│   │   ├── rofi/               # App launcher theme
│   │   ├── starship/           # Prompt theme (TokyoNight)
│   │   ├── waybar/
│   │   │   ├── layouts/        # cyberdeck-nerv layout
│   │   │   ├── modules/        # network, nerv, uptime, separators, claude-code
│   │   │   ├── theme.css       # Tokyo Night @define-color variables
│   │   │   └── user-style.css  # CSS overrides
│   │   └── zsh/                # Shell aliases and functions
│   └── .local/share/
│       └── waybar/styles/      # cyberdeck-nerv.css theme
├── extras/
│   ├── .gitconfig              # Git configuration
│   └── .ssh/config             # SSH multi-account
├── packages.lst                # AUR/pacman packages
├── setup.sh                    # Idempotent installer
├── CHANGELOG.md                # Release notes
├── CLAUDE.md                   # Claude Code entry point → this file
├── AGENTS.md                   # This file (vendor-agnostic)
└── README.md                   # Human-facing docs
```

## Code Conventions

### Shell Scripts

- `set -euo pipefail` at the start
- Quote all variables: `"$VAR"`
- `[[ ]]` for conditionals, `$(...)` for command substitution
- UPPER_CASE for globals/constants, `local` keyword for locals
- Functions: `log_ok()`, `log_warn()`, `log_err()`, `log_step()`

### Configuration Files

- Follow existing format in each config directory
- Tokyo Night palette: `#1a1b26` (bg), `#c0caf5` (fg), `#7aa2f7` (blue), `#bb9af7` (purple), `#7dcfff` (cyan), `#f7768e` (red), `#ff9e64` (orange)
- Comment non-obvious settings with `#`

### Commits

Format: `:<gitmoji>: type(scope): description`

| Type | Emoji | Code | When to use |
|------|-------|------|-------------|
| `feat` | :sparkles: | `:sparkles:` | New config or feature |
| `fix` | :bug: | `:bug:` | Bug fix |
| `docs` | :memo: | `:memo:` | Documentation only |
| `style` | :lipstick: | `:lipstick:` | Formatting, CSS, visual changes |
| `refactor` | :recycle: | `:recycle:` | Code restructuring |
| `chore` | :wrench: | `:wrench:` | Tooling, CI, dependencies |
| `fire` | :fire: | `:fire:` | Remove code or files |
| `tada` | :tada: | `:tada:` | Initial commit or major milestone |

**Valid scopes:** `setup`, `waybar`, `hyprlock`, `dunst`, `hypr`, `kitty`, `zsh`, `starship`, `fastfetch`, `rofi`, `hyde`, `sddm`, `packages`, `readme`, `ci`, `docs`, `configs`

## Boundaries

### Always
- Run `bash -n setup.sh` before committing
- Test with `--dry-run` after modifying `setup.sh`
- Keep `setup.sh` idempotent (safe to run multiple times)
- Use Tokyo Night palette for all visual configs

### Ask First
- Modify `setup.sh` behavior or flags
- Add new packages to `packages.lst`
- Change keyboard layouts or input settings
- Modify SDDM or login screen configuration

### Never
- `git push` or create commits automatically
- Include credentials, tokens, or SSH keys in the repo
- Use `git push --force` or destructive operations
- Edit HyDE-managed files that get overwritten (e.g., `~/.local/state/hyde/config`)
- Hardcode hardware-specific values (monitor config, network interfaces in setup.sh)

## HyDE Domain Knowledge

### dunst
The file dunst reads is `~/.config/dunst/dunstrc`, which is **auto-generated** by `hyde-shell wallbash dunst`. The `dunst.conf` in this repo is the user file included in the middle. After copying `dunst.conf`, always run `hyde-shell wallbash dunst`.

### config.toml
`~/.config/hyde/config.toml` is the **only** HyDE config that survives updates. Never edit `~/.local/state/hyde/config` (gets overwritten).

### hyprlock
`hyprlock.conf` is a pointer that defines `$LAYOUT_PATH`. Custom layouts go in `~/.config/hypr/hyprlock/`. HyDE regenerates the boilerplate from `~/.local/share/hyde/hyprlock.conf`.

### SDDM Silent theme
Installed via `setup.sh` from [SilentSDDM](https://github.com/uiriansan/SilentSDDM). Variant `rei` (dark + lavender). Requires sudo. Skip with `--no-sddm`.

### Waybar
Custom modules in `configs/.config/waybar/modules/` are prioritized by HyDE over defaults. Layouts in `layouts/` are selectable via `hyde-shell waybar --select`.

## Architecture

- `setup.sh` is the single entry point — 5 steps executed in order
- Configs in `configs/` mirror the `~/.config/` and `~/.local/` directory structure
- HyDE preserved files: `dunst.conf`, `config.toml`, `userprefs.conf`, waybar `modules/` and `layouts/`
- `extras/` contains non-HyDE dotfiles copied only if they don't already exist
- `packages.lst` is filtered (comments, blanks, invalid names) before passing to `yay`

## Versioning

- Follows [Semantic Versioning](https://semver.org/)
- `release/*` branches trigger auto GitHub Release when merged to `main`
- `CHANGELOG.md` must have a section `## [X.Y.Z]` matching the release branch version
- `VERSION` variable in `setup.sh` must match the release version

## Machine of Origin

- **Hostname:** atlas
- **WiFi:** Realtek RTL8821CE (driver rtw88_8821ce)
- **Location:** San Salvador, El Salvador

## What's NOT Included

- `hypr/monitors.conf` — hardware-specific (use `nwg-displays`)
- Credentials and tokens — never in the repo
- Required fonts are installed via `packages.lst`
