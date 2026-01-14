# 01 - Architecture

Technical architecture of the Claude Workflow plugin.

## Plugin Structure

```
claude-workflow/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── commands/                 # 15 slash commands
│   ├── init.md
│   ├── story.md
│   ├── sprint.md
│   ├── work.md
│   ├── done.md              # Key workflow command
│   ├── commit.md
│   ├── pr.md
│   ├── release.md
│   ├── env.md
│   ├── status.md
│   ├── sync.md
│   ├── debt.md
│   ├── decision.md
│   ├── ux.md
│   └── bye.md
├── agents/                   # 5 complex task agents
│   ├── init-agent.md
│   ├── release-agent.md
│   ├── review-agent.md
│   ├── sync-agent.md
│   └── migration-agent.md
├── skills/                   # 20 knowledge skills
│   ├── commit-conventions/
│   ├── pr-template/
│   ├── story-format/
│   ├── git-flow/
│   ├── code-conventions/
│   ├── test-patterns/
│   ├── design-principles/
│   ├── deploy-platforms/
│   ├── github-patterns/
│   ├── session-management/
│   ├── project-structure/
│   ├── sprint-management/
│   ├── debt-tracking/
│   ├── decision-tracking/
│   ├── changelog-format/
│   ├── release-process/
│   ├── env-config/
│   ├── sync-rules/
│   ├── ux-personas/
│   └── ux-journeys/
├── hooks/
│   └── hooks.json           # Auto-merge hooks config
├── scripts/                  # Hook scripts
│   ├── session-start.sh
│   ├── session-save.sh
│   ├── guard-story-exists.sh
│   ├── guard-branch-check.sh
│   └── post-edit-format.sh
└── docs/
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

When `/init` runs, it creates:

```
project/
├── docs/
│   ├── backlog/
│   │   ├── functional/      # US-XXX stories
│   │   ├── technical/       # TS-XXX stories
│   │   └── ux/              # UX-XXX stories
│   ├── sprints/             # SPRINT-XXX files
│   ├── PROJECT.md
│   ├── PERSONAS.md
│   ├── UX.md
│   ├── STACK.md
│   └── ARCHITECTURE.md
├── records/
│   └── decisions/           # ADRs and decisions
├── apps/                    # Application code
├── .claude/
│   ├── session.json         # Session state
│   └── environments.json    # Environment config
├── CLAUDE.md                # Entry point for Claude
├── Makefile
└── README.md
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
│                 HOOK: PostToolUse                           │
│            post-edit-format.sh auto-formats                 │
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

## Technical Validation

| Component | Status | Evidence |
|-----------|--------|----------|
| Hooks auto-merge | ✅ Works | Official docs |
| `${CLAUDE_PLUGIN_ROOT}` | ✅ Works | Variable available |
| Exit code 2 blocks | ✅ Works | Official docs |
| Skills auto-invoke | ⚠️ 50-84% | Community tests |
| Commands orchestrate | ✅ Reliable | Best practice |
