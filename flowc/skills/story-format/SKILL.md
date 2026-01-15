---
name: story-format
description: Story templates for User Stories, Technical Stories, and UX Stories. Use when creating backlog items.
---

# Story Format

Unified S-XXX story format for all story types.

## Story Types

| Type | Use Case |
|------|----------|
| User Story | Feature with user value |
| Technical Story | Infrastructure, refactoring |
| UX Story | Design, usability improvements |

## Template

```markdown
# S-XXX: [Title]

**Type**: User Story | Technical Story | UX Story
**Status**: Draft | Ready | In Progress | Review | Done
**Sprint**: Sprint X | (unassigned)
**Priority**: P1 | P2 | P3
**Points**: X

## Description
[What needs to be done and why]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Tickets
- [ ] api#XX - [API task description]
- [ ] web#XX - [Frontend task description]

## Technical Notes
[Implementation hints, constraints]

## Dependencies
- Depends on: S-YYY
- Blocks: S-ZZZ

## Notes
[Additional context, links, discussions]
```

## Numbering

- Sequential: S-001, S-002, S-003...
- Prefix always "S-" regardless of type
- Never reuse numbers

## Status Flow

```
Draft → Ready → In Progress → Review → Done
                    ↓
                 Blocked
```
