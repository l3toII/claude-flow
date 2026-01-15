---
description: Manage apps in the monorepo - status, git configuration, initialization, and synchronization.
argument-hint: [action] [app-name]
---

# /apps - Apps Management

Manage applications in the monorepo, including multi-git configurations.

## Usage

```
/apps                    # List all apps with status
/apps status             # Detailed status of all apps
/apps status api         # Detailed status of specific app
/apps init [name]        # Initialize a new app
/apps git [app] [action] # Manage git for an app
/apps sync               # Synchronize all apps
/apps check              # Verify all apps are properly configured
```

---

## /apps (List)

Display quick overview of all apps:

```
APPS OVERVIEW

APP          GIT         BRANCH              STATUS
devops       monorepo    main                ok
api          independent feature/#42-auth    ok (3 ahead)
web          submodule   develop             uncommitted
worker       none        -                   no package.json
```

---

## /apps status [app]

### All Apps Status

Detailed view per app showing:
- Git type (monorepo/independent/submodule)
- Branch and remote status
- Config files present
- Health status

---

## /apps init [name]

Initialize a new app in the monorepo:

```
/apps init api           # Create apps/api with standard structure
/apps init web --react   # Create React app
/apps init worker --bare # Create minimal structure
```

Creates structure:
```
apps/[name]/
├── src/
│   └── index.ts
├── package.json
├── tsconfig.json
├── Dockerfile
└── README.md
```

---

## /apps git [app] [action]

Manage git configuration for an app:

```
/apps git api status     # Show git status for api
/apps git api init       # Initialize independent git
/apps git api remote     # Configure remote
/apps git api sync       # Sync with remote
/apps git api detach     # Convert to independent repo
/apps git api attach     # Convert to monorepo
```

### Git Types

| Type | Description | Behavior |
|------|-------------|----------|
| **monorepo** | Part of root git (DEFAULT) | Inherits ALL root conventions |
| **independent** | Own .git in app folder | PRESERVES existing rules |
| **submodule** | Git submodule | External, pinned version |

> Apps WITHOUT `.git/` follow root git-flow. Apps WITH `.git/` keep their existing rules.

---

## /apps sync

Synchronize all apps with their remotes:

```
/apps sync

Syncing all apps...

apps/devops: Part of monorepo (skipped)
apps/api (independent): 3 ahead, 0 behind - Up to date
apps/web (submodule): 0 ahead, 2 behind - Run: git pull
apps/worker: No git (skipped)
```

---

## /apps check

Verify all apps are properly configured:

- Required files: package.json, README.md, Dockerfile, tsconfig
- Git configuration: type, remote, branch strategy
- Issues found with suggested fixes

---

## .claude/apps.json

Configuration file for app management:

```json
{
  "apps": {
    "api": {
      "path": "apps/api",
      "type": "backend",
      "stack": ["node", "typescript"],
      "git": {
        "type": "monorepo"
      }
    },
    "legacy-service": {
      "path": "apps/legacy-service",
      "git": {
        "type": "independent",
        "preserve_rules": true,
        "detected_strategy": "gitflow",
        "detected_main": "master"
      }
    }
  }
}
```

### Key Principle

| Has `.git/`? | `git.type` | Behavior |
|--------------|------------|----------|
| No | `monorepo` | Follows root conventions |
| Yes | `independent` | `preserve_rules: true`, keeps its own rules |

---

## Integration with Other Commands

| Command | Integration |
|---------|-------------|
| `/work #42` | Reads apps.json to determine which app's branch to create |
| `/done` | Commits to correct app repo based on changed files |
| `/status` | Shows per-app git status |
| `/onboard` | Detects and configures multi-git |
| `/sync` | Uses apps.json to sync all repos |
