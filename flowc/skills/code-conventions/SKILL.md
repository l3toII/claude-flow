---
name: code-conventions
description: Code style and conventions for consistent, maintainable code. Use when writing code, reviewing, or setting up projects.
---

# Code Conventions

Standards for consistent, maintainable code.

## General Principles

1. **Clarity over cleverness**
2. **Consistency** - Follow existing patterns
3. **Minimal dependencies**
4. **Test coverage** - 80% minimum
5. **No warnings** - Lint must pass clean

## Naming

### Files
```
UserProfile.tsx      # Components (PascalCase)
formatDate.ts        # Utilities (camelCase)
API_ENDPOINTS.ts     # Constants (SCREAMING_SNAKE)
UserProfile.test.tsx # Tests (same + .test)
```

### Variables
```typescript
const isLoading = true;      // Boolean: is/has/can
const users = [];            // Arrays: plural
function getUser() {}        // Functions: verb prefix
const MAX_RETRIES = 3;       // Constants: UPPER_SNAKE
```

## TypeScript

```typescript
// Interfaces for objects
interface User {
  id: string;
  name: string;
}

// Types for unions
type Status = 'pending' | 'active' | 'done';

// Explicit return types
function getUser(id: string): Promise<User> {}
```

## Imports Order

```typescript
// 1. External libraries
import { useState } from 'react';

// 2. Internal modules (absolute)
import { UserService } from '@/services/user';

// 3. Relative imports
import { formatName } from './utils';
```

## Comments

```typescript
// Single line for simple explanations

/**
 * Multi-line for complex logic.
 * Explain WHY, not WHAT.
 */

// TODO(#ticket): What needs to be done
// Never commit: console.log, debugger
```
