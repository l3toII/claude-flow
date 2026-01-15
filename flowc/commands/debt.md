---
description: Manage technical debt. View debt budget, create debt tickets, plan debt sprints.
argument-hint: [action] [reason]
---

# /debt - Technical Debt Management

Track and manage technical debt.

## Usage

```
/debt                    # Show debt status
/debt add "reason"       # Add debt item
/debt budget             # Show debt budget
/debt sprint             # Plan debt reduction sprint
```

## Actions

### /debt (status)
Shows:
- Current debt items
- Debt by category
- Age of debt
- Impact assessment

### /debt add
Create a debt ticket:
- Description
- Category (code, architecture, tests, docs)
- Impact (high, medium, low)
- Estimated effort

### /debt budget
Track debt budget:
- Max allowed debt items
- Current debt count
- Debt ratio (debt / features)

### /debt sprint
Plan a debt reduction sprint:
- Select debt items
- Estimate effort
- Create stories

## Debt Categories

| Category | Description |
|----------|-------------|
| `code` | Code quality issues |
| `architecture` | Design problems |
| `tests` | Missing or poor tests |
| `docs` | Documentation gaps |
| `deps` | Outdated dependencies |
| `security` | Security concerns |

## Debt File

`project/debt/DEBT-XXX.md`:

```markdown
# DEBT-XXX: [Title]

**Category**: code | architecture | tests | docs
**Impact**: high | medium | low
**Effort**: S | M | L | XL
**Created**: YYYY-MM-DD

## Description
[What is the debt]

## Impact
[Why it matters]

## Resolution
[How to fix it]
```
