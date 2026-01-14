---
description: Onboard an existing project into the workflow. Cleans root with whitelist approach, creates apps/devops/, reconciles documents with code.
argument-hint: [--full]
context: fork
agent: onboard-agent
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# /onboard - Onboard Existing Project

Transform an existing codebase into a clean claude-flow project using the onboard-agent.

## Usage

```
/onboard              # Standard onboarding
/onboard --full       # Full onboarding with backlog generation
```

## What It Does

The onboard-agent will:

1. **Scan Root** - Categorize all files at root
2. **User Confirmation** - Confirm cleanup actions
3. **Create Structure** - apps/, project/, engineering/, docs/
4. **Execute Cleanup** - Move code, config, DevOps files
5. **Document Reconciliation** - Compare docs vs code, fix inconsistencies
6. **Multi-Git Detection** - Handle apps with independent git repos
7. **Create Root Files** - Makefile, CLAUDE.md, package.json
8. **Commit & PR** - Ready for review

## Core Principles

- **Whitelist Approach** - Only whitelisted files stay at root
- **apps/devops/** - All DevOps files centralized
- **No Config at Root** - tsconfig, eslintrc, etc. go with their apps
- **Document Reconciliation** - Docs must match code reality

## Arguments

- `--full` - Also generate initial backlog from code analysis

## Expected Result

```
✅ ALLOWED AT ROOT:
├── apps/                    # All application code
├── project/                 # Backlog, sprints, vision
├── engineering/             # Architecture, decisions
├── docs/                    # Public documentation
├── .claude/                 # Plugin configuration
├── .git/, .github/          # Git
├── CLAUDE.md, README.md     # Entry points
├── Makefile                 # Orchestration
└── package.json             # Workspace only

❌ FORBIDDEN AT ROOT:
├── tsconfig.json            # → apps/[name]/
├── .eslintrc*               # → apps/[name]/
├── Dockerfile               # → apps/devops/docker/
├── .env*                    # → apps/devops/env/
└── node_modules/            # DELETE
```

## See Also

- `/init` - For new projects
- `/apps` - Manage apps in monorepo
- `/sync` - Verify code/docs sync
