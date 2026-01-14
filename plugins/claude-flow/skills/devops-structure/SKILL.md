---
name: devops-structure
description: Structure and conventions for apps/devops/ directory. Use when setting up DevOps, Docker, or environment configuration.
---

# DevOps Structure

Conventions for the `apps/devops/` directory that centralizes all DevOps configuration.

## Directory Structure

```
apps/devops/
├── docker/
│   ├── docker-compose.yml      # Main orchestration
│   ├── docker-compose.dev.yml  # Dev overrides
│   ├── docker-compose.prod.yml # Prod overrides
│   └── Dockerfile.base         # Shared base image (optional)
├── env/
│   ├── .env.example            # Template (committed)
│   ├── .env                    # Local values (gitignored)
│   ├── .env.dev                # Dev defaults (no secrets)
│   └── .env.prod.example       # Prod template (no secrets)
├── scripts/
│   ├── setup.sh                # Initial project setup
│   ├── dev.sh                  # Start dev environment
│   ├── deploy.sh               # Deploy to environment
│   ├── backup.sh               # Database backup
│   └── restore.sh              # Database restore
├── infra/                      # Optional: IaC
│   ├── terraform/
│   └── k8s/
├── package.json                # Node.js tooling (optional)
└── README.md                   # DevOps documentation
```

## Docker Compose

### Main Compose File

```yaml
# apps/devops/docker/docker-compose.yml
version: '3.8'

services:
  api:
    build:
      context: ../../api
      dockerfile: Dockerfile
    env_file:
      - ../env/.env
    ports:
      - "${API_PORT:-3000}:3000"
    volumes:
      - ../../api:/app
      - /app/node_modules
    depends_on:
      - db
      - redis

  web:
    build:
      context: ../../web
      dockerfile: Dockerfile
    env_file:
      - ../env/.env
    ports:
      - "${WEB_PORT:-5173}:5173"
    volumes:
      - ../../web:/app
      - /app/node_modules

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: ${DB_USER:-app}
      POSTGRES_PASSWORD: ${DB_PASSWORD:-secret}
      POSTGRES_DB: ${DB_NAME:-app}
    ports:
      - "${DB_PORT:-5432}:5432"
    volumes:
      - db_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "${REDIS_PORT:-6379}:6379"

volumes:
  db_data:
```

### Dev Overrides

```yaml
# apps/devops/docker/docker-compose.dev.yml
version: '3.8'

services:
  api:
    command: npm run dev
    environment:
      - NODE_ENV=development
      - DEBUG=app:*

  web:
    command: npm run dev
    environment:
      - NODE_ENV=development
```

### Prod Overrides

```yaml
# apps/devops/docker/docker-compose.prod.yml
version: '3.8'

services:
  api:
    command: npm start
    environment:
      - NODE_ENV=production
    restart: always

  web:
    build:
      target: production
    restart: always
```

## Environment Files

### Template (.env.example)

```bash
# apps/devops/env/.env.example
# Copy to .env and fill in values

# Application
NODE_ENV=development
LOG_LEVEL=debug

# Database
DB_HOST=db
DB_PORT=5432
DB_USER=app
DB_PASSWORD=change-me
DB_NAME=app
DATABASE_URL=postgres://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}

# Redis
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_URL=redis://${REDIS_HOST}:${REDIS_PORT}

# API
API_PORT=3000
API_SECRET=change-me-in-production
JWT_SECRET=change-me-in-production

# Web
WEB_PORT=5173
VITE_API_URL=http://localhost:3000

# External Services (add as needed)
# STRIPE_KEY=
# SENDGRID_KEY=
```

### Dev Defaults (.env.dev)

```bash
# apps/devops/env/.env.dev
# Safe defaults for development (no secrets)

NODE_ENV=development
LOG_LEVEL=debug

DB_HOST=db
DB_PORT=5432
DB_USER=app
DB_NAME=app

REDIS_HOST=redis
REDIS_PORT=6379

API_PORT=3000
WEB_PORT=5173

VITE_API_URL=http://localhost:3000
```

## Scripts

### Setup Script

