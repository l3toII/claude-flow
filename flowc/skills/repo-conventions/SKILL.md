---
name: repo-conventions
description: Repository-specific Git conventions. Use when working with branches, commits, PRs to apply the correct conventions.
---

# Repository Conventions

Adaptive Git conventions based on repository configuration.

## Convention Priority

```
1. .claude/repos.json (explicit config)
2. Auto-detection (from repo history)
3. Plugin defaults
4. Minimal fallback
```

## Branch Patterns

| Type | Pattern | Mergeable |
|------|---------|-----------|
| feature | `feature/#XX-desc` | Yes |
| fix | `fix/#XX-desc` | Yes |
| tech | `tech/#XX-desc` | Yes |
| poc | `poc/desc` | No |
| vibe | `vibe/desc` | No |

## Commit Formats

### Conventional (default)
```
feat(auth): add OAuth (#42)
fix(api): resolve timeout (#43)
```

### Brackets
```
[feature] add OAuth login
[fix] resolve timeout issue
```

### Ticket Reference
```
add OAuth login #42
```

## Flow Types

### github-flow
- Single main branch
- Feature → main
- Deploy from main

### gitflow
- main + develop
- Feature → develop
- Release → main

### trunk-based
- Short-lived branches
- Frequent merges
- Feature flags

## Config Schema

```json
{
  "flow_type": "github-flow",
  "main_branch": "main",
  "commit_format": "conventional",
  "protected_branches": ["main"],
  "non_mergeable": ["poc/*", "vibe/*"]
}
```
