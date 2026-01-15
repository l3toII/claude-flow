---
description: Create a new story (User Story, Technical Story, or UX Story). Use when adding features to the backlog.
argument-hint: [type] [title]
---

# /story - Create Story

Create a story in the unified S-XXX format.

## Usage

```
/story "User login feature"           # Creates S-XXX
/story tech "Refactor auth module"    # Technical story
/story ux "Improve onboarding"        # UX story
```

## Story Types

| Type | Prefix | Description |
|------|--------|-------------|
| `user` (default) | S-XXX | Feature with user value |
| `tech` | S-XXX | Technical improvement |
| `ux` | S-XXX | UX/Design improvement |

## Workflow

1. **Create Story File**
   - Generate next S-XXX number
   - Create `project/backlog/S-XXX.md`

2. **Create GitHub Issue**
   - In principal repo
   - Link to story file

3. **Create App Tickets** (if multi-app)
   - Create issues in each app repo
   - Link back to parent story

## Story Template

```markdown
# S-XXX: [Title]

**Type**: User Story | Technical Story | UX Story
**Status**: Draft | Ready | In Progress | Done
**Sprint**: (unassigned)
**Priority**: P1 | P2 | P3

## Description
[What and why]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Tickets
- [ ] api#XX - API implementation
- [ ] web#XX - Frontend implementation

## Notes
[Additional context]
```
