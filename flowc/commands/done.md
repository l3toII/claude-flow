---
description: Complete current work. Runs checks, commits, creates PR, updates story status. Adapts to repo conventions.
argument-hint: [--no-pr] [--draft]
---

# /done - Complete Work

Finish current work session with quality checks.

## Usage

```
/done                # Full workflow: checks + PR
/done --no-pr        # Checks only, no PR
/done --draft        # Create draft PR
```

## Workflow

1. **Quality Checks**
   - Run tests
   - Run linter
   - Check coverage
   - Security scan

2. **Commit Changes**
   - Stage changes
   - Generate commit message
   - Commit with ticket reference

3. **Create PR**
   - Push branch
   - Create PR from template
   - Link to ticket

4. **Update Status**
   - Mark ticket as "In Review"
   - Update session state

## Quality Gates

Reads `.claude/quality.json`:

```json
{
  "coverage": { "minimum": 80, "enforce": true },
  "lint": { "warnings_allowed": 0 },
  "tests": { "required": true },
  "security": { "block_secrets": false }
}
```

## PR Template

```markdown
## Summary
[Auto-generated from commits]

## Ticket
Closes #XX

## Changes
- Change 1
- Change 2

## Test Plan
- [ ] Unit tests pass
- [ ] Manual testing done

## Checklist
- [ ] Tests added
- [ ] Docs updated
- [ ] No console.logs
```

## Failure Handling

If checks fail:
- Show failure details
- Do not create PR
- Suggest fixes
