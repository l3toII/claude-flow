---
description: Onboard an existing project into the workflow. Cleans pilot repo with whitelist approach, creates apps/devops/, and produces structure identical to /init.
argument-hint: [--full]
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, AskUserQuestion
---

# /onboard - Onboard Existing Project

**Transform an existing codebase** into a clean claude-flow project, identical to a fresh `/init`.

## Usage

```
/onboard              # Standard onboarding
/onboard --full       # Full onboarding with backlog generation
```

## Core Principles

> ⚠️ **WHITELIST APPROACH**: Only files in the whitelist stay at root. Everything else must be moved or deleted.

> 🎯 **apps/devops/**: All DevOps files (Docker, .env, scripts) go in `apps/devops/`

---

## ROOT WHITELIST (Strict)

**ONLY these files/folders are allowed at root:**

```
✅ ALLOWED AT ROOT:
├── apps/                    # All application code
├── docs/                    # Workflow documentation
├── records/                 # Decision records
├── .claude/                 # Plugin configuration
├── .git/                    # Git repository
├── .gitignore               # Git ignore rules
├── .github/                 # GitHub workflows (optional)
├── CLAUDE.md                # Entry point for Claude
├── README.md                # Project overview
├── LICENSE                  # License file
├── Makefile                 # Root orchestration commands
└── package.json             # Workspace only (no dependencies)

❌ EVERYTHING ELSE MUST BE MOVED OR DELETED
```

---

## Phase 0: Create Dedicated Branch

```bash
git status
git checkout -b tech/onboard-workflow
```

---

## Phase 1: Full Root Scan & Categorization

### 1.1 Scan Everything at Root

```bash
# List ALL files and folders at root
ls -la
ls -la .*  # Hidden files too
```

### 1.2 Categorize Each Item

For each file/folder at root, categorize:

| Category | Examples | Default Action |
|----------|----------|----------------|
| **CODE** | `src/`, `lib/`, `*.ts`, `*.js`, `*.py` | → Move to `apps/[name]/` |
| **CONFIG-APP** | `tsconfig.json`, `.eslintrc`, `jest.config.*` | → Move with code to `apps/[name]/` |
| **CONFIG-DEVOPS** | `Dockerfile`, `docker-compose.*`, `.env*` | → Move to `apps/devops/` |
| **DEPS** | `node_modules/`, `*.lock`, `.pnpm-store/` | → Delete (regenerable) |
| **CI/CD** | `.github/`, `.gitlab-ci.yml` | → Keep or move to `apps/devops/` |
| **DOCS-LEGACY** | `CHANGELOG.md`, `CONTRIBUTING.md`, `*.md` | → Archive to `docs/archive/` |
| **WHITELIST** | `README.md`, `LICENSE`, `.gitignore` | → Keep |
| **UNKNOWN** | Anything else | → Ask user |

### 1.3 Generate Cleanup Report

```
🔍 ROOT CLEANUP REPORT

📁 Scanned: 34 items at root

✅ WHITELIST (keep as-is): 4 items
├── .git/
├── .gitignore
├── README.md
└── LICENSE

🚚 CODE → apps/[name]/: 3 items
├── src/ (→ apps/core/)
├── lib/ (→ apps/core/)
└── index.ts (→ apps/core/)

🐳 DEVOPS → apps/devops/: 6 items
├── Dockerfile
├── docker-compose.yml
├── docker-compose.dev.yml
├── .env
├── .env.example
└── .env.local

⚙️ CONFIG → move with code: 4 items
├── tsconfig.json (→ apps/core/)
├── .eslintrc.js (→ apps/core/)
├── jest.config.js (→ apps/core/)
└── vite.config.ts (→ apps/core/)

🗑️ DEPS → delete (regenerable): 3 items
├── node_modules/
├── package-lock.json
└── .pnpm-store/

📦 ARCHIVE → docs/archive/: 2 items
├── CHANGELOG.md
└── old-notes.md

❓ UNKNOWN → need decision: 2 items
├── random-file.txt
└── temp/

─────────────────────────────────
Total actions: 24 items to process
```

### 1.4 User Confirmation (MANDATORY)

> ⚠️ **MUST use AskUserQuestion before ANY action**

```
⚠️ CLEANUP CONFIRMATION REQUIRED

I've categorized 34 items. Proposed actions:

1. AUTO-CLEAN (recommended):
   - Move code to apps/core/
   - Move DevOps to apps/devops/
   - Delete node_modules/ and lock files
   - Archive old docs

2. REVIEW ONE BY ONE:
   - Confirm each item individually

3. SKIP CLEANUP:
   - Not recommended - pilot repo will remain dirty

Your choice?
```

**If user chooses "REVIEW ONE BY ONE"**, ask for each category:
- Code destination app name
- Which DevOps files to keep
- Which docs to archive vs delete
- What to do with unknown files

---

## Phase 2: Execute Cleanup

### 2.1 Create Target Structure

```bash
# Create apps structure
mkdir -p apps/devops/docker
mkdir -p apps/devops/env
mkdir -p apps/devops/scripts

# Create docs structure
mkdir -p docs/backlog/functional
mkdir -p docs/backlog/technical
mkdir -p docs/backlog/ux
mkdir -p docs/sprints
mkdir -p docs/architecture
mkdir -p docs/archive
mkdir -p records/decisions
mkdir -p .claude
```

### 2.2 Move Code to apps/

```bash
# Example: Move src/ to apps/core/
mkdir -p apps/core
mv src/ apps/core/
mv lib/ apps/core/
mv index.ts apps/core/

# Move associated config
mv tsconfig.json apps/core/
mv .eslintrc.js apps/core/
mv jest.config.js apps/core/
```

### 2.3 Move DevOps to apps/devops/

```bash
# Docker files
mv Dockerfile apps/devops/docker/
mv docker-compose*.yml apps/devops/docker/

# Environment files
mv .env* apps/devops/env/

# Create .env.example if not exists
touch apps/devops/env/.env.example
```

### 2.4 Delete Regenerable Files

```bash
# Remove deps (will be regenerated)
rm -rf node_modules/
rm -f package-lock.json yarn.lock pnpm-lock.yaml
rm -rf .pnpm-store/ .yarn/
```

### 2.5 Archive Legacy Docs

```bash
mv CHANGELOG.md docs/archive/
mv CONTRIBUTING.md docs/archive/
mv old-notes.md docs/archive/
```

---

## Phase 3: Setup apps/devops/

### 3.1 Create apps/devops/ Structure

```
apps/devops/
├── docker/
│   ├── docker-compose.yml      # Main compose (orchestrates all apps)
│   ├── docker-compose.dev.yml  # Dev overrides
│   ├── docker-compose.prod.yml # Prod overrides
│   └── Dockerfile.base         # Shared base image (optional)
├── env/
│   ├── .env.example            # Template for all env vars
│   ├── .env.dev                # Dev defaults (no secrets)
│   └── .env.prod.example       # Prod template (no secrets)
├── scripts/
│   ├── setup.sh                # Initial setup script
│   ├── dev.sh                  # Start dev environment
│   └── deploy.sh               # Deployment script
├── package.json                # For any Node.js tooling
└── README.md                   # DevOps documentation
```

### 3.2 Create docker-compose.yml

```yaml
# apps/devops/docker/docker-compose.yml
version: '3.8'

services:
  # Add services based on detected apps
  # Example:
  api:
    build:
      context: ../../api
      dockerfile: Dockerfile
    env_file:
      - ../env/.env
    ports:
      - "3000:3000"
    volumes:
      - ../../api:/app
      - /app/node_modules

  web:
    build:
      context: ../../web
      dockerfile: Dockerfile
    env_file:
      - ../env/.env
    ports:
      - "5173:5173"
    volumes:
      - ../../web:/app
      - /app/node_modules
```

### 3.3 Create apps/devops/README.md

```markdown
# DevOps

Infrastructure and deployment configuration for the project.

## Quick Start

From project root:
```bash
make up      # Start all services
make down    # Stop all services
make logs    # View logs
```

## Structure

- `docker/` - Docker Compose configurations
- `env/` - Environment variable templates
- `scripts/` - Automation scripts

## Environment Variables

Copy the example file and fill in values:
```bash
cp apps/devops/env/.env.example apps/devops/env/.env
```

## Services

| Service | Port | Description |
|---------|------|-------------|
| api | 3000 | Backend API |
| web | 5173 | Frontend app |
```

---

## Phase 4: Apps Validation

### 4.1 Identify All Apps

```bash
ls -d apps/*/ 2>/dev/null
```

### 4.2 Validate Each App

Each app in `apps/` (except devops) MUST have:
- [ ] `package.json` (or equivalent)
- [ ] `README.md`
- [ ] `src/` or entry point

### 4.3 Create Missing Essentials

```
📦 App: apps/api/