```bash
#!/bin/bash
# apps/devops/scripts/setup.sh

set -e

echo "🚀 Setting up project..."

# Create .env if not exists
if [ ! -f apps/devops/env/.env ]; then
  cp apps/devops/env/.env.example apps/devops/env/.env
  echo "✅ Created .env file - please fill in values"
fi

# Install dependencies for all apps
for dir in apps/*/; do
  if [ -f "$dir/package.json" ] && [ "$dir" != "apps/devops/" ]; then
    echo "📦 Installing dependencies in $dir..."
    (cd "$dir" && npm install)
  fi
done

# Build Docker images
echo "🐳 Building Docker images..."
cd apps/devops/docker
docker-compose build

echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Edit apps/devops/env/.env with your values"
echo "  2. Run 'make up' to start services"
```

### Dev Script

```bash
#!/bin/bash
# apps/devops/scripts/dev.sh

set -e

cd apps/devops/docker

# Start with dev overrides
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

echo "✅ Development environment started"
echo ""
echo "Services:"
echo "  - API: http://localhost:3000"
echo "  - Web: http://localhost:5173"
echo ""
echo "Use 'make logs' to view logs"
```

### Deploy Script

```bash
#!/bin/bash
# apps/devops/scripts/deploy.sh

set -e

APP=${1:-all}
ENV=${2:-staging}

echo "🚀 Deploying $APP to $ENV..."

case $ENV in
  staging)
    # Deploy to staging
    if [ "$APP" = "api" ] || [ "$APP" = "all" ]; then
      railway up -s api-staging
    fi
    if [ "$APP" = "web" ] || [ "$APP" = "all" ]; then
      vercel --env staging
    fi
    ;;
  production)
    echo "⚠️  Production deployment requires confirmation"
    read -p "Type 'deploy $APP production' to confirm: " confirm
    if [ "$confirm" = "deploy $APP production" ]; then
      # Deploy to production
      railway up -s api-production
    else
      echo "❌ Deployment cancelled"
      exit 1
    fi
    ;;
esac

echo "✅ Deployment complete"
```

## Root Makefile Integration

```makefile
# Root Makefile

.PHONY: help setup up down logs build test

help:
	@echo "Available commands:"
	@echo "  make setup    - Initial project setup"
	@echo "  make up       - Start all services"
	@echo "  make down     - Stop all services"
	@echo "  make logs     - View logs (app=name for specific)"

setup:
	chmod +x apps/devops/scripts/*.sh
	./apps/devops/scripts/setup.sh

up:
	cd apps/devops/docker && docker-compose up -d

up-dev:
	cd apps/devops/docker && docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

down:
	cd apps/devops/docker && docker-compose down

logs:
ifdef app
	cd apps/devops/docker && docker-compose logs -f $(app)
else
	cd apps/devops/docker && docker-compose logs -f
endif

deploy:
	./apps/devops/scripts/deploy.sh $(app) $(env)
```

## Per-App Dockerfile

Each app should have its own Dockerfile:

```dockerfile
# apps/api/Dockerfile
FROM node:20-alpine AS base
WORKDIR /app

# Dependencies
FROM base AS deps
COPY package*.json ./
RUN npm ci

# Development
FROM base AS development
COPY --from=deps /app/node_modules ./node_modules
COPY . .
CMD ["npm", "run", "dev"]

# Build
FROM base AS build
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# Production
FROM base AS production
COPY --from=deps /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
CMD ["npm", "start"]
```

## Naming Conventions

| Item | Convention | Example |
|------|------------|---------|
| Docker services | lowercase app name | `api`, `web`, `db` |
| Environment vars | UPPER_SNAKE_CASE | `DATABASE_URL`, `API_PORT` |
| Scripts | lowercase-kebab | `setup.sh`, `deploy.sh` |
| Compose files | docker-compose.{env}.yml | `docker-compose.dev.yml` |

## Best Practices

1. **Never commit secrets** - Use .env.example as template
2. **Volume for data** - Persist database data across restarts
3. **Health checks** - Add healthcheck to services
4. **Named volumes** - Easier to manage than bind mounts for data
5. **Multi-stage builds** - Keep production images small
6. **Dev overrides** - Separate dev config from production
7. **Scripts for automation** - Document all commands as scripts
