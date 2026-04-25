## Description
<!-- Brief description of changes (what, why, how) -->

## Type of Change
<!-- Mark relevant options with [x] -->
- [ ] :sparkles: `feat` - New config / feature
- [ ] :bug: `fix` - Bug fix
- [ ] :memo: `docs` - Documentation only
- [ ] :recycle: `refactor` - Code restructuring
- [ ] :wrench: `chore` - Tooling / CI
- [ ] :lipstick: `style` - Formatting, CSS, visual changes
- [ ] :fire: `remove` - Remove code or files

## Testing
<!-- Mark completed tests with [x] -->
- [ ] `bash -n setup.sh` passes (syntax validation)
- [ ] `./setup.sh --dry-run` shows expected steps
- [ ] Manual testing on HyDE completed
- [ ] Affected configs verified after install

## Related Issues
<!-- Link issues this PR addresses -->
Closes #

## Release Notes
<!-- Add entry for CHANGELOG.md if this is a user-facing change -->
```markdown
### Fixed/Added/Changed
- Description of change
```

## Checklist
<!-- Ensure all items are completed before requesting review -->
- [ ] Follows gitmoji + [conventional commit](https://www.conventionalcommits.org/) format
- [ ] No secrets exposed (tokens, keys, credentials)
- [ ] README.md updated if adding new configs
- [ ] AGENTS.md updated if changing workflows
- [ ] Branch follows GitFlow (`fix/*`, `feature/*` → `develop`, `release/*` → `main`)

## For Maintainers
- [ ] PR merged to `develop` (or `main` if release)
- [ ] Branch deleted after merge
- [ ] Release created if this is a user-facing fix/feature
