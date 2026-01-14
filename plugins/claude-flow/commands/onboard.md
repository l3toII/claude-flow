---
description: Onboard an existing project into the workflow. Cleans pilot repo, validates sub-repos, and creates workflow structure identical to /init.
argument-hint: [--full]
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, AskUserQuestion
---

# /onboard - Onboard Existing Project

**Transform an existing codebase** into a clean claude-flow project, as close as possible to a fresh `/init`.

## Usage

```
/onboard              # Standard onboarding
/onboard --full       # Full onboarding with backlog generation
```

## Core Principle

> ⚠️ **The pilot repo must be CLEAN** - documentation and workflow only.
> All code lives in `apps/` (one app per sub-directory).

---

## Phase 0: Create Dedicated Branch

> ⚠️ **MANDATORY**: All onboarding changes MUST be done on a dedicated branch.

```bash
git status
git checkout -b tech/onboard-workflow
```

---

## Phase 1: Pilot Repo Audit

### 1.1 Identify Structure Type

Determine if this is:
- **Monorepo**: Has `apps/` with multiple sub-applications
- **Single repo**: All code in root (needs restructuring)
- **Already clean**: Only docs, no code at root

### 1.2 Scan for Violations

**The pilot repo (root) must NOT contain:**

```bash
# Check for code files at root level
ls -la *.ts *.js *.py *.go *.rs *.java 2>/dev/null
ls -la src/ lib/ 2>/dev/null

# Check for package files at root (except workspace root)
ls -la package.json Cargo.toml pyproject.toml go.mod 2>/dev/null
```

**Report violations:**
```
🔍 Pilot Repo Audit

❌ VIOLATIONS FOUND:
├── src/index.ts (code at root)
├── package.json (package file - not workspace)
├── lib/ (code directory)
└── utils.py (code at root)

These files should be in apps/[name]/.
```

### 1.3 User Confirmation Required

> ⚠️ **MANDATORY**: Use AskUserQuestion before ANY cleanup

```
⚠️ CLEANUP REQUIRED

The pilot repo contains code that should be in apps/.

Options:
1. Move to apps/[name]/ - Relocate code to new app
2. Delete - If obsolete/not needed
3. Skip - Keep as-is (NOT RECOMMENDED)

Please confirm for each item.
```

**NEVER delete or move files without explicit user confirmation.**

---

## Phase 2: Apps Validation

### 2.1 Identify Apps

```bash
# Find apps
ls -d apps/*/ 2>/dev/null
```

### 2.2 Validate Each App

For each app in `apps/`, check:

```bash
# Must have package file
ls apps/*/package.json apps/*/Cargo.toml apps/*/pyproject.toml 2>/dev/null
```

### 2.3 Missing .git in Apps

If apps should be independent repos (user preference):

> ⚠️ **MANDATORY**: Ask user before creating .git

```
📦 App: apps/api/

This app has no .git directory.

Options:
1. Initialize git (git init) - Make it an independent repo
2. Keep as monorepo subfolder - No separate git

Your choice?
```

If user chooses to initialize:
```bash
cd apps/api
git init
git add .
git commit -m "chore: initialize app repo"
cd ../..
```

### 2.4 App Health Check

Each app MUST have:
- [ ] Package file (package.json, Cargo.toml, etc.)
- [ ] README.md (create if missing)
- [ ] Entry point (src/index.*, main.*, etc.)

**Create missing essentials:**
```
📦 App: apps/api/

Missing files:
├── ❌ README.md
└── ✅ package.json

Create README.md? [Y/n]
```

---

## Phase 3: Clean Old Documentation

### 3.1 Detect Old/Conflicting Docs

```bash
# Find existing docs that may conflict
ls -la README.md CONTRIBUTING.md docs/*.md 2>/dev/null
find . -name "*.md" -not -path "*/node_modules/*" -not -path "*/.git/*"
```

### 3.2 User Confirmation for Cleanup

> ⚠️ **MANDATORY**: List ALL files to be modified/deleted

```
📄 DOCUMENTATION CLEANUP

Found existing documentation:

TO REPLACE (workflow docs):
├── docs/PROJECT.md → Will be regenerated
├── docs/ARCHITECTURE.md → Will be regenerated
└── CLAUDE.md → Will be regenerated

TO REVIEW (may contain valuable info):
├── README.md → Merge into new docs?
├── docs/old-spec.md → Archive or delete?
└── CONTRIBUTING.md → Keep or regenerate?

For each file marked "TO REVIEW":
1. Merge - Extract content into new workflow docs
2. Archive - Move to docs/archive/
3. Delete - Remove completely
4. Keep - Leave as-is

Please confirm each action.
```

**Archive old docs instead of deleting when possible:**
```bash
mkdir -p docs/archive
mv docs/old-spec.md docs/archive/
```

---

## Phase 4: Deep Project Analysis

### 4.1 Scan Apps

For each app, analyze:

```bash
# Read main package file
cat apps/*/package.json

# Understand structure
tree apps/*/ -L 2 -I 'node_modules|dist|build'

# Find entry points
ls apps/*/src/index.* apps/*/src/main.*
```

### 4.2 Understand the Application

