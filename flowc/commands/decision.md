---
description: Track architectural decisions. Create, list, and resolve decisions. Generate ADRs.
argument-hint: [action] [D-XXX]
---

# /decision - Architectural Decisions

Track architectural decision records (ADRs).

## Usage

```
/decision                    # List pending decisions
/decision new "title"        # Create new decision
/decision resolve D-001      # Resolve a decision
/decision list               # List all decisions
```

## Actions

### /decision (pending)
Shows decisions awaiting resolution.

### /decision new
Create a new ADR:
- Title and context
- Options considered
- Status: proposed

### /decision resolve
Resolve a decision:
- Select chosen option
- Document rationale
- Update status to accepted

### /decision list
List all decisions with status.

## Decision Status

| Status | Description |
|--------|-------------|
| `proposed` | Under discussion |
| `accepted` | Decision made |
| `deprecated` | No longer applies |
| `superseded` | Replaced by another |

## ADR Template

`engineering/decisions/D-XXX-title.md`:

```markdown
# D-XXX: [Title]

**Status**: proposed | accepted | deprecated | superseded
**Date**: YYYY-MM-DD
**Deciders**: [who]

## Context
[Why this decision is needed]

## Options Considered

### Option 1: [Name]
- Pros: ...
- Cons: ...

### Option 2: [Name]
- Pros: ...
- Cons: ...

## Decision
[Chosen option and why]

## Consequences
[What changes as a result]
```
