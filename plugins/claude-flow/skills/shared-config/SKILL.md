---
name: shared-config
description: Structure and conventions for apps/config/ - shared configuration files (TypeScript, ESLint, Prettier). Use when setting up or managing shared configs across apps.
---

# Shared Config

Conventions for the `apps/config/` directory that centralizes shared configuration files.

## Directory Structure

```
apps/config/
├── typescript/
│   ├── base.json              # Common TypeScript rules
│   ├── node.json              # Node.js preset (extends base)
│   ├── react.json             # React preset (extends base)
│   ├── library.json           # Library preset (extends base)
│   └── strict.json            # Extra strict preset
├── eslint/
│   ├── base.cjs               # Common ESLint rules
│   ├── node.cjs               # Node.js preset
│   ├── react.cjs              # React preset
│   └── typescript.cjs         # TypeScript-specific rules
├── prettier.json              # Single Prettier config (shared)
├── jest.base.js               # Jest base config (optional)
├── package.json               # Optional: for npm workspace
└── README.md                  # Documentation
```

## TypeScript Configs

### apps/config/typescript/base.json

```json
{
  "$schema": "https://json.schemastore.org/tsconfig",
  "compilerOptions": {
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true
  }
}
```

### apps/config/typescript/node.json

```json
{
  "$schema": "https://json.schemastore.org/tsconfig",
  "extends": "./base.json",
  "compilerOptions": {
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "target": "ES2022",
    "lib": ["ES2022"],
    "types": ["node"]
  }
}
```

### apps/config/typescript/react.json

```json
{
  "$schema": "https://json.schemastore.org/tsconfig",
  "extends": "./base.json",
  "compilerOptions": {
    "module": "ESNext",
    "moduleResolution": "bundler",
    "target": "ES2020",
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "jsx": "react-jsx",
    "types": ["vite/client"]
  }
}
```

### apps/config/typescript/library.json

```json
{
  "$schema": "https://json.schemastore.org/tsconfig",
  "extends": "./base.json",
  "compilerOptions": {
    "module": "ESNext",
    "moduleResolution": "bundler",
    "target": "ES2020",
    "lib": ["ES2020"],
    "declaration": true,
    "declarationMap": true,
    "emitDeclarationOnly": false
  }
}
```

## ESLint Configs

### apps/config/eslint/base.cjs

```javascript
/** @type {import('eslint').Linter.Config} */
module.exports = {
  root: true,
  env: {
    es2022: true,
  },
  extends: [
    'eslint:recommended',
  ],
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
  },
  rules: {
    'no-console': 'warn',
    'no-debugger': 'error',
    'no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
    'prefer-const': 'error',
    'eqeqeq': ['error', 'always'],
  },
};
```

### apps/config/eslint/node.cjs

```javascript
/** @type {import('eslint').Linter.Config} */
module.exports = {
  extends: [
    './base.cjs',
  ],
  env: {
    node: true,
    es2022: true,
  },
  rules: {
    'no-process-exit': 'error',
  },
};
```

### apps/config/eslint/react.cjs

```javascript
/** @type {import('eslint').Linter.Config} */
module.exports = {
  extends: [
    './base.cjs',
    'plugin:react/recommended',
    'plugin:react-hooks/recommended',
    'plugin:jsx-a11y/recommended',
  ],
  env: {
    browser: true,
    es2022: true,
  },
  settings: {
    react: {
      version: 'detect',
    },
  },
  rules: {
    'react/react-in-jsx-scope': 'off',
    'react/prop-types': 'off',
  },
};
```

### apps/config/eslint/typescript.cjs

```javascript
/** @type {import('eslint').Linter.Config} */
module.exports = {
  extends: [
    'plugin:@typescript-eslint/recommended',
    'plugin:@typescript-eslint/recommended-requiring-type-checking',
  ],
  parser: '@typescript-eslint/parser',
  plugins: ['@typescript-eslint'],
  rules: {
    '@typescript-eslint/no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
    '@typescript-eslint/explicit-function-return-type': 'off',
    '@typescript-eslint/explicit-module-boundary-types': 'off',
    '@typescript-eslint/no-explicit-any': 'warn',
  },
};
```

