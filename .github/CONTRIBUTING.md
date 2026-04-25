# Contributing to my-hyde-dotfiles

Thank you for your interest in contributing! This guide will help you understand the workflow.

## Workflow (GitFlow)

### 1. Find or Create an Issue

- Check existing [issues](https://github.com/cativo23/my-hyde-dotfiles/issues)
- If it doesn't exist, create an issue describing the problem or feature

### 2. Create Working Branch

```bash
git checkout develop
git checkout -b fix/issue-N-short-description
# or for features:
git checkout -b feature/short-description
```

### 3. Implement Changes

- Follow code conventions (see [AGENTS.md](../AGENTS.md))
- Keep commits small and atomic
- Use gitmoji commit format:

```bash
git commit -m ":bug: fix(scope): change description"
```

### 4. Validate Changes

```bash
# Validate script syntax
bash -n setup.sh

# Test in dry-run mode
./setup.sh --dry-run

# Test real installation (optional)
./setup.sh --no-sddm --no-grub
```

### 5. Create Pull Request

```bash
git push -u origin fix/issue-N-short-description
gh pr create --base develop --title "fix(scope): description" --body "Closes #N"
```

### 6. Code Review

- Respond to review comments
- Make requested changes
- Wait for approval before merging

### 7. Merge and Release

- Fixes/features are merged to `develop`
- Releases are created from `release/v*.*.*` → `main`
- GitHub Actions publishes the release automatically

## Commit Conventions

Format: `:<gitmoji>: type(scope): description`

| Type | Emoji | Code | When to use |
|------|-------|--------|-------------|
| `feat` | :sparkles: | `:sparkles:` | New config or feature |
| `fix` | :bug: | `:bug:` | Bug fix |
| `docs` | :memo: | `:memo:` | Documentation only |
| `style` | :lipstick: | `:lipstick:` | Formatting, CSS, visual changes |
| `refactor` | :recycle: | `:recycle:` | Code restructuring |
| `chore` | :wrench: | `:wrench:` | Tooling, CI, dependencies |
| `fire` | :fire: | `:fire:` | Remove code or files |
| `tada` | :tada: | `:tada:` | Initial commit or milestone |

**Valid scopes:** `setup`, `waybar`, `hyprlock`, `dunst`, `hypr`, `kitty`, `zsh`, `starship`, `fastfetch`, `rofi`, `hyde`, `sddm`, `packages`, `readme`, `ci`, `docs`, `configs`

### Examples

```bash
git commit -m ":sparkles: feat(waybar): add tray module to cyberdeck-nerv"
git commit -m ":bug: fix(setup): sync dunst icons directory"
git commit -m ":memo: docs: update README with installation steps"
git commit -m ":wrench: chore: bump version to 1.4.0"
```

## Branch Structure

```
main (production)
  ↑
develop (integration)
  ↑
fix/*  feature/*  (work)
  ↑
release/v*.*.* (releases)
```

## Additional Resources

- [AGENTS.md](../AGENTS.md) - Project conventions and architecture
- [README.md](../README.md) - User documentation
- [CHANGELOG.md](../CHANGELOG.md) - Changelog

## Questions?

If you have any questions, feel free to ask in the repository issues or discussions.
