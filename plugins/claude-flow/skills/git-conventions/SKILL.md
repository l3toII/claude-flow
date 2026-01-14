---
name: git-conventions
description: Git branching, commit format, and workflow conventions. Use when creating branches, committing, merging, or managing git operations. Adapts to repository patterns.
---

# Git Conventions

Adaptive Git conventions based on the current repository's configuration.

## How It Works

1. **Check `.claude/repos.json`** for configured conventions
2. **Auto-detect** if no config exists (from repo history)
3. **Apply plugin defaults** only if explicitly set or no conventions found

## Getting Current Conventions

```bash
config=$(${CLAUDE_PLUGIN_ROOT}/scripts/get-repo-config.sh)
echo "$config" | jq .
```

Returns JSON with `source` field:
- `configured` - From .claude/repos.json
- `auto_detected` - Detected from repo history
- `plugin_defaults` - Using workflow plugin defaults
- `fallback` - Minimal defaults

## Convention Priority

```
1. .claude/repos.json (explicit config)
      ↓
2. Auto-detection (from repo history)
      ↓
3. Plugin defaults (if use_plugin_defaults: true)
      ↓
4. Minimal fallback
```

---

## Branch Conventions

### Creating a Branch

```bash
config=$(${CLAUDE_PLUGIN_ROOT}/scripts/get-repo-config.sh)
flow_type=$(echo "$config" | jq -r '.flow_type')
main_branch=$(echo "$config" | jq -r '.main_branch')
feature_pattern=$(echo "$config" | jq -r '.branch_patterns.feature // "feature/*"')

# Start from the repo's main branch
git checkout "$main_branch"
git pull origin "$main_branch"

# Create branch using repo's pattern
git checkout -b [adapted-branch-name]
```

### Branch Pattern Examples

| Repo Pattern | Example Branch |
|-------------|----------------|
| `feature/*` | `feature/oauth-login` |
| `feat/*` | `feat/oauth-login` |
| `feature/#*` | `feature/#42-oauth-login` |
| `PROJ-*` | `PROJ-42-oauth-login` |

### Branch Types

| Type | Plugin Default | Mergeable | Ticket Required |
|------|---------------|-----------|-----------------|
| `feature` | `feature/#XX-desc` | Yes | Yes |
| `fix` | `fix/#XX-desc` | Yes | Yes |
| `tech` | `tech/#XX-desc` | Yes | Yes |
| `poc` | `poc/desc` | No | No |
| `vibe` | `vibe/desc` | No | No |

### Protected Branches

```bash
protected=$(echo "$config" | jq -r '.protected_branches[]')
# Never force push to protected branches
# Always use PRs for protected branches
```

### Non-Mergeable Branches

```bash
non_mergeable=$(echo "$config" | jq -r '.non_mergeable // ["poc/*", "vibe/*"]')
# These branches are for exploration only
# Must reimplement in proper branch if successful
```

---

## Commit Conventions

### Commit Format

```bash
config=$(${CLAUDE_PLUGIN_ROOT}/scripts/get-repo-config.sh)
commit_format=$(echo "$config" | jq -r '.commit_format')
ticket_pattern=$(echo "$config" | jq -r '.ticket_pattern')

case "$commit_format" in
  conventional)
    # feat(scope): message (#42)
    # fix(auth): resolve login issue (#42)
    ;;
  brackets)
    # [feature] message
    # [PROJ-42] add OAuth login
    ;;
  ticket-ref)
    # message #42
    # add OAuth login #42
    ;;
  freeform)
    # Any format - follow existing repo style
    ;;
esac
```

### Commit Format Examples

| Format | Feature | Bug Fix | Tech |
|--------|---------|---------|------|
| `conventional` | `feat(auth): add OAuth (#42)` | `fix(auth): resolve bug (#43)` | `chore: update deps` |
| `brackets` | `[feature] add OAuth` | `[fix] resolve bug` | `[chore] update deps` |
| `ticket-ref` | `add OAuth #42` | `resolve bug #43` | `update deps` |
| `freeform` | Match existing style | Match existing style | Match existing style |

---

## Flow Types

### github-flow (most common)

```bash
# Direct to main, feature branches
git checkout main && git pull
git checkout -b feature/description
# ... work ...
git push -u origin feature/description
gh pr create --base main
```

- Single main branch
- Feature branches merge directly to main
- Deploy from main

### gitflow

```bash
# develop is integration branch
git checkout develop && git pull
git checkout -b feature/description
# ... work ...
git push -u origin feature/description
gh pr create --base develop

# Releases go through release branch
git checkout -b release/v1.2.0
# ... final fixes ...
gh pr create --base main
```

- `main` for releases
- `develop` for integration
- `feature/*` → develop
- `release/*` → main + develop
- `hotfix/*` → main + develop

### trunk-based

```bash
# Short-lived branches, frequent merges
git checkout main && git pull
git checkout -b short-description
# ... small change ...
git push -u origin short-description
gh pr create --base main
# Merge same day if possible
```

- Short-lived feature branches
- Frequent merges to main
- Feature flags for incomplete work

### simple

- Basic branching, no specific pattern
- Flexible workflow

---

## Config Schema

```json
{
  "repos": {
    "repo-name": {
      "path": "./relative/path",
      "flow_type": "github-flow|gitflow|trunk-based|simple",
      "main_branch": "main|master|develop|trunk",
      "branch_patterns": {
        "feature": "feature/*|feat/*",
        "fix": "fix/*|bugfix/*|hotfix/*",
        "tech": "tech/*|chore/*|refactor/*",
        "release": "release/*",
        "poc": "poc/*|experiment/*",
        "vibe": "vibe/*|playground/*"
      },
      "commit_format": "conventional|brackets|ticket-ref|freeform",
      "ticket_pattern": "#NUMBER|JIRA|BRACKETS|none",
      "pr_template": "github|gitlab|root|none",
      "protected_branches": ["main", "develop"],
      "non_mergeable": ["poc/*", "vibe/*"]
    }
  },
  "default_repo": "repo-name",
  "use_plugin_defaults": false
}
```

---

## Mapping Plugin to Repo Conventions

When commands like `/work` run, they map plugin concepts to repo conventions:

| Plugin Default | GitHub Flow | GitFlow | Trunk-Based |
|---------------|-------------|---------|-------------|
| `feature/#42-*` | `feat/42-*` | `feature/PROJ-42-*` | `42-short-desc` |
| `main` | `main` | `develop` | `main` |
| `feat(x): msg (#42)` | `feat: msg #42` | `[PROJ-42] msg` | `msg` |

---

## Branch Cleanup

```bash
config=$(${CLAUDE_PLUGIN_ROOT}/scripts/get-repo-config.sh)
main_branch=$(echo "$config" | jq -r '.main_branch')

# Delete merged branches
git branch --merged "$main_branch" | grep -v "$main_branch" | xargs git branch -d

# Prune remote tracking
git fetch --prune
```
