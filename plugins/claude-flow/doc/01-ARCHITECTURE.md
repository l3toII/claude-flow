# 01 - Architecture

Technical architecture of the Claude Workflow plugin.

## Plugin Structure

```
claude-flow/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── commands/                 # Slash commands
│   ├── init.md              # Project initialization
│   ├── onboard.md           # Existing project onboarding
│   ├── story.md
│   ├── sprint.md
│   ├── work.md
│   ├── done.md
│   ├── commit.md
│   ├── pr.md
│   ├── release.md
│   ├── env.md               # Environment management
│   ├── status.md
│   ├── sync.md
│   ├── debt.md
│   ├── decision.md
│   ├── ux.md
│   └── bye.md
├── agents/                   # Complex task agents
│   ├── init-agent.md
│   ├── release-agent.md
│   ├── review-agent.md
│   ├── sync-agent.md
│   └── migration-agent.md
├── skills/                   # Knowledge skills
│   ├── commit-conventions/
│   ├── pr-template/
│   ├── story-format/
│   ├── git-flow/
│   ├── repo-conventions/
│   ├── code-conventions/
│   ├── design-principles/
│   ├── github-patterns/
│   └── session-management/
├── hooks/
│   └── hooks.json           # Auto-merge hooks config
├── scripts/                  # Hook scripts
│   ├── session-start.sh
│   ├── session-save.sh
│   ├── guard-story-exists.sh
│   ├── guard-branch-check.sh
│   ├── detect-git-conventions.sh
│   └── post-edit-format.sh
└── doc/
    ├── 00-FOUNDATIONS.md
    ├── 01-ARCHITECTURE.md
    └── 02-INTERACTIONS.md
```

## Component Roles

### Commands (Orchestrators)

Commands are explicit entry points that orchestrate workflows:

```markdown
---
name: done
description: Complete work with commit, PR, and story update
---

# Workflow
1. Run checks (lint, test)
2. Apply commit-conventions skill
3. Create commit
4. Apply pr-template skill
5. Create PR via gh
6. Update story status
```

**Key insight**: Commands orchestrate; they explicitly call skills and execute steps.

### Skills (Knowledge)

Skills provide conventions and best practices but don't orchestrate:

```markdown
---
name: commit-conventions
description: Conventional commit format
---

# Format
type(scope): description (#ticket)

# Types
feat, fix, docs, style, refactor, test, chore
```

**Key insight**: Skills are passive knowledge, activated by commands or Claude's judgment.

### Agents (Complex Tasks)

Agents handle multi-step complex tasks:

```markdown
---
name: release-agent
tools: Read, Write, Edit, Bash, Glob, Grep
model: sonnet
---

# Responsibilities
1. Pre-release validation
2. Version management
3. Changelog generation
4. GitHub release
5. Deployment
```

### Hooks (Automatic Guards)

