---
description: Start working on a ticket. Creates branch, loads context, sets up environment. Adapts to repo conventions.
argument-hint: [#ticket]
---

# /work - Start Working

Start a work session on a ticket.

## Usage

```
/work S-042              # Work on story (single app)
/work S-042 --app api    # Work on specific app ticket
/work                    # Resume current work
```

## Workflow

1. **Validate Ticket**
   - Check ticket exists
   - Check ticket is ready

2. **Setup Branch**
   - Checkout main/develop
   - Pull latest
   - Create feature branch

3. **Load Context**
   - Read story file
   - Load related docs
   - Show acceptance criteria

4. **Update Session**
   - Set active ticket
   - Record start time

## Branch Naming

Adapts to repo conventions:
- `feature/#42-oauth-login`
- `feat/S-042-oauth-login`
- `S-042/oauth-login`

## Session State

Creates/updates `.claude/session.json`:

```json
{
  "active_ticket": "S-042",
  "active_app": "api",
  "branch": "feature/#42-oauth-login",
  "started_at": "2025-01-14T10:00:00Z",
  "status": "working"
}
```

## Guards

- Cannot start if uncommitted changes exist
- Cannot start non-ready tickets
- Warns if switching without completing current
