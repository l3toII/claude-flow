---
description: Initialize a new project with the complete workflow. Creates structure with apps/devops/, questionnaires, and initial backlog.
argument-hint: [project-name]
context: fork
agent: init-agent
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# /init - Project Initialization

Initialize a new project using the init-agent.

## Usage

```
/init                    # Initialize in current directory
/init my-project         # Initialize with project name
```

## What It Does

The init-agent will:

1. **Setup Git** - Initialize repo and create `tech/init-project` branch
2. **Create Structure** - apps/, project/, engineering/, docs/
3. **Run Questionnaires** - Vision, personas, UX preferences
4. **Create Backlog** - V1 milestone and initial stories
5. **Setup DevOps** - apps/devops/ with Docker, env, scripts
6. **Create First App** - Based on chosen stack
7. **Commit & PR** - Ready for review

## Arguments

- `$ARGUMENTS` - Optional project name

## Expected Output

```
project/
├── apps/
│   ├── devops/              # Docker, env, scripts
│   └── [first-app]/         # Based on stack choice
├── project/
│   ├── vision.md
│   ├── personas.md
│   ├── backlog/
│   └── sprints/
├── engineering/
│   ├── stack.md
│   └── architecture.md
├── docs/
├── .claude/
├── CLAUDE.md
├── README.md
├── Makefile
└── package.json
```

## See Also

- `/onboard` - For existing projects
- `/story` - Create individual stories
- `/work` - Start working on a ticket