**Actively read source code to understand:**
- What does each app do?
- Who are the users?
- What are the main features?
- What's the architecture?
- What external services are used?

---

## Phase 5: Create Workflow Structure

### 5.1 Create Directories

```bash
mkdir -p docs/backlog/functional
mkdir -p docs/backlog/technical
mkdir -p docs/backlog/ux
mkdir -p docs/sprints
mkdir -p docs/architecture
mkdir -p records/decisions
mkdir -p .claude
```

### 5.2 Create Workflow Documents

Create these files with detected information:

| File | Content |
|------|---------|
| `docs/PROJECT.md` | Vision, objectives, constraints (from analysis) |
| `docs/PERSONAS.md` | Users deduced from code |
| `docs/UX.md` | UI/UX analysis |
| `docs/STACK.md` | Detected tech stack |
| `.claude/repos.json` | Git conventions |
| `CLAUDE.md` | Entry point |

### 5.3 Root package.json (Workspace Only)

If root has package.json, ensure it's workspace-only:

```json
{
  "name": "project-workspace",
  "private": true,
  "workspaces": ["apps/*"],
  "scripts": {
    "dev": "turbo dev",
    "build": "turbo build",
    "test": "turbo test"
  }
}
```

**No dependencies at root level** (except workspace tools like turbo, nx).
**No packages/ or shared/** - if shared code is needed, create an app in `apps/`.

---

## Phase 6: Generate Initial Backlog (if --full)

### 6.1 Technical Debt → TS-XXX

Scan for:
- TODO/FIXME comments
- Outdated dependencies
- Missing tests
- Security issues

### 6.2 Missing Features → US-XXX

Based on:
- Stubbed functions
- Empty handlers
- Commented code

### 6.3 UX Improvements → UX-XXX

If frontend exists:
- Accessibility issues
- Missing responsive design
- UI inconsistencies

---

## Phase 7: Final Validation

### 7.1 Pilot Repo Checklist

```
✅ PILOT REPO VALIDATION

Root level files:
├── ✅ docs/ (workflow documentation)
├── ✅ records/ (decisions)
├── ✅ .claude/ (config)
├── ✅ CLAUDE.md (entry point)
├── ✅ README.md (project overview)
├── ✅ Makefile (commands)
├── ⚠️ package.json (workspace only - no deps)
├── ❌ No src/ at root
├── ❌ No lib/ at root
└── ❌ No code files (*.ts, *.js, etc.)

Apps:
├── ✅ apps/api/ (has package.json, README)
└── ✅ apps/web/ (has package.json, README)
```

### 7.2 Summary Report

```
✅ Project Onboarded: [name]

🧹 Cleanup Performed:
├── Moved: src/ → apps/core/
├── Archived: docs/old-spec.md → docs/archive/
└── Created: apps/api/README.md

📁 Structure Created:
├── docs/
│   ├── PROJECT.md (vision & objectives)
│   ├── PERSONAS.md (user profiles)
│   ├── UX.md (design direction)
│   ├── STACK.md (tech documentation)
│   └── backlog/ (story structure)
├── records/decisions/
├── .claude/repos.json (git conventions)
└── CLAUDE.md (quick reference)

📦 Apps Validated:
├── apps/api/ ✅
└── apps/web/ ✅

📊 Analysis:
├── Tech: [stack summary]
├── Git Flow: [detected]
├── Features: [count] identified
└── Tech Debt: [count] items found
```

---

## Phase 8: Commit and Create PR

```bash
# Stage all changes
git add .

# Create commit
git commit -m "tech: onboard project to claude-flow workflow

- Clean pilot repo (docs only, no code)
- Validate apps/ structure
- Add docs/ structure (PROJECT, PERSONAS, UX, STACK)
- Add backlog structure (functional/, technical/, ux/)
- Add .claude/repos.json with detected Git conventions
- Create CLAUDE.md entry point

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# Push branch
git push -u origin tech/onboard-workflow
```

**Propose PR:**
```
📝 Ready to create PR?

Branch: tech/onboard-workflow → main
Title: "tech: onboard project to claude-flow workflow"

This PR:
- Cleans the pilot repo structure
- Validates all apps in apps/
- Adds complete workflow documentation

⚠️ Review carefully before merging - structural changes included.
```

---

## Key Rules

| Rule | Enforcement |
|------|-------------|
| No code at root | ❌ Block if found, require move to apps/ |
| No packages/shared | ❌ All code in apps/, no shared packages |
| User confirmation | ⚠️ MANDATORY for all destructive actions |
| App validation | ✅ Each app must have package file + README |
| Archive over delete | 📁 Prefer docs/archive/ over deletion |
| Clean = like /init | 🎯 Final state must match fresh init |

---

## Comparison with /init

| Aspect | /init | /onboard |
|--------|-------|----------|
| Starting point | Empty | Existing code |
| Information source | User answers | Code analysis |
| Code location | Created in apps/ | Validated/moved to apps/ |
| Pilot repo | Clean from start | Cleaned during process |
| User interaction | Questionnaires | Confirmations for changes |
| End result | **IDENTICAL** | **IDENTICAL** |
