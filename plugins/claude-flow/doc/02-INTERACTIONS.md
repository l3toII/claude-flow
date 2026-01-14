# 02 - Interactions

Complete user flows and command interactions.

## Main Workflow

```
/init → /story → /sprint plan → /work #XX → [code] → /done → /release
```

## Command Reference

### /init - Project Initialization

**Purpose**: Set up a new project with full workflow structure.

**Execution**: Delegates to `init-agent` via `context: fork`.

**Flow**:
```
User: /init

Agent: [Creates branch: tech/init-project]
       [Asks about project name and vision]
       [Asks about personas]
       [Asks about UX direction]
       [Identifies V1 stories]
       [Creates sprint plan]
       [Asks about tech stack]
       [Generates all files]
       [Commits and creates PR]

Output:
├── apps/
│   ├── devops/ (docker, env, scripts)
│   └── [first-app]/
├── project/
│   ├── vision.md
│   ├── personas.md
│   ├── ux.md
│   ├── backlog/
│   │   ├── functional/US-001.md ... US-012.md
│   │   ├── technical/
│   │   └── ux/
│   └── sprints/SPRINT-001.md
├── engineering/
│   ├── stack.md
│   ├── architecture.md
│   └── decisions/
├── docs/
├── .claude/
├── .gitignore
├── CLAUDE.md
├── Makefile
└── package.json (workspace only)

Branch: tech/init-project → main (PR)
```

---

### /onboard - Onboard Existing Project

**Purpose**: Transform existing codebase into clean workflow structure.

**Execution**: Delegates to `onboard-agent` via `context: fork`.

**Usage**:
```bash
/onboard              # Standard onboarding
/onboard --full       # With backlog generation
```

**Core Principle**: Whitelist approach - only specific files allowed at root.

**Flow**:
```
User: /onboard

Agent: [Creates branch: tech/onboard-workflow]
       [Scans root and categorizes files]
       [Shows cleanup report]
       [Asks for confirmation]
       [Executes cleanup]
       [Reconciles documents with code]
       [Detects multi-git setups]
       [Creates workflow structure]
       [Commits and creates PR]

Cleanup Categories:
├── ✅ WHITELIST (keep): .git/, README.md, LICENSE
├── 🚚 CODE → apps/[name]/: src/, lib/, index.ts
├── ⚙️ CONFIG → apps/[name]/: tsconfig, eslint, prettier
├── 🐳 DEVOPS → apps/devops/: Dockerfile, docker-compose, .env
├── 🗑️ DELETE (monorepo tools): turbo.json, nx.json
├── 🗑️ DELETE (regenerable): node_modules/, locks, dist/
└── 📦 ARCHIVE → docs/archive/: CHANGELOG.md

Branch: tech/onboard-workflow → main (PR)
```

---

### /story - Create Story

**Purpose**: Add a new story to the backlog.

**Usage**:
```bash
/story                          # Interactive
/story "Add user login"         # Quick user story
/story tech "Migrate to v2"     # Technical story
/story ux "Redesign dashboard"  # UX story
```

**Flow**:
```
User: /story "OAuth login with Google"

Claude: [Determines type: User Story]
        [Asks for acceptance criteria]
        [Creates US-042-oauth-login.md]
        [Updates backlog index]

Output: project/backlog/functional/US-042-oauth-login.md
```

---

### /sprint - Sprint Management

**Purpose**: Plan, start, lock, and close sprints.

**Usage**:
```bash
/sprint              # Show current status
/sprint plan         # Plan next sprint
/sprint start        # Activate planned sprint
/sprint lock         # Lock for release (fixes only)
/sprint close        # Close and retrospect
```

**Flow**:
```
User: /sprint plan

Claude: [Shows Ready stories]
        "Select stories for Sprint 4:
         □ US-042 OAuth Login (5 pts)
         □ US-043 User Profile (3 pts)
         □ US-044 Settings Page (2 pts)"

User: "42, 43, 44"

Claude: [Creates SPRINT-004.md in project/sprints/]
        [Sets stories to sprint]
        [Creates GitHub milestone]
```

---

### /work - Start Working

**Purpose**: Begin work on a specific ticket.

**Usage**:
```bash
/work #42            # Work on ticket 42
/work US-042         # Work on user story
/work                # Continue previous work
```

