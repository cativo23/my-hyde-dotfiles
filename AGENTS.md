# AGENTS.md

Instructions for AI coding agents working on this HyDE dotfiles project.

## Quick Start

```bash
# Run installation (installs packages, applies configs, sets up dotfiles)
./setup.sh

# Test setup is idempotent
./setup.sh && ./setup.sh
```

## Project Structure

```
my-hyde-dotfiles/
├── configs/.config/    # HyDE preserved configs
│   ├── zsh/            # Shell aliases and functions
│   ├── hypr/           # Hyprland user preferences
│   ├── kitty/          # Terminal emulator settings
│   ├── fastfetch/      # System info display (custom logo)
│   └── starship/       # Cross-shell prompt (TokyoNight)
├── extras/             # Non-HyDE dotfiles
│   ├── .gitconfig      # Git configuration
│   └── .ssh/config     # SSH multi-account setup
├── packages.lst        # AUR packages
├── setup.sh            # Installation script
├── CLAUDE.md           # Claude Code-specific config
├── AGENTS.md           # This file (vendor-agnostic)
└── README.md           # Human-facing documentation
```

## Code Style

### Shell Scripts

- Use `set -euo pipefail` at the start
- Quote all variables: `"$VAR"`
- Use `[[ ]]` for conditionals
- Use `$(...)` for command substitution
- Use uppercase for environment variables, lowercase for local variables

### Markdown

- Use ATX-style headers (`##` not `===`)
- Code blocks with language specifiers
- Tables for structured data

### Configuration Files

- Follow existing formatting in each config directory
- Use TokyoNight color palette consistently
- Comment non-obvious settings with `#`

## Testing Instructions

Before committing changes:

1. Run `./setup.sh` twice to verify idempotency
2. Check for unintended file changes: `git status`
3. Verify no secrets are committed: `git diff --cached`

## When Making Changes

- Output full file content when editing
- Explain reasoning before code changes
- Verify changes don't break existing setup

## Security

- Never commit tokens, passwords, or SSH keys
- All credentials must be environment variables (see `configs/.config/zsh/user.zsh` for template)
- Reference secret storage systems, never actual secrets

## Commit Guidelines

- Use **Gitmoji + Conventional Commits** format: `:emoji: type(scope): description`
- `scope` is optional - use it to indicate the affected component (e.g., `zsh`, `kitty`, `setup`)
- Run `./setup.sh` before committing
- Update README.md if adding new files

### Gitmoji API

When in doubt about which emoji to use, query the Gitmoji API:

```bash
curl -s https://gitmoji.dev/api/gitmojis | jq '.gitmojis[] | select(.type == "feat")'
```

**API Response Structure:**
```json
{
  "gitmojis": [
    {
      "emoji": "✨",
      "entity": "&#x2728;",
      "code": ":sparkles:",
      "description": "Add new features.",
      "type": "feat"
    }
  ]
}
```

### Gitmoji Reference

| Type | Emoji | Code | Example |
|------|-------|------|---------|
| `feat` | ✨ | `:sparkles:` | `:sparkles: feat(starship): add new module` |
| `fix` | 🐛 | `:bug:` | `:bug: fix(kitty): resolve tab issue` |
| `docs` | 📝 | `:memo:` | `:memo: docs(readme): update setup steps` |
| `style` | 💄 | `:lipstick:` | `:lipstick: style(config): improve formatting` |
| `refactor` | ♻️ | `:recycle:` | `:recycle: refactor(zsh): simplify aliases` |
| `test` | ✅ | `:white_check_mark:` | `:white_check_mark: test(setup): add idempotency check` |
| `chore` | 🔧 | `:wrench:` | `:wrench: chore(deps): update packages.lst` |
