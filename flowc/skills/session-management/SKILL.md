---
name: session-management
description: Session state persistence and restoration. Use when starting sessions, saving progress, or managing context.
---

# Session Management

Manage work session state.

## Session File

`.claude/session.json`:

```json
{
  "active_ticket": "S-042",
  "active_app": "api",
  "branch": "feature/#42-oauth-login",
  "started_at": "2025-01-14T10:00:00Z",
  "status": "working",
  "last_commit": "abc123",
  "time_spent_minutes": 45
}
```

## Session States

| Status | Description |
|--------|-------------|
| `idle` | No active work |
| `working` | Actively coding |
| `reviewing` | In code review |
| `blocked` | Waiting on something |

## Operations

### Start Session
```bash
# Set active ticket
# Record start time
# Load context
```

### Save Session
```bash
# Update time spent
# Save current state
# Preserve context
```

### Resume Session
```bash
# Load previous state
# Restore context
# Show summary
```

## Context Preservation

Between sessions, preserve:
- Current ticket and app
- Branch information
- Time tracking
- Recent actions
