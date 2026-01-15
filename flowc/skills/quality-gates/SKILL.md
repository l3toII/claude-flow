---
name: quality-gates
description: Quality gate configuration and enforcement. Use when setting up or checking quality requirements.
---

# Quality Gates

Per-app quality requirements enforced by `/done`.

## Configuration

`.claude/quality.json`:

```json
{
  "coverage": {
    "minimum": 80,
    "enforce": true
  },
  "lint": {
    "warnings_allowed": 0,
    "command": "npm run lint"
  },
  "tests": {
    "required": true,
    "command": "npm test"
  },
  "security": {
    "block_secrets": true,
    "scan_command": "npm run security"
  },
  "build": {
    "required": true,
    "command": "npm run build"
  }
}
```

## Gates

### Coverage
- Minimum percentage required
- Enforce: block PR if below

### Lint
- Max warnings allowed
- Zero tolerance recommended

### Tests
- Must pass before PR
- Required for completion

### Security
- Block if secrets detected
- Run security scanner

### Build
- Must compile successfully
- No build errors

## Enforcement

`/done` runs all gates:
1. Run tests
2. Check coverage
3. Run linter
4. Security scan
5. Build check

All must pass to create PR.

## Per-App Configuration

Each app can have different thresholds:
- `api`: 90% coverage
- `web`: 70% coverage
- `scripts`: no coverage required
