# 00 - Foundations

Core principles and philosophy of the Claude Workflow system.

## Vision

A development workflow where **every line of code traces to a story**, eliminating "vibe coding" and ensuring project coherence from conception to deployment.

## Core Principles

### 1. Story-First Development

> No code without a story

Every code change must be linked to a tracked story:
- **User Story (US-XXX)**: User-facing features
- **Technical Story (TS-XXX)**: Technical work (refactoring, migrations)
- **UX Story (UX-XXX)**: Design and UX changes

### 2. Anti-Vibe-Code Guards

Automatic guards prevent untracked development:

| Guard | Trigger | Action |
|-------|---------|--------|
| Story Guard | Code edit in `apps/` | Block if no ticket branch |
| Merge Guard | `git merge poc/*` | Block (exploration only) |
| Sprint Lock | Commit during lock | Allow only `fix/*` branches |

### 3. Branch = Ticket

Branch naming enforces traceability:

```
feature/#42-oauth-login  → US-042
fix/#43-session-bug      → Bug #43
tech/#44-migrate-db      → TS-044
poc/experiment           → No merge allowed
vibe/exploration         → No merge allowed
```

### 4. Documentation as Source of Truth

```
docs/
├── PROJECT.md       # Vision, objectives, constraints
├── PERSONAS.md      # User personas
├── UX.md            # Design direction
├── STACK.md         # Technical choices
├── ARCHITECTURE.md  # System architecture
└── backlog/         # All stories
```

### 5. Milestone Before Code

> Complete V1 planning BEFORE writing code

1. Define PROJECT.md
2. Create PERSONAS.md
3. Establish UX.md direction
4. Identify ALL V1 stories
5. Plan sprints
6. Choose STACK.md
7. THEN start coding

## Workflow Philosophy

### Commands Orchestrate

Commands are the entry points that orchestrate workflows:
- `/init` → Full project setup
- `/work #42` → Start ticket work
- `/done` → Complete work (commit + PR + update)

### Skills Provide Knowledge

Skills contain conventions and best practices:
- Commit message format
- PR template structure
- Story templates

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
