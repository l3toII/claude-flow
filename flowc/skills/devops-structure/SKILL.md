---
name: devops-structure
description: Structure and conventions for apps/devops/ directory. Use when setting up DevOps, Docker, or environments.
---

# DevOps Structure

Centralized DevOps configuration in `apps/devops/`.

## Directory Structure

```
apps/devops/
├── docker/
│   ├── docker-compose.yml
│   ├── docker-compose.dev.yml
│   └── docker-compose.prod.yml
├── env/
│   ├── .env.example
│   ├── .env.dev
│   └── .env (gitignored)
├── scripts/
│   ├── setup.sh
│   ├── dev.sh
│   └── deploy.sh
└── README.md
```

## Docker Compose

```yaml
services:
  api:
    build: ../../api
    env_file: ../env/.env
    ports: ["3000:3000"]

  web:
    build: ../../web
    ports: ["5173:5173"]

  db:
    image: postgres:15-alpine
    volumes: [db_data:/var/lib/postgresql/data]
```

## Environment Files

```bash
# .env.example (template)
NODE_ENV=development
DB_HOST=db
DB_PASSWORD=change-me
API_PORT=3000
```

## Scripts

```bash
# setup.sh - Initial setup
# dev.sh - Start dev environment
# deploy.sh - Deploy to environment
```

## Best Practices

1. Never commit secrets
2. Volume for persistent data
3. Multi-stage Docker builds
4. Separate dev/prod configs
