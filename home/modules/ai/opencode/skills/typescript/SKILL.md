---
name: typescript
description: TypeScript strict mode (all flags), advanced type patterns (branded types, template literals, discriminated unions), runtime validation (Zod), and production tsconfig
license: MIT
compatibility: opencode
metadata:
  language: typescript
  audience: developers
---

## Configuration

```jsonc
// tsconfig.json — production minimum
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,    // arr[i] is T | undefined
    "exactOptionalPropertyTypes": true,  // ? is exactly undefined, not absent
    "noImplicitReturns": true,
    "esModuleInterop": true,
    "moduleResolution": "bundler",
    "isolatedModules": true
  }
}
```

- `strict: true` enables: `noImplicitAny`, `strictNullChecks`, `strictFunctionTypes`, `strictBindCallApply`, `strictPropertyInitialization`, `noImplicitThis`, `alwaysStrict`, `useUnknownInCatchVariables`
- Run `npx tsc --noEmit` for type checking (separate from build — never skip)
- `isolatedModules` + `verbatimModuleSyntax` for safe transpilation

## Types

- `interface` for object shapes (extensible, declaration merging) — `type` for unions (`A | B`), intersections (`A & B`), mapped types
- `import type { T }` and `export type { T }` — erased at compile time, prevents runtime imports
- `unknown` over `any` — narrow with type guards (`typeof`, `instanceof`, discriminated unions, user-defined type predicates)
- `as const` for literal type inference — `const config = { role: 'admin' } as const` infers `role: 'admin'` not `string`
- `satisfies` operator: `const x = { a: 1 } satisfies Record<string, number>` — validates without widening
- Generic constraints: `function getProp<T, K extends keyof T>(obj: T, key: K): T[K]`
- Branded types: `type UserId = string & { readonly __brand: unique symbol }` — prevents mixing string IDs
- Template literal types: `` type EventName = `on${'Click' | 'Hover' | 'Focus'}`; type Path = `/api/${string}``
- Discriminated unions: `type Shape = { kind: 'circle'; radius: number } | { kind: 'square'; side: number }`

## Runtime Validation

- **Zod**: `z.string().min(1).email()`, `z.object({ name: z.string() })`, `.parse()` throws or `.safeParse()` returns result
- **Valibot**: modular alternative to Zod (smaller bundle — tree-shakeable)
- Validate API boundaries (inputs, config files, env vars) — not internal state (already typed)

## Testing

- **Vitest** with `@vitest/coverage-v8` — `vi.fn()`, `vi.spyOn()`, `vi.mock()`
- `tsx` for running TypeScript scripts (replaces `ts-node` in new projects)
- Type testing: `expectTypeOf<typeof fn>().toEqualTypeOf<(x: number) => string>()`
- Use `@total-typescript/ts-reset` for stricter built-in types

## Frameworks

- **Next.js (App Router)**: server components by default, `"use client"` boundary, RSC, server actions (`"use server"`), streaming SSR
- **React**: functional components with hooks — `React.FC` deprecated, prefer explicit `({ prop }: Props) => JSX.Element`
- **tRPC**: end-to-end type-safe APIs — no shared schema file, inferred from server
- **Express / Fastify**: typed routes (`@types/express`), Zod for input validation, `@fastify/type-provider-typebox`
