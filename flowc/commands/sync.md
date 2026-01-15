---
description: Verify synchronization between code and documentation. Detect vibe code and outdated docs.
argument-hint: [--fix]
---

# /sync - Sync Verification

Verify code and documentation are in sync.

## Usage

```
/sync                # Check sync status
/sync --fix          # Auto-fix issues
```

## Checks

### 1. Vibe Code Detection
Find code without proper documentation:
- Functions without comments
- Complex logic unexplained
- Missing README in modules

### 2. Outdated Docs
Find docs that don't match code:
- API docs vs implementation
- README vs actual structure
- Comments vs behavior

### 3. Missing Tests
Find code without test coverage:
- New functions without tests
- Changed code with stale tests

### 4. Status Mismatch
Find stories with wrong status:
- "Done" but PR not merged
- "In Progress" but no commits

## Output

```
=== Sync Report ===

✅ Code/Docs: 95% synced
⚠️  Vibe Code: 3 files detected
❌ Outdated: 2 docs need update
✅ Tests: Coverage at 82%

Issues:
1. src/auth/oauth.ts - Missing JSDoc
2. docs/API.md - Outdated endpoints
3. README.md - Wrong install command
```

## Auto-Fix (--fix)

- Generate missing JSDoc
- Update simple doc mismatches
- Flag complex issues for manual review