**Flow**:
```
User: /work #42

Claude: [Gets repo conventions]
        [Reads US-042 from project/backlog/]
        [Creates branch using repo pattern]
        [Updates .claude/session.json]
        [Shows acceptance criteria]

        "Ready to work on US-042: OAuth Login

         Branch: feature/#42-oauth-login
         Convention: conventional (auto-detected)

         Acceptance Criteria:
         □ User can click 'Login with Google'
         □ OAuth flow completes successfully
         □ User session is created

         Suggested approach:
         1. Add GoogleAuthService
         2. Create OAuth callback route
         3. Update login page"
```

---

### /done - Complete Work

**Purpose**: Finish current work with commit, PR, and story update.

**Usage**:
```bash
/done                # Full workflow
/done --no-pr        # Commit only
/done --draft        # Create draft PR
```

**Flow**:
```
User: /done

Claude: [Gets repo conventions]
        [Runs: make lint && make test]
        ✅ Lint passed
        ✅ Tests passed (47/47)

        [Generates commit using repo's format]
        [Commits and pushes]
        ✅ Committed: feat(auth): add OAuth login (#42)

        [Creates PR to correct base branch]
        ✅ PR #123 created

        [Updates story status]
        ✅ US-042: In Progress → Review

        "Work completed!
         📝 Commit: feat(auth): add OAuth login (#42)
         🔗 PR #123: https://github.com/.../pull/123
         📋 Story US-042 now in Review
         🔧 Convention: conventional (configured)"
```

---

### /commit - Create Commit

**Purpose**: Create a conventional commit (intermediate commits).

**Usage**:
```bash
/commit                  # Auto-generate message
/commit "custom msg"     # With message
/commit --amend          # Amend last commit
```

---

### /pr - Pull Request Management

**Purpose**: Create or review pull requests.

**Usage**:
```bash
/pr                      # Create PR for current branch
/pr review #123          # Review PR
/pr merge #123           # Merge PR
```

---

### /release - Create Release

**Purpose**: Create versioned release with changelog.

**Usage**:
```bash
/release                 # Release all apps
/release api             # Release specific app
/release --dry-run       # Preview only
```

**Flow**:
```
User: /release

Claude: [Checks all stories Done]
        [Determines version: 1.2.0 → 1.3.0 (minor)]
        [Updates CHANGELOG.md]
        [Creates tag: v1.3.0]
        [Creates GitHub release]
        [Deploys to staging]

        "Release v1.3.0 created!
         📝 Changelog updated
         🏷️ Tag: v1.3.0
         🚀 Staging: https://api-staging.example.com"
```

---

### /env - Environment Management

**Purpose**: Manage local and remote environments using apps/devops/.

**Usage**:
```bash
/env                          # Show all status
/env local                    # Start local dev (docker-compose)
/env local down               # Stop local dev
/env deploy api staging       # Deploy to staging
/env deploy api production    # Deploy to prod (confirmation)
/env logs api staging         # View logs
/env rollback api staging     # Rollback
```

**Local Development Flow**:
```
User: /env local

Claude: [Runs: cd apps/devops/docker && docker-compose up -d]

        "📊 Local Environment Started

         LOCAL (apps/devops/docker)
         ├── api:  running ✅ (localhost:3000)
         ├── web:  running ✅ (localhost:5173)
         └── db:   running ✅ (localhost:5432)

         Use 'make logs' to view logs
         Use '/env local down' to stop"
```

---

### /status - Project Status

**Purpose**: Show comprehensive project status.

**Output**:
```
📊 Project Status

🏃 Sprint: SPRINT-003 (Day 5/10)
├── Progress: 60% (6/10 stories)
├── In Progress: 2
├── Review: 1
└── Done: 5

📋 Current Work
├── Branch: feature/#42-oauth-login
└── Story: US-042 OAuth Login

🔄 Pull Requests
├── #123 OAuth login - Awaiting review
└── #120 Session fix - Approved ✅

⚠️ Technical Debt: 6/10
```

---

### /dashboard - Visual Dashboard

**Purpose**: Show visual project overview with apps, environments, sprint status.

