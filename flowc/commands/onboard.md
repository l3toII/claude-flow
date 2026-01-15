---
description: Onboard an existing repository. Detects Git conventions, analyzes structure, and configures workflow settings.
argument-hint: [repo-path]
---

# /onboard - Onboard Existing Project

Migrate existing codebase to flowc structure.

## Usage

```
/onboard             # Onboard current directory
/onboard ./myrepo    # Onboard specific path
```

## Phases

### Phase 1: Scan
Analyze:
- Directory structure
- Package.json dependencies
- Git history for conventions
- Existing config files

### Phase 2: Questionnaire
Contextual questions:
- Validate detections
- App organization
- Quality targets
- Git migration strategy

### Phase 3: Migration Plan
Preview:
- Files to move
- Files to delete
- New structure
- GitHub repos to create

### Phase 4: Execution
With backup:
- Restructure directories
- Initialize git per app
- Create quality.json per app
- Create GitHub repos
- Generate documentation

### Phase 5: Report
Summary:
- Changes made
- Manual actions needed
- How to rollback
- Next steps

## Safety

- Creates backup in `.flowc-backup/`
- Requires confirmation before execution
- Can be rolled back

## Detection

Auto-detects:
- Monorepo vs single app
- Framework (Next.js, Express, etc.)
- Package manager (npm, yarn, pnpm)
- Git conventions from history
- CI/CD configuration
