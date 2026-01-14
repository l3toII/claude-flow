---
description: Manage environments - status, deploy, logs, rollback. Uses apps/devops/ configuration.
argument-hint: [action] [app] [environment]
allowed-tools: Read, Write, Glob, Bash(docker:*), Bash(docker-compose:*), Bash(vercel:*), Bash(railway:*), Bash(fly:*), Bash(curl:*)
---

# /env - Environment Management

Manage deployment environments using `apps/devops/` configuration.

## Usage

```
/env                          # Show all environments status
/env status                   # Same as above
/env deploy api staging       # Deploy api to staging
/env deploy api production    # Deploy to production (requires confirmation)
/env logs api staging         # View logs
/env rollback api staging     # Rollback to previous version
/env local                    # Start local dev environment
/env local down               # Stop local dev environment
```

---

## /env local - Local Development

Uses `apps/devops/docker/docker-compose.yml`:

```bash
# Start all services
cd apps/devops/docker && docker-compose up -d

# Start specific service
cd apps/devops/docker && docker-compose up -d api

# Stop all
cd apps/devops/docker && docker-compose down

# View logs
cd apps/devops/docker && docker-compose logs -f
```

**Or use Makefile shortcuts:**
```bash
make up        # Start all
make down      # Stop all
make logs      # View logs
make logs app=api  # Specific app logs
```

---

## /env status

Display status for all apps and environments:

```
📊 Environment Status

LOCAL (apps/devops/docker)
├── api:  running ✅ (localhost:3000)
├── web:  running ✅ (localhost:5173)
└── db:   running ✅ (localhost:5432)

API (Railway)
├── staging:    v1.3.0 ✅ (deployed 2h ago)
├── production: v1.2.0 ✅ (deployed 3d ago)
└── health: all checks passing

WEB (Vercel)
├── staging:    v2.1.0 ✅
├── production: v2.0.0 ✅
└── health: all checks passing
```

---

## /env deploy [app] [env]

### Staging Deploy

```bash
# Automatic, no confirmation needed
railway up -s api-staging
# or
vercel --env staging
# or
fly deploy --app api-staging
```

### Production Deploy

**Requires double confirmation:**

```
⚠️ PRODUCTION DEPLOY

App: api
Version: v1.3.0
Environment: production

Checks:
✅ Tests passing
✅ Staging tested
✅ All stories Done
⚠️ 2 hours since last staging deploy

Type "deploy production api" to confirm:
```

```bash
railway up -s api-production
```

---

## /env logs [app] [env]

### Local Logs

```bash
# Via apps/devops
cd apps/devops/docker && docker-compose logs -f api
```

### Remote Logs

```bash
# Railway
railway logs -s api-staging

# Vercel
vercel logs api-staging

# Fly.io
fly logs --app api-staging
```

Display last 100 lines, highlight errors.

---

## /env rollback [app] [env]

### 1. Show History

```
Recent deploys:
1. v1.3.0 (current) - 2h ago
2. v1.2.0 - 3d ago
3. v1.1.0 - 1w ago
```

### 2. Confirm Rollback

```
Rollback api staging to v1.2.0?
```

### 3. Execute

```bash
railway rollback -s api-staging
```

### 4. Log

Save to `apps/devops/deploy-history.json`

---

## Configuration

### apps/devops/env/.env.example

```bash
# Local development
NODE_ENV=development
DATABASE_URL=postgres://user:pass@db:5432/app
REDIS_URL=redis://redis:6379

# API
API_PORT=3000
API_SECRET=change-me

# Web
VITE_API_URL=http://localhost:3000
```

### .claude/environments.json

```json
{
  "apps": {
    "api": {
      "platform": "railway",
      "local": {
        "service": "api",
        "port": 3000,
        "compose_file": "apps/devops/docker/docker-compose.yml"
      },
      "staging": {
        "service": "api-staging",
        "auto_deploy": true
      },
      "production": {
        "service": "api-production",
        "protected": true
      }
    },
    "web": {
      "platform": "vercel",
      "local": {
        "service": "web",
        "port": 5173,
        "compose_file": "apps/devops/docker/docker-compose.yml"
      },
      "staging": {
        "project": "web-staging",
        "auto_deploy": true
      },
      "production": {
        "project": "web-production",
        "protected": true
      }
    }
  }
}
```

---

## apps/devops/ Integration

| Environment | Managed By |
|-------------|-----------|
| Local | `apps/devops/docker/docker-compose.yml` |
| Staging | Platform CLI (Railway, Vercel, Fly.io) |
| Production | Platform CLI with protection |

### Local Development Flow

```
make setup                    # Copy .env.example → .env, install deps
make up                       # Start docker-compose
make logs                     # Watch logs
make down                     # Stop services
```

### Deployment Flow

```
/env deploy api staging       # Deploy to staging
/env logs api staging         # Check logs
/env deploy api production    # Deploy to prod (with confirmation)
```

---

## Scripts in apps/devops/scripts/

| Script | Purpose |
|--------|---------|
| `setup.sh` | Initial project setup |
| `dev.sh` | Start dev environment |
| `deploy.sh` | Deploy to environment |
| `backup.sh` | Database backup |
| `restore.sh` | Database restore |
