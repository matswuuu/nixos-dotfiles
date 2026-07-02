---
name: javascript
description: Modern JavaScript (ES2025), ES modules, async patterns, Set/Iterator helpers, testing (Vitest/Jest), and tooling (ESLint flat config, Prettier, Vite)
license: MIT
compatibility: opencode
metadata:
  language: javascript
  audience: developers
---

## Module System

- ES modules (`import`/`export`) exclusively — never CommonJS (`require`/`module.exports`) in new code
- `package.json` `"type": "module"` for Node.js projects
- Barrel files (`index.js`) for re-exporting from a directory
- Dynamic `import()` for lazy loading and code splitting

## Syntax (ES2025 features)

- `const` by default, `let` only when reassigning — never `var`
- Arrow functions for callbacks, `async`/`await` over `.then()` chains
- Destructuring for objects and arrays, spread operator for copies/merges
- Optional chaining `?.`, nullish coalescing `??`, logical assignment `||=` `&&=` `??=`
- ES2025 Set operations: `set.union(other)`, `set.intersection(other)`, `set.difference(other)`, `set.isSubsetOf(other)`
- ES2025 Iterator helpers: `iter.map(fn)`, `iter.filter(fn)`, `iter.take(n)`, `iter.drop(n)`, `iter.reduce(fn, init)`
- Top-level `await` in modules — no need for IIFE wrappers
- Pipeline operator `|>` for chained transformations
- Records and Tuples (immutable data structures): `#{ a: 1, b: 2 }`, `#[1, 2, 3]`

## Testing

- **Vitest** for Vite-based projects (preferred), **Jest** for others (legacy)
- `describe`/`it`/`expect` blocks; `vi.mock` or `jest.mock` for module mocking
- Test behavior, not implementation — prefer `screen.getByRole()` over `container.querySelector()`
- `@vitest/coverage-v8` for coverage; `@testing-library/*` for DOM/component testing

## Tooling

- **ESLint** with flat config (`eslint.config.js`) — replaces `.eslintrc` (deprecated)
- **Prettier** for formatting — run as pre-commit hook with `lint-staged`
- **Vite 7** for dev servers and bundling — replaces webpack in new projects
- **Node.js**: `fs/promises` over `fs` callbacks, global `fetch` over `node-fetch`, `timers/promises` over `util.promisify(setTimeout)`
