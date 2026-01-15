---
name: github-patterns
description: GitHub integration patterns for issues, PRs, releases, and milestones. Use when interacting with GitHub.
---

# GitHub Patterns

Patterns for GitHub CLI integration.

## Issues

```bash
# Create issue
gh issue create \
  --title "S-042: OAuth Login" \
  --body "Description" \
  --label "feature"

# List issues
gh issue list --state open

# Close issue
gh issue close 42 --comment "Done in PR #123"
```

## Pull Requests

```bash
# Create PR
gh pr create \
  --title "feat(auth): OAuth login (#42)" \
  --body "Summary" \
  --base main

# Review PR
gh pr review 123 --approve

# Merge PR
gh pr merge 123 --squash --delete-branch
```

## Releases

```bash
# Create release
gh release create v1.3.0 \
  --title "v1.3.0" \
  --notes "Changelog"

# List releases
gh release list
```

## Workflows

```bash
# List runs
gh run list

# Watch run
gh run watch 12345

# Rerun failed
gh run rerun 12345 --failed
```

## Labels

Standard labels:
- `bug`, `feature`, `enhancement`
- `documentation`, `refactor`
- `high-priority`, `low-priority`
- `blocked`, `needs-review`
