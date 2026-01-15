---
description: Manage environments - status, deploy, logs, rollback. Supports Vercel, Railway, Fly.io.
argument-hint: [action] [app] [environment]
---

# /env - Environment Management

Manage deployment environments.

## Usage

```
/env                         # Show all environments
/env status api staging      # Check specific env
/env deploy api staging      # Deploy to env
/env logs api production     # View logs
/env rollback api staging    # Rollback deployment
```

## Actions

### /env (status all)
Overview of all environments.

### /env status
Check specific environment:
- Deployment status
- Current version
- Health check

### /env deploy
Deploy to environment:
- Build app
- Push to platform
- Run health checks

### /env logs
Stream logs from environment.

### /env rollback
Rollback to previous deployment.

## Supported Platforms

| Platform | Apps | Config |
|----------|------|--------|
| Vercel | Frontend | vercel.json |
| Railway | Backend | railway.json |
| Fly.io | Any | fly.toml |

## Environment Config

`.claude/environments.json`:

```json
{
  "apps": {
    "api": {
      "platform": "railway",
      "environments": {
        "staging": { "service": "api-staging" },
        "production": { "service": "api-prod" }
      }
    },
    "web": {
      "platform": "vercel",
      "environments": {
        "staging": { "project": "web-staging" },
        "production": { "project": "web-prod" }
      }
    }
  }
}
```

## Safety

- Production deploy requires confirmation
- Auto-rollback on failed health check
- Deployment audit log