**Output**:
```
╔══════════════════════════════════════════════════════════════════════╗
║  📊 PROJECT DASHBOARD                                                 ║
╠══════════════════════════════════════════════════════════════════════╣
║                                                                       ║
║  📦 APPS                                                              ║
║  ─────────────────────────────────────────────────────────────────── ║
║  APP      GIT         BRANCH              STATUS                      ║
║  api      monorepo    feature/#42-auth    ✅ ok (3 ahead)            ║
║  web      monorepo    main                ✅ ok                       ║
║  devops   monorepo    main                ✅ ok                       ║
║                                                                       ║
║  🏃 SPRINT                                                            ║
║  ─────────────────────────────────────────────────────────────────── ║
║  SPRINT-003 (Day 5/10)  [████████░░░░] 60%                           ║
║  Done: 5 │ Review: 1 │ In Progress: 2 │ To Do: 2                      ║
║                                                                       ║
╚══════════════════════════════════════════════════════════════════════╝
```

---

### /apps - Apps Management

**Purpose**: Manage apps in monorepo, including multi-git configurations.

**Usage**:
```bash
/apps                    # List all apps with status
/apps status             # Detailed status
/apps status api         # Specific app status
/apps init [name]        # Initialize new app
/apps git [app] [action] # Manage git per app
/apps check              # Verify all apps configured
```

---

### /sync - Verify Synchronization

**Purpose**: Check code ↔ docs consistency.

**Output**:
```
🔍 Sync Report

✅ Stories ↔ Code: 12/12 synced
⚠️ Architecture drift: 2 discrepancies
🔴 Untracked code: 1 module (apps/payments/)

Run /sync --fix to auto-fix.
```

---

### /debt - Technical Debt

**Purpose**: Manage technical debt budget.

**Usage**:
```bash
/debt                    # Show status
/debt add "reason"       # Add debt ticket
/debt plan               # Plan debt sprint
```

---

### /decision - Decision Tracking

**Purpose**: Track architectural decisions.

**Usage**:
```bash
/decision                # List pending
/decision new "topic"    # Create decision
/decision take D-001     # Make decision
/decision adr D-001      # Generate ADR
```

---

### /ux - UX Management

**Purpose**: Manage UX artifacts.

**Usage**:
```bash
/ux                      # Show UX status
/ux persona              # Create/edit persona
/ux journey              # Create user journey
/ux review               # Anti-slop review
```

---

### /bye - End Session

**Purpose**: End session gracefully.

**Flow**:
```
User: /bye

Claude: [Checks uncommitted changes]
        [Saves .claude/session.json]

        "Session Summary
         Duration: 2h 15m
         Completed: US-042 OAuth Login
         PR #123 awaiting review

         Next session:
         1. Check PR feedback
         2. Continue US-043

         See you!"
```

---

## Guard Interactions

### Story Guard (Blocking)

```
User: [Edits apps/api/src/payments/service.ts]
      [On branch: my-feature (no ticket)]

Hook: guard-story-exists.sh
      Exit code: 2

Claude: "❌ BLOCKED: Code modified without ticket

         You're on branch 'my-feature'.
         Options:
         1. /story 'Add payments'
         2. /work #XX
         3. Create poc/ branch for exploration"
```

### Root Whitelist Guard (Blocking)

```
User: [Tries to commit with tsconfig.json at root]

Hook: validate-root-whitelist.sh
      Exit code: 2

Claude: "❌ ROOT WHITELIST VIOLATION - COMMIT BLOCKED

         🚫 FORBIDDEN FILES AT ROOT:
         ├── tsconfig.json  →  apps/[name]/tsconfig.json

         🔧 TO FIX:
         1. Move config files to their app
         2. Or run: /onboard to auto-clean"
```

### Secret Warning (Non-blocking)

```
User: [Writes file containing API key pattern]

Hook: guard-secrets.sh
      Exit code: 0 (warning only)

Claude: "⚠️ POTENTIAL SECRET DETECTED
         File: apps/api/src/config.ts
         Detected: AWS Access Key pattern

         💡 RECOMMENDATIONS:
         • Use environment variables
         • Store secrets in apps/devops/env/.env

         ⚠️ This is a WARNING - operation proceeds."
```

### Merge Guard (Blocking)

```
User: "Merge my POC branch"

Claude: [Runs: git merge poc/test-graphql]

Hook: guard-branch-check.sh
      Exit code: 2

Claude: "❌ BLOCKED: poc/ branches cannot be merged

         If the POC is successful:
         /story 'Integrate GraphQL API'"
```

### Sprint Lock (Warning)

```
User: [On feature/#45-*, sprint is Locked]

Claude: "⚠️ Sprint is locked for release.
         Only fix/ branches can commit.

         For urgent fix: /work #XX (fix ticket)"
```
