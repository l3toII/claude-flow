# Claude Flow

A complete development workflow plugin for Claude Code. Manage stories, sprints, commits, PRs, releases, and environments — all with anti-vibe-code guards to keep your project organized.

## Features

- **Story Management**: Create and track User Stories, Technical Stories, and UX Stories
- **Sprint Planning**: Plan, start, lock, and close sprints
- **Adaptive Git**: Detects repo conventions (GitFlow, GitHub Flow, Jira) and adapts
- **Anti-Vibe-Code Guards**: Prevent untracked code from being written
- **Secret Detection**: Warns about potential secrets before writing files
- **Automated Commits**: Conventional commits with ticket references
- **PR Generation**: Rich PR descriptions with test plans
- **Release Management**: Changelog generation and GitHub releases
- **Environment Management**: Deploy to staging/production with safeguards
- **Technical Debt Tracking**: Budget-based debt management
- **Session Persistence**: Resume where you left off

## Installation

```bash
# From Claude Code marketplace
claude plugin install claude-flow

# Manual installation
git clone https://github.com/l3toII/claude-flow.git ~/.claude/plugins/claude-flow
```

## Quick Start

```bash
/init                    # Initialize project
/story "User login"      # Create story
/work #42                # Start working
/done                    # Complete (commit + PR)
/status                  # Check status
```

## Commands

| Command | Description |
|---------|-------------|
| `/init` | Initialize project with full workflow |
| `/onboard` | Onboard existing project (cleanup + structure) |
| `/story` | Create a new story (US/TS/UX) |
| `/sprint` | Manage sprints (plan/start/lock/close) |
| `/work #XX` | Start working on a ticket |
| `/done` | Complete work (commit + PR + update) |
| `/commit` | Create conventional commit |
| `/pr` | Create or review pull requests |
| `/release` | Create release with changelog |
| `/env` | Manage environments |
| `/status` | Show project status |
| `/dashboard` | Visual project overview |
| `/apps` | Manage apps in monorepo |
| `/sync` | Verify code ↔ docs sync |
| `/debt` | Manage technical debt |
| `/decision` | Track architectural decisions |
| `/ux` | Manage UX artifacts |
| `/bye` | End session gracefully |

## Anti-Vibe-Code Guards

Automatic guards prevent workflow violations:

- **Story Guard**: Blocks code in `apps/` without ticket branch
- **Merge Guard**: Prevents merging `poc/*` and `vibe/*` branches
- **Sprint Lock**: Only fixes allowed during sprint lock
- **Root Whitelist**: Blocks commits if forbidden files at root
- **Secret Warning**: Warns about potential secrets in code

## Branch Strategy (Adaptive)

Plugin adapts to your repo conventions. Default pattern:

| Type | Pattern | Mergeable | Ticket |
|------|---------|-----------|--------|
| Feature | `feature/#XX-desc` | ✅ | ✅ |
| Fix | `fix/#XX-desc` | ✅ | ✅ |
| Technical | `tech/#XX-desc` | ✅ | ✅ |
| POC | `poc/desc` | ❌ | ❌ |
| Vibe | `vibe/desc` | ❌ | ❌ |

## Project Structure

After `/init` or `/onboard`:

```
project/
├── apps/
│   ├── devops/              # Docker, env, scripts
│   │   ├── docker/
│   │   ├── env/
│   │   └── scripts/
│   ├── config/              # Shared configs (optional)
│   │   ├── typescript/
│   │   ├── eslint/
│   │   └── prettier.json
│   └── [app-name]/          # Application code
│       ├── src/
│       ├── package.json
│       ├── tsconfig.json    # Can extend ../config/typescript/
│       └── .eslintrc.cjs    # Can extend ../config/eslint/
├── project/                 # Project management
│   ├── vision.md
│   ├── personas.md
│   ├── ux.md
│   ├── roadmap.md
│   ├── backlog/
│   │   ├── functional/      # US-XXX
│   │   ├── technical/       # TS-XXX
│   │   └── ux/              # UX-XXX
│   └── sprints/
├── engineering/             # Technical documentation
│   ├── stack.md
│   ├── architecture.md
│   ├── conventions.md
│   └── decisions/           # ADRs
├── docs/                    # Public documentation
│   ├── api/
│   └── archive/
├── .claude/
│   ├── session.json
│   ├── environments.json
│   └── repos.json
├── CLAUDE.md
├── README.md
├── Makefile
└── package.json             # Workspace only (NO deps)
```

## Root Whitelist

Only these files allowed at root:

| Allowed | Forbidden (must move) |
|---------|----------------------|
| `apps/` | `src/`, `lib/` → `apps/[name]/` |
| `project/` | `tsconfig.json` → `apps/[name]/` |
| `engineering/` | `.eslintrc*` → `apps/[name]/` |
| `docs/` | `Dockerfile` → `apps/devops/docker/` |
| `.claude/` | `.env*` → `apps/devops/env/` |
| `CLAUDE.md`, `README.md` | `node_modules/` → DELETE |
| `Makefile`, `package.json` | `*.lock` → DELETE |

## Requirements

- Claude Code CLI
- Git
- GitHub CLI (`gh`)

## Documentation

See `doc/` folder for detailed documentation:
- `00-FOUNDATIONS.md` - Core principles and philosophy
- `01-ARCHITECTURE.md` - Plugin architecture and structure
- `02-INTERACTIONS.md` - Complete command flows

## License

MIT
