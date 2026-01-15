---
description: End session gracefully. Saves state, shows summary, reminds about pending items.
---

# /bye - End Session

End the current work session gracefully.

## Usage

```
/bye                 # End session
```

## Actions

1. **Save Session State**
   - Current ticket
   - Branch info
   - Time spent

2. **Show Summary**
   - Work completed
   - Commits made
   - PRs created

3. **Pending Reminders**
   - Uncommitted changes
   - Open PRs needing attention
   - Blocked stories

4. **Next Steps**
   - Suggested next actions
   - Resume command

## Output

```
╔══════════════════════════════════════╗
║         SESSION SUMMARY              ║
╚══════════════════════════════════════╝

⏱️  Session: 2h 15m

📝 Completed:
   - S-042: OAuth login implementation
   - 3 commits
   - 1 PR created (#15)

⚠️  Pending:
   - PR #15 awaiting review
   - 2 uncommitted files

💡 Next time:
   /work S-042    # Resume current
   /pr review 15  # Check PR status

Session saved. See you next time!
```
