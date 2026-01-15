# flowc

A complete development workflow plugin for Claude Code. Manage stories, sprints, commits, PRs, releases, and environments — with anti-vibe-code guards.

> **Documentation complète** : Voir [doc/GUIDE.md](doc/GUIDE.md) pour le guide détaillé.

## Installation

```bash
# From local path
/plugin install /path/to/flowc
```

## Quick Start

```bash
/init                    # Initialize new project
/story "User login"      # Create story → tickets per app
/work S-001              # Start working
# Implement...
/done                    # Quality checks + PR
```

## Commands

| Command | Description |
|---------|-------------|
| `/story` | Create User/Technical/UX story |
| `/sprint` | Manage sprints |
| `/work` | Start working on ticket |
| `/done` | Complete with quality checks + PR |
| `/commit` | Conventional commit |
| `/pr` | Create/review/merge PRs |
| `/sync` | Verify code/docs sync |
| `/release` | Create release with changelog |
| `/env` | Manage environments |
| `/status` | Show project status |
| `/init` | Initialize new project |
| `/onboard` | Onboard existing codebase |
| `/debt` | Track technical debt |
| `/decision` | Architectural decisions (ADRs) |
| `/apps` | Manage apps in monorepo |
| `/bye` | End session gracefully |

## Agents

| Agent | Description |
|-------|-------------|
| `dev-agent` | Autonomous feature implementation |
| `review-agent` | Code review with checklist |
| `sync-agent` | Code/docs synchronization audit |
| `release-agent` | Release orchestration |
| `init-agent` | Project initialization |
| `onboard-agent` | Codebase migration |

## Natural Language Workflow

No need to memorize commands. Just describe what you want:

```
You: "Implement an OAuth login feature"

flowc:
  No active work session.
  To write code, you need an active ticket:
  1. /story "OAuth Login"
  2. /work S-XXX
  3. Then implement
  4. /done
```

## Story → Ticket → PR Flow

```
Story S-042 (principal repo, issue #42)
│
├── Ticket api#15 ──▶ /work S-042 --app api ──▶ PR in api repo
│
└── Ticket web#23 ──▶ /work S-042 --app web ──▶ PR in web repo

When all tickets done → Story S-042 = Done
```

## Quality Gates

Each app has `.claude/quality.json`:

```json
{
  "coverage": { "minimum": 80, "enforce": true },
  "lint": { "warnings_allowed": 0 },
  "tests": { "required": true },
  "security": { "block_secrets": true }
}
```

`/done` enforces these before creating PR.

## Anti-Vibe-Code Guards

Automatic guards prevent workflow violations:

- **Story Guard**: Warns commits without ticket branch
- **Secret Warning**: Warns about potential secrets
- **Intent Detection**: Guides natural language to commands

## Project Structure

After `/init` or `/onboard`:

```
project/
├── apps/
│   ├── api/ (.git)
│   │   └── .claude/quality.json
│   ├── web/ (.git)
│   │   └── .claude/quality.json
│   └── devops/
├── project/
│   ├── backlog/S-XXX.md
│   └── sprints/
├── engineering/
│   ├── architecture.md
│   └── decisions/
├── .claude/
│   └── session.json
└── README.md
```

## License

MIT