Missing:
├── ❌ README.md

Create README.md? [Y/n]
```

---

## Phase 5: Create Workflow Documents

### 5.1 Create Root Makefile

```makefile
# Makefile - Project orchestration

.PHONY: help up down logs build test lint

help:
	@echo "Available commands:"
	@echo "  make up       - Start all services"
	@echo "  make down     - Stop all services"
	@echo "  make logs     - View logs (use app=api for specific)"
	@echo "  make build    - Build all apps"
	@echo "  make test     - Run all tests"
	@echo "  make lint     - Lint all apps"

# DevOps commands (delegate to apps/devops)
up:
	cd apps/devops/docker && docker-compose up -d

down:
	cd apps/devops/docker && docker-compose down

logs:
	cd apps/devops/docker && docker-compose logs -f $(app)

# Build commands
build:
	@for dir in apps/*/; do \
		if [ -f "$$dir/package.json" ] && [ "$${dir}" != "apps/devops/" ]; then \
			echo "Building $$dir..."; \
			cd "$$dir" && npm run build && cd ../..; \
		fi \
	done

# Test commands
test:
	@for dir in apps/*/; do \
		if [ -f "$$dir/package.json" ] && [ "$${dir}" != "apps/devops/" ]; then \
			echo "Testing $$dir..."; \
			cd "$$dir" && npm test && cd ../..; \
		fi \
	done