## Prettier Config

### apps/config/prettier.json

```json
{
  "$schema": "https://json.schemastore.org/prettierrc",
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 100,
  "bracketSpacing": true,
  "arrowParens": "avoid",
  "endOfLine": "lf"
}
```

## Usage in Apps

### Backend App (apps/api/)

**apps/api/tsconfig.json**:
```json
{
  "extends": "../config/typescript/node.json",
  "compilerOptions": {
    "outDir": "./dist",
    "rootDir": "./src"
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

**apps/api/.eslintrc.cjs**:
```javascript
/** @type {import('eslint').Linter.Config} */
module.exports = {
  extends: [
    '../config/eslint/node.cjs',
    '../config/eslint/typescript.cjs',
  ],
  parserOptions: {
    project: './tsconfig.json',
    tsconfigRootDir: __dirname,
  },
  ignorePatterns: ['dist/', 'node_modules/'],
};
```

**apps/api/.prettierrc**:
```json
"../config/prettier.json"
```

Or symlink:
```bash
ln -s ../config/prettier.json .prettierrc
```

### Frontend App (apps/web/)

**apps/web/tsconfig.json**:
```json
{
  "extends": "../config/typescript/react.json",
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["src/**/*", "vite.config.ts"],
  "exclude": ["node_modules", "dist"]
}
```

**apps/web/.eslintrc.cjs**:
```javascript
/** @type {import('eslint').Linter.Config} */
module.exports = {
  extends: [
    '../config/eslint/react.cjs',
    '../config/eslint/typescript.cjs',
  ],
  parserOptions: {
    project: './tsconfig.json',
    tsconfigRootDir: __dirname,
  },
  ignorePatterns: ['dist/', 'node_modules/'],
};
```

## apps/config/package.json (Optional)

If using npm workspaces:

```json
{
  "name": "@project/config",
  "version": "1.0.0",
  "private": true,
  "description": "Shared configuration files",
  "exports": {
    "./typescript/*": "./typescript/*.json",
    "./eslint/*": "./eslint/*.cjs",
    "./prettier": "./prettier.json"
  },
  "files": [
    "typescript/",
    "eslint/",
    "prettier.json"
  ]
}
```

## apps/config/README.md

```markdown
# Shared Config

Centralized configuration files for all apps.

## Usage

### TypeScript

\`\`\`json
{
  "extends": "../config/typescript/node.json"
}
\`\`\`

Available presets:
- `base.json` - Common rules
- `node.json` - Node.js apps
- `react.json` - React apps
- `library.json` - Shared libraries

### ESLint

\`\`\`javascript
module.exports = {
  extends: ['../config/eslint/node.cjs']
};
\`\`\`

Available presets:
- `base.cjs` - Common rules
- `node.cjs` - Node.js apps
- `react.cjs` - React apps
- `typescript.cjs` - TypeScript rules (combine with others)

### Prettier

\`\`\`json
"../config/prettier.json"
\`\`\`

Or create symlink:
\`\`\`bash
ln -s ../config/prettier.json .prettierrc
\`\`\`

## Modifying Configs

1. Edit the base config in `apps/config/`
2. All apps automatically get the changes
3. Apps can override specific rules in their own config
```

## Best Practices

1. **Base + Presets pattern**
   - `base.json` has common rules
   - Presets extend base for specific environments

2. **Apps override, don't duplicate**
   - Apps extend presets
   - Only add app-specific overrides

3. **Single Prettier config**
   - Formatting should be consistent
   - No per-app Prettier variations

4. **Document presets**
   - README explains which preset to use
   - Examples for common setups

5. **Version control**
   - Config changes affect all apps
   - Review carefully before changing base

## Migration from Duplicate Configs

```bash
# 1. Create apps/config structure
mkdir -p apps/config/typescript apps/config/eslint

# 2. Extract common rules to base
# Compare existing configs, find common parts

# 3. Create presets for each environment
# node.json, react.json, etc.

# 4. Update each app to extend preset
# Replace full config with extends

# 5. Remove duplicate rules from apps
# Keep only app-specific overrides
```
