# 00 - Foundations

Core principles and philosophy of the Claude Workflow system.

## Vision

A development workflow where **every line of code traces to a story**, eliminating "vibe coding" and ensuring project coherence from conception to deployment.

## Core Principles

### 1. Story-First Development

> No code without a story

Every code change must be linked to a tracked story:
- **User Story (US-XXX)**: User-facing features
- **Technical Story (TS-XXX)**: Technical work (refactoring, migrations, DevOps)
- **UX Story (UX-XXX)**: Design and UX changes

### 2. Clean Pilot Repo (Whitelist)

> Root level contains ONLY workflow files

**WHITELIST - Only these allowed at root:**

```
✅ ALLOWED:
├── apps/                    # All code (including devops)
├── docs/                    # Documentation
├── records/                 # Decision records
├── .claude/                 # Plugin config
├── .git/                    # Git
├── .gitignore
├── .github/                 # CI/CD (optional)
├── CLAUDE.md
├── README.md
├── LICENSE
├── Makefile
└── package.json (workspace only)

❌ NOT ALLOWED:
├── src/, lib/               # Code at root
├── *.ts, *.js, *.py         # Code files
├── Dockerfile               # → apps/devops/docker/
├── docker-compose.yml       # → apps/devops/docker/
├── .env*                    # → apps/devops/env/
├── tsconfig.json            # → apps/[name]/
├── node_modules/            # Delete
└── *.lock                   # Delete
```

### 3. apps/devops/ - Centralized DevOps

> All DevOps configuration in one place

```
apps/devops/
├── docker/
│   ├── docker-compose.yml      # Orchestrate all apps
│   ├── docker-compose.dev.yml  # Dev overrides
│   └── docker-compose.prod.yml # Prod overrides
├── env/
│   ├── .env.example            # Template
│   ├── .env.dev                # Dev defaults
│   └── .env.prod.example       # Prod template
├── scripts/
│   ├── setup.sh                # Initial setup
│   ├── dev.sh                  # Start dev
│   └── deploy.sh               # Deploy
└── README.md
```

**Why apps/devops/?**
- Consistent with "all code in apps/" philosophy
- DevOps is treated as a project with its own stories (TS-XXX)
- Clear ownership and responsibility
- Easy to find and maintain

### 4. Anti-Vibe-Code Guards

Automatic guards prevent untracked development:

| Guard | Trigger | Action |
|-------|---------|--------|
| Story Guard | Code edit in `apps/` | Block if no ticket branch |
| Merge Guard | `git merge poc/*` | Block (exploration only) |
| Sprint Lock | Commit during lock | Allow only `fix/*` branches |

### 5. Branch = Ticket

Branch naming enforces traceability:

```
feature/#42-oauth-login  → US-042
fix/#43-session-bug      → Bug #43
tech/#44-migrate-db      → TS-044
poc/experiment           → No merge allowed
vibe/exploration         → No merge allowed
```

### 6. Documentation as Source of Truth

```
docs/
├── PROJECT.md       # Vision, objectives, constraints
├── PERSONAS.md      # User personas
├── UX.md            # Design direction
├── STACK.md         # Technical choices
├── ARCHITECTURE.md  # System architecture
└── backlog/         # All stories
```

### 7. Milestone Before Code

> Complete V1 planning BEFORE writing code

1. Define PROJECT.md
2. Create PERSONAS.md
3. Establish UX.md direction
4. Identify ALL V1 stories
5. Plan sprints
6. Choose STACK.md
7. Setup apps/devops/
8. THEN start coding

## Workflow Philosophy

### Commands Orchestrate

Commands are the entry points that orchestrate workflows:
- `/init` → Full project setup (including apps/devops/)
- `/work #42` → Start ticket work
- `/done` → Complete work (commit + PR + update)
- `/env local` → Start local dev via apps/devops/

### Skills Provide Knowledge

Skills contain conventions and best practices:
- Commit message format
- PR template structure
- Story templates
- DevOps structure

### Hooks Enforce Rules

Automatic guards run on every action:
- PreToolUse: Block violations
- PostToolUse: Auto-format

### Agents Handle Complexity

For complex tasks requiring multiple steps:
- Project initialization
- Release management
- Code review

## Technical Debt Budget

Maximum 10 active debt tickets:

| Count | Status | Action |
|-------|--------|--------|
| 0-5 | ✅ Healthy | Normal work |
| 6-8 | ⚠️ Warning | Plan debt sprint |
| 9-10 | 🔴 Critical | Prioritize debt |
| >10 | 🛑 Blocked | Debt sprint mandatory |

## Session Continuity

Sessions persist across conversations:
- Active branch and ticket saved
- Work context restored
- Reminders displayed on start

## Design Philosophy

### Anti-AI-Slop

Reject generic AI aesthetics:
- ❌ Generic fonts (Inter, Roboto)
- ❌ Purple gradients on white
- ❌ Symmetric predictable layouts
- ✅ Distinctive typography
- ✅ Bold color choices
- ✅ Asymmetric layouts with tension

## Makefile as Interface

Root Makefile delegates to apps/devops/:

```makefile
up:     cd apps/devops/docker && docker-compose up -d
down:   cd apps/devops/docker && docker-compose down
logs:   cd apps/devops/docker && docker-compose logs -f $(app)
setup:  ./apps/devops/scripts/setup.sh
```

This provides a consistent interface regardless of underlying tools.