Hooks run automatically on specific events:

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "bash ${CLAUDE_PLUGIN_ROOT}/scripts/guard-story-exists.sh"
      }]
    }]
  }
}
```

**Exit codes**:
- `0`: Allow action
- `2`: Block action (guard triggered)

## Project Structure (Generated)

When `/init` or `/onboard` runs, it creates:

```
project/
├── apps/
│   ├── devops/                  # DevOps configuration
│   │   ├── docker/
│   │   │   ├── docker-compose.yml
│   │   │   ├── docker-compose.dev.yml
│   │   │   └── docker-compose.prod.yml
│   │   ├── env/
│   │   │   ├── .env.example
│   │   │   └── .env.dev
│   │   ├── scripts/
│   │   │   ├── setup.sh
│   │   │   └── deploy.sh
│   │   └── README.md
│   ├── api/                     # Backend app
│   │   ├── src/
│   │   ├── package.json
│   │   ├── Dockerfile
│   │   └── README.md
│   └── web/                     # Frontend app
│       ├── src/
│       ├── package.json
│       ├── Dockerfile
│       └── README.md
├── docs/
│   ├── backlog/
│   │   ├── functional/          # US-XXX stories
│   │   ├── technical/           # TS-XXX stories
│   │   └── ux/                  # UX-XXX stories
│   ├── sprints/                 # SPRINT-XXX files
│   ├── PROJECT.md
│   ├── PERSONAS.md
│   ├── UX.md
│   ├── STACK.md
│   └── ARCHITECTURE.md
├── records/
│   └── decisions/               # ADRs
├── .claude/
│   ├── session.json             # Session state
│   ├── environments.json        # Environment config
│   └── repos.json               # Git conventions
├── .gitignore
├── CLAUDE.md                    # Entry point
├── README.md
├── Makefile                     # Orchestration
└── package.json                 # Workspace only
```

## Root Whitelist

**ONLY these files/folders allowed at root:**

| Item | Purpose |
|------|---------|
| `apps/` | All application code + devops |
| `docs/` | Documentation |
| `records/` | Decision records |
| `.claude/` | Plugin config |
| `.git/` | Git repository |
| `.gitignore` | Git ignore |
| `.github/` | CI/CD (optional) |
| `CLAUDE.md` | Entry point |
| `README.md` | Overview |
| `LICENSE` | License |
| `Makefile` | Orchestration |
| `package.json` | Workspace only |

**Everything else must be in `apps/` or deleted.**

## apps/devops/ Role

Central DevOps management:

| Directory | Purpose |
|-----------|---------|
| `docker/` | Docker Compose files |
| `env/` | Environment variables |
| `scripts/` | Automation scripts |
| `infra/` | Terraform/K8s (optional) |

**Integration with Makefile:**

```makefile
up:    cd apps/devops/docker && docker-compose up -d
down:  cd apps/devops/docker && docker-compose down
logs:  cd apps/devops/docker && docker-compose logs -f $(app)
setup: ./apps/devops/scripts/setup.sh
```

## Data Flow

```
┌─────────────────────────────────────────────────────────────┐
│                      USER INPUT                             │
│                      /work #42                              │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    COMMAND: work.md                         │
│  1. Load session.json                                       │
│  2. Read story from docs/backlog/                           │
│  3. Create branch feature/#42-*                             │
│  4. Update session.json                                     │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    USER WORKS...                            │
│              (Claude helps with code)                       │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                 HOOK: PreToolUse                            │
│         guard-story-exists.sh checks branch                 │
│              Exit 0 = allow, Exit 2 = block                 │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                      USER INPUT                             │
│                        /done                                │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    COMMAND: done.md                         │
│  1. Run lint & tests                                        │
│  2. Apply SKILL: commit-conventions                         │
│  3. git commit                                              │
│  4. Apply SKILL: pr-template                                │
│  5. gh pr create                                            │
│  6. Update story status → Review                            │
└─────────────────────────────────────────────────────────────┘
```

## Environment Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    LOCAL DEVELOPMENT                        │
│                   /env local (or make up)                   │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│              apps/devops/docker/docker-compose.yml          │
│  - Starts api, web, db containers                           │
│  - Uses apps/devops/env/.env                                │
│  - Mounts app source for hot reload                         │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                     DEPLOYMENT                              │
│                /env deploy api staging                      │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│            Platform CLI (Railway, Vercel, Fly.io)           │
│  - Reads .claude/environments.json                          │
│  - Deploys to configured service                            │
│  - Production requires confirmation                         │
└─────────────────────────────────────────────────────────────┘
```

## Technical Validation

| Component | Status | Notes |
|-----------|--------|-------|
| Hooks auto-merge | ✅ Works | Official docs |
| `${CLAUDE_PLUGIN_ROOT}` | ✅ Works | Variable available |
| Exit code 2 blocks | ✅ Works | Official docs |
| Skills auto-invoke | ⚠️ 50-84% | Command invocation preferred |
| Commands orchestrate | ✅ Reliable | Best practice |
| apps/devops/ pattern | ✅ Adopted | Centralized DevOps |
