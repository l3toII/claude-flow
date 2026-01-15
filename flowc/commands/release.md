---
description: Create a release with changelog, tag, and GitHub release. Optionally deploy to staging.
argument-hint: [app] [--dry-run]
---

# /release - Create Release

Create a versioned release.

## Usage

```
/release                 # Release all apps
/release api             # Release specific app
/release --dry-run       # Preview without executing
```

## Workflow

1. **Version Bump**
   - Detect version from commits
   - Bump package.json
   - Update CHANGELOG

2. **Changelog Generation**
   - Group commits by type
   - Generate markdown
   - Include breaking changes

3. **Git Operations**
   - Create release commit
   - Create git tag
   - Push to remote

4. **GitHub Release**
   - Create release
   - Attach changelog
   - Mark as latest

5. **Deploy (optional)**
   - Deploy to staging
   - Run smoke tests

## Version Detection

Based on commits since last tag:
- `feat:` → minor bump
- `fix:` → patch bump
- `BREAKING CHANGE:` → major bump

## Changelog Format

```markdown
# Changelog

## [1.2.0] - 2025-01-14

### Added
- OAuth login support (#42)

### Fixed
- Timeout issue in API (#43)

### Changed
- Updated dependencies
```

## Release Notes

Auto-generated for GitHub:
- Summary of changes
- Contributors
- Full changelog link
