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
│   └── library.json           # Library preset (extends base)
├── eslint/
│   ├── base.cjs               # Common ESLint rules
│   ├── node.cjs               # Node.js preset
│   ├── react.cjs              # React preset
│   └── typescript.cjs         # TypeScript-specific rules
├── prettier.json              # Single Prettier config (shared)
└── README.md                  # Documentation
```

## TypeScript Configs

### base.json

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
    "noFallthroughCasesInSwitch": true
  }
}
```

### node.json

```json
{
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

### react.json

```json
{
  "extends": "./base.json",
  "compilerOptions": {
    "module": "ESNext",
    "moduleResolution": "bundler",
    "target": "ES2020",
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "jsx": "react-jsx"
  }
}
```

## ESLint Configs

### base.cjs

```javascript
module.exports = {
  root: true,
  env: { es2022: true },
  extends: ['eslint:recommended'],
  rules: {
    'no-console': 'warn',
    'no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
    'prefer-const': 'error',
  },
};
```

### node.cjs

```javascript
module.exports = {
  extends: ['./base.cjs'],
  env: { node: true, es2022: true },
};
```

### react.cjs

```javascript
module.exports = {
  extends: [
    './base.cjs',
    'plugin:react/recommended',
    'plugin:react-hooks/recommended',
  ],
  env: { browser: true, es2022: true },
  settings: { react: { version: 'detect' } },
  rules: {
    'react/react-in-jsx-scope': 'off',
    'react/prop-types': 'off',
  },
};
```

### typescript.cjs

```javascript
module.exports = {
  extends: ['plugin:@typescript-eslint/recommended'],
  parser: '@typescript-eslint/parser',
  plugins: ['@typescript-eslint'],
  rules: {
    '@typescript-eslint/no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
    '@typescript-eslint/no-explicit-any': 'warn',
  },
};
```

## Prettier Config

### prettier.json

```json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 100
}
```

## Usage in Apps

### Backend (apps/api/tsconfig.json)

```json
{
  "extends": "../config/typescript/node.json",
  "compilerOptions": {
    "outDir": "./dist",
    "rootDir": "./src"
  },
  "include": ["src/**/*"]
}
```

### Frontend (apps/web/tsconfig.json)

```json
{
  "extends": "../config/typescript/react.json",
  "compilerOptions": {
    "baseUrl": ".",
    "paths": { "@/*": ["./src/*"] }
  },
  "include": ["src/**/*"]
}
```

### ESLint (apps/api/.eslintrc.cjs)

```javascript
module.exports = {
  extends: [
    '../config/eslint/node.cjs',
    '../config/eslint/typescript.cjs',
  ],
  parserOptions: {
    project: './tsconfig.json',
    tsconfigRootDir: __dirname,
  },
};
```

### Prettier

```bash
# Symlink or reference
ln -s ../config/prettier.json .prettierrc
```

## Best Practices

1. **Base + Presets pattern** - Common rules in base, environment-specific in presets
2. **Apps extend, don't duplicate** - Only add app-specific overrides
3. **Single Prettier config** - Formatting should be consistent
4. **Document presets** - README explains which preset to use
