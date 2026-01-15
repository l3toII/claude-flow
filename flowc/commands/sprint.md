---
description: Manage sprints - plan, start, lock, close. View sprint status and progress.
argument-hint: [action]
---

# /sprint - Sprint Management

Manage development sprints.

## Usage

```
/sprint                  # Show current sprint status
/sprint plan            # Plan next sprint
/sprint start           # Start planned sprint
/sprint lock            # Lock sprint (no new stories)
/sprint close           # Close sprint, move incomplete
```

## Sprint Lifecycle

```
Plan → Start → Lock → Close
         ↓
    [Development]
```

## Actions

### /sprint (status)
Shows:
- Current sprint name and dates
- Stories in sprint with status
- Velocity and progress
- Blockers

### /sprint plan
- Review backlog
- Select stories for sprint
- Estimate capacity
- Set sprint goal

### /sprint start
- Activate planned sprint
- Create sprint file
- Notify team

### /sprint lock
- Prevent new stories
- Focus on completion
- Mark sprint as locked

### /sprint close
- Review completed work
- Move incomplete to backlog
- Calculate velocity
- Generate retrospective template

## Sprint File

`project/sprints/sprint-XX.md`:

```markdown
# Sprint XX: [Goal]

**Start**: YYYY-MM-DD
**End**: YYYY-MM-DD
**Status**: Planning | Active | Locked | Closed

## Goal
[Sprint objective]

## Stories
- [x] S-001: Story title (done)
- [ ] S-002: Story title (in progress)

## Metrics
- Planned: X points
- Completed: Y points
- Velocity: Z points
```
