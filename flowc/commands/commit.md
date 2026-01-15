---
description: Create a commit using repository's conventions. Adapts format based on detected or configured patterns.
argument-hint: [message] [--amend]
---

# /commit - Conventional Commit

Create a commit following repo conventions.

## Usage

```
/commit                      # Auto-generate message
/commit "add OAuth login"    # With message
/commit --amend              # Amend last commit
```

## Commit Format

Adapts to repo conventions:

### Conventional (default)
```
feat(auth): add OAuth login (#42)
fix(api): resolve timeout issue (#43)
chore: update dependencies
```

### Brackets
```
[feature] add OAuth login
[fix] resolve timeout issue
[chore] update dependencies
```

### Ticket Reference
```
add OAuth login #42
resolve timeout issue #43
```

## Auto-Detection

Analyzes recent commits to detect format:
1. Check `.claude/repos.json` for config
2. Analyze git log patterns
3. Fall back to conventional

## Commit Types

| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation |
| `style` | Formatting |
| `refactor` | Code restructure |
| `test` | Add tests |
| `chore` | Maintenance |

## Scope Detection

Auto-detects scope from changed files:
- `src/auth/*` → `auth`
- `src/api/*` → `api`
- `components/*` → `ui`

## Guards

- Blocks commits on `poc/*` or `vibe/*` branches
- Warns about potential secrets
- Validates message format
