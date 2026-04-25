# Security Policy

## Reporting a Vulnerability

Report security issues via [GitHub Security Advisories](https://github.com/cativo23/my-hyde-dotfiles/security/advisories).

For less severe issues, you can create a [bug report issue](https://github.com/cativo23/my-hyde-dotfiles/issues/new?template=bug_report.md).

## What We Consider Security Issues

- Exposed credentials in configs (API keys, tokens, passwords)
- Unsafe shell patterns (unquoted variables, eval usage, command injection)
- Insecure file permissions
- Hardcoded paths with user-specific data
- Secrets in version control

## What Is NOT a Security Issue

- Personal email address in git config (privacy concern, not security)
- Configuration preferences
- Feature requests

## Security Best Practices in This Project

### Secrets Management

This repository does **NOT** contain:
- Hardcoded tokens or passwords
- Private or public SSH keys
- `.env` files with credentials
- API keys

Secrets must be configured as environment variables in `~/.config/zsh/user.local.zsh` (excluded via `.gitignore`).

### Shell Script Safety

The `setup.sh` script follows secure shell scripting practices:
- `set -euo pipefail` for strict error handling
- All variables quoted: `"$VAR"`
- Uses `[[ ]]` for conditionals
- No `eval` usage
- No `curl | bash` or `wget | bash` patterns

### File Permissions

The setup script sets appropriate permissions:
- `~/.ssh/` directory: `chmod 700`
- `~/.ssh/config` file: `chmod 600`

### Input Validation

- Package names validated before installation
- Directory existence checked before operations
- Sudo access verified before privileged operations

## Supported Versions

| Version | Supported |
| ------- | --------- |
| 1.6.x   | ✓ Yes     |
| < 1.6   | ✗ No      |

We recommend always using the latest version for security fixes.

## Security Audit History

This repository undergoes periodic security reviews. Last review: 2026-03-25

Findings summary:
- **Critical:** 0
- **High:** 0
- **Medium:** 2 (eval usage, command injection surface — both low exploitability)
- **Low:** 4 (informational/hardening recommendations)
