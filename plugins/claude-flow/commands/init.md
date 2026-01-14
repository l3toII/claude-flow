---
description: Initialize a new project with the complete workflow. Creates structure, questionnaires, and initial backlog.
allowed-tools: Read, Write, Edit, Bash(git:*), Bash(mkdir:*), Bash(npm:*), Glob, Grep
---

# /init - Project Initialization

Guide the user through complete project initialization.

## Phase 0: Setup Git and Branch

> ⚠️ **MANDATORY**: All initialization changes MUST be done on a dedicated branch.

### For new projects (no git):
```bash
git init
git checkout -b tech/init-project
```

### For existing repos:
```bash
# Ensure clean state
git status

# Create and switch to init branch
git checkout -b tech/init-project
```

**Branch naming**: `tech/init-project`

This ensures:
- Main branch stays clean until structure is validated
- Changes can be reviewed before merge
- Follows the workflow's own conventions (tech/ for infrastructure)

---

## Phase 1: Base Structure

Create the monorepo structure:
```
project/
├── docs/
│   ├── backlog/
│   │   ├── functional/
│   │   ├── technical/
│   │   └── ux/
│   ├── sprints/
│   └── architecture/
├── apps/
├── records/
│   └── decisions/
└── .claude/
```

Create CLAUDE.md as entry point.

## Phase 2: Questionnaires

Ask questions to create:

1. **PROJECT.md**: name, vision, objectives, constraints
2. **PERSONAS.md**: users, context, frustrations, goals
3. **UX.md**: visual mood, inspirations, brand guidelines

## Phase 3: V1 Milestone

1. Identify ALL User Stories for V1
2. Organize into estimated sprints
3. Define dependencies
4. Set Sprint 1 stories to Ready

## Phase 4: Tech Stack

Create **STACK.md** based on needs and `.claude/environments.json`.

## Phase 5: Finalization

1. Create Makefile
2. Create README.md
3. Create GitHub templates

---

## Phase 6: Commit and Create PR

After all structure is created:

```bash
# Stage all files
git add .

# Create initial commit
git commit -m "tech: initialize project with claude-flow workflow

- Add docs/ structure (PROJECT, PERSONAS, UX, STACK)
- Add backlog with V1 milestone stories
- Add sprint planning structure
- Create CLAUDE.md entry point
- Add Makefile and README.md

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# Push branch
git push -u origin tech/init-project
```

Then propose to user:

```
📝 Ready to create PR?

Branch: tech/init-project → main
Title: "tech: initialize project with claude-flow workflow"

This PR sets up the complete project structure.
Review the V1 milestone and sprint planning before merging.
```

**After merge:** The project is ready for `/sprint plan` and `/work`.

---

## Rule

> ⚠️ **Complete V1 Milestone BEFORE any code**