# Per-app commands
test-%:
	cd apps/$* && npm test

lint-%:
	cd apps/$* && npm run lint

build-%:
	cd apps/$* && npm run build
```

### 5.2 Create Workflow Documents

| File | Content |
|------|---------|
| `docs/PROJECT.md` | Vision, objectives (from analysis) |
| `docs/PERSONAS.md` | Users deduced from code |
| `docs/UX.md` | UI/UX analysis |
| `docs/STACK.md` | Detected tech stack |
| `.claude/repos.json` | Git conventions |
| `CLAUDE.md` | Entry point |

### 5.3 Create/Update package.json (Workspace Only)

```json
{
  "name": "project-workspace",
  "private": true,
  "workspaces": ["apps/*"],
  "scripts": {
    "dev": "make up",
    "build": "make build",
    "test": "make test"
  }
}
```

**Rules:**
- ❌ No `dependencies` at root
- ❌ No `devDependencies` at root (except workspace tools)
- ✅ Only workspace configuration

---

## Phase 6: Generate Initial Backlog (if --full)

### 6.1 Technical Stories (TS-XXX)

- TODO/FIXME comments found
- Outdated dependencies
- Missing tests
- Missing Dockerfiles in apps

### 6.2 User Stories (US-XXX)

- Incomplete features
- Stubbed functions

### 6.3 DevOps Stories (TS-XXX)

- Missing CI/CD pipelines
- No staging environment
- Missing health checks

---

## Phase 7: Final Validation

### 7.1 Pilot Repo Checklist

```
✅ PILOT REPO VALIDATION

Root (whitelist only):
├── ✅ apps/
├── ✅ docs/
├── ✅ records/
├── ✅ .claude/
├── ✅ .git/
├── ✅ .gitignore
├── ✅ CLAUDE.md
├── ✅ README.md
├── ✅ Makefile
├── ✅ LICENSE (if exists)
├── ⚠️ package.json (workspace only)
└── ❌ Nothing else at root

Apps:
├── ✅ apps/devops/ (docker, env, scripts)
├── ✅ apps/api/ (package.json, README)
└── ✅ apps/web/ (package.json, README)
```

### 7.2 Summary Report

```
✅ Project Onboarded: [name]

🧹 Cleanup Performed:
├── Moved: src/, lib/ → apps/core/
├── Moved: Dockerfile, docker-compose.yml → apps/devops/docker/
├── Moved: .env* → apps/devops/env/
├── Deleted: node_modules/, package-lock.json
├── Archived: CHANGELOG.md → docs/archive/
└── Created: apps/devops/README.md

📁 Final Structure:
├── apps/
│   ├── devops/ (docker, env, scripts)
│   ├── api/
│   └── web/
├── docs/ (PROJECT, PERSONAS, UX, STACK, backlog/)
├── records/decisions/
├── .claude/
├── CLAUDE.md
├── README.md
└── Makefile

📊 Analysis:
├── Apps: 3 (devops, api, web)
├── Tech: [stack summary]
├── Git Flow: [detected]
└── Tech Debt: [count] items
```

---

## Phase 8: Commit and Create PR

```bash
git add .

git commit -m "tech: onboard project to claude-flow workflow

- Clean pilot repo (whitelist approach)
- Create apps/devops/ for Docker and environment management
- Move all code to apps/
- Add docs/ structure (PROJECT, PERSONAS, UX, STACK)
- Add backlog structure
- Create root Makefile for orchestration

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

git push -u origin tech/onboard-workflow
```

---

## Key Rules

| Rule | Enforcement |
|------|-------------|
| Whitelist only at root | ❌ Everything else must move/delete |
| DevOps in apps/devops/ | 🐳 Docker, .env, scripts centralized |
| No deps at root | 🗑️ Delete node_modules, lock files |
| User confirmation | ⚠️ MANDATORY for all actions |
| Archive over delete | 📁 Prefer docs/archive/ for docs |
| Clean = like /init | 🎯 Final state identical to fresh init |

---

## apps/devops/ Manages

| What | Location | Purpose |
|------|----------|---------|
| Docker Compose | `docker/` | Orchestrate all apps locally |
| Dockerfiles | `docker/` or per-app | Build images |
| Environment vars | `env/` | Templates and defaults |
| Scripts | `scripts/` | Automation (setup, deploy) |
| CI/CD configs | Here or `.github/` | Pipelines |
| Terraform/K8s | `infra/` (optional) | Cloud infrastructure |
