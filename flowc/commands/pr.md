---
description: Create or review pull requests. Adapts to repo conventions for base branch and PR format.
argument-hint: [action] [#PR]
---

# /pr - Pull Request Management

Create and manage pull requests.

## Usage

```
/pr                     # Create PR for current branch
/pr review 123          # Review PR #123
/pr merge 123           # Merge PR #123
/pr list                # List open PRs
```

## Actions

### /pr (create)
Create PR for current branch:
- Auto-detect base branch
- Generate PR body
- Link to ticket

### /pr review
Review a PR:
- Fetch PR details
- Show diff summary
- Run review agent

### /pr merge
Merge a PR:
- Check CI status
- Squash and merge
- Delete branch

### /pr list
List open PRs with status.

## PR Body Template

```markdown
## Summary
[Generated from commits]

## Related Issue
Closes #XX

## Changes
- Change 1
- Change 2

## Test Plan
- [ ] Tests pass
- [ ] Manual testing

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

## Base Branch Detection

Adapts to flow type:
- **github-flow**: `main`
- **gitflow**: `develop`
- **trunk-based**: `main`

## Review Checklist

Automated checks:
- [ ] Tests pass
- [ ] Coverage maintained
- [ ] No lint warnings
- [ ] No security issues
- [ ] Docs updated
