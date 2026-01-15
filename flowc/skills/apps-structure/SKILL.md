---
name: apps-structure
description: Structure and conventions for apps/ directory. Each app has its own git and is fully autonomous.
---

# Apps Structure

Each app is autonomous with its own git repository.

## Core Principles

1. Each app has its own `.git` (except devops)
2. Each app is 100% autonomous
3. No shared config files
4. No `extends` in configs

## Directory Structure

```
apps/
├── devops/              # NO .git (principal repo)
│   ├── docker/
│   ├── env/
│   └── scripts/
│
├── api/                 # Has .git
│   ├── .claude/quality.json
│   ├── src/
│   ├── package.json     # Self-contained
│   └── tsconfig.json    # No extends
│
└── web/                 # Has .git
    ├── .claude/quality.json
    ├── src/
    └── package.json
```

## Required Files Per App

| File | Required |
|------|----------|
| `.git/` | Yes (except devops) |
| `package.json` | Yes |
| `README.md` | Yes |
| `.claude/quality.json` | Yes |

## Git Architecture

```
Principal Repo
├── project/backlog/
├── engineering/
└── apps/
    ├── devops/ (no .git)
    ├── api/.git → github/project-api
    └── web/.git → github/project-web
```

## Story → Ticket Flow

```
Story S-042 (principal repo)
├── Ticket api#15 → PR in api repo
└── Ticket web#23 → PR in web repo
```
