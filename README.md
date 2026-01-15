# claude-plugins

Collection de plugins pour Claude Code.

## Plugins

| Plugin | Description | Version |
|--------|-------------|---------|
| [flowc](apps/flowc/) | Workflow de développement complet | 0.1.0 |

## Installation

```bash
# Installer flowc
/plugin install l3toII/claude-plugins/apps/flowc
```

## Structure

```
claude-plugins/
├── apps/
│   └── flowc/              # Plugin workflow (git indépendant)
├── project/
│   ├── backlog/            # Stories
│   └── sprints/            # Sprints
├── engineering/
│   └── apps/               # Documentation technique par app
├── docs/
│   └── GUIDE.md            # Guide complet flowc
└── .claude/
    ├── flowc.json          # Configuration projet
    └── session.json        # État de session
```

## Documentation

- [Guide Complet flowc](docs/GUIDE.md)
- [Architecture flowc](engineering/apps/flowc.md)

## Développement

Ce repo utilise flowc pour se développer lui-même (dogfooding).

```bash
# Status actuel
Sprint: sprint-00 (Bootstrap)
Story active: S-001 (Restructuration monorepo)
```

## License

MIT
