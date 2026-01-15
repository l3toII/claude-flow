---
description: Show complete project status - sprint, stories, PRs, environments, debt.
argument-hint: [section]
---

# /status - Project Status

Show comprehensive project status.

## Usage

```
/status              # Full status
/status sprint       # Sprint only
/status stories      # Stories only
/status prs          # PRs only
/status env          # Environments only
```

## Full Status Output

```
╔══════════════════════════════════════╗
║         PROJECT STATUS               ║
╚══════════════════════════════════════╝

📅 Sprint 3 (Day 5/10)
   Goal: Complete OAuth integration
   Progress: ████████░░ 80%

📋 Stories
   ✅ S-041: User registration (done)
   🔄 S-042: OAuth login (in progress)
   📋 S-043: Password reset (ready)

🔀 Pull Requests
   #15 api: OAuth endpoints (review)
   #23 web: Login UI (draft)

🌐 Environments
   staging: v1.1.0 ✅ healthy
   production: v1.0.2 ✅ healthy

⚠️  Debt: 3 items (budget: 5)

📊 Velocity: 21 pts/sprint
```

## Sections

### Sprint
- Current sprint info
- Progress bar
- Days remaining
- Blockers

### Stories
- Stories by status
- Assignment info
- Ticket links

### PRs
- Open PRs per app
- Review status
- CI status

### Environments
- Deployment status
- Version info
- Health checks

### Debt
- Debt count vs budget
- High priority items
