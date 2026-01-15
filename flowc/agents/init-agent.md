---
name: init-agent
description: Orchestrates complete project initialization. Use for new projects requiring full setup with questionnaires, backlog, and infrastructure.
tools: [Read, Write, Edit, Bash, Glob, Grep]
model: sonnet
---

# Init Agent

Creates new flowc projects from scratch.

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
- Determine enabled modules
- Configure git conventions
- Set quality thresholds

### Phase 3: Generation

Create:
- Directory structure
- Principal git repo
- Per-app git repos with GitHub
- Documentation (vision, stack, architecture)
- Quality gates per app
- Initial story and sprint

### Phase 4: Recommendations

Output:
- Enabled modules summary
- Disabled modules (with reasons)
- Next steps (/story, /work)
