---
description: Initialize a new project with the complete workflow. Creates structure, questionnaires, and initial backlog.
---

# /init - Initialize Project

Create a new flowc project from scratch.

## Usage

```
/init                # Start interactive setup
```

## Phases

### Phase 1: Discovery
Questionnaire:
- Project name, description
- Type (SaaS, API, CLI, Library)
- Team size, methodology
- Stack selection
- Quality requirements
- Deployment platform

### Phase 2: Analysis
Based on answers:
- Determine enabled features
- Configure git conventions
- Set quality thresholds

### Phase 3: Generation
Create:
- Directory structure
- Principal git repo
- Per-app git repos (if multi-app)
- Documentation templates
- Quality gates per app
- Initial story and sprint

### Phase 4: Recommendations
Output:
- Enabled features summary
- Suggested workflow
- Next steps (/story, /work)

## Generated Structure

```
project/
├── apps/
│   ├── api/
│   │   ├── .git/
│   │   ├── .claude/quality.json
│   │   └── README.md
│   ├── web/
│   │   ├── .git/
│   │   ├── .claude/quality.json
│   │   └── README.md
│   └── devops/
│       └── docker/
├── project/
│   ├── backlog/
│   └── sprints/
├── engineering/
│   ├── architecture.md
│   └── decisions/
├── .claude/
│   ├── session.json
│   └── apps.json
├── CLAUDE.md
└── README.md
```
