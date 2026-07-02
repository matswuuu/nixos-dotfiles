---
name: css
description: Modern CSS (2026) — container queries, subgrid, cascade layers, CSS nesting, :has(), light-dark(), anchor positioning, scroll-driven animations, and view transitions
license: MIT
compatibility: opencode
metadata:
  language: css
  audience: developers
---

## Layout

- **Flexbox** for one-dimensional layouts: rows, columns, centering, distribution — `gap`, `align-items`, `justify-content`
- **CSS Grid** for two-dimensional layouts: page structure, card grids — `grid-template-columns: repeat(auto-fill, minmax(300px, 1fr))`
- **Subgrid**: `grid-template-rows: subgrid` — aligns children across parent grid tracks (e.g., card titles in a grid)
- Never use float-based layouts; never use `display: table` for layout

## Container Queries

- Replace media queries for component-level responsiveness: `container-type: inline-size` + `@container (min-width: 400px) { ... }`
- Container query units: `cqw` (1% of container width), `cqi` (1% of container inline size), `cqh` (1% of container height)
- Named containers: `container-name: card` — prevents query collisions with nested containers
- Container style queries (2026): `@container style(--variant: compact)` — respond to custom property values
- Design component-first: define breakpoints where the component's design breaks, not at viewport widths

## Cascade & Nesting

- `@layer` for explicit cascade control: `@layer base, components, utilities` — third-party CSS imports `layer()` to stay behind
- CSS nesting (2024+): `.card { & .title { ... } }` — no preprocessor needed
- `@scope` for scoped styles: `@scope (.card) { ... }` — limits selector reach without naming hacks

## Selectors

- `:has()` — parent styling based on children: `.card:has(img) { grid-template-columns: 200px 1fr }`
- `:has()` — form validation: `.field:has(input:invalid) { border-color: red }`
- `:not()`, `:is()`, `:where()` — `:where()` has zero specificity; use for resets and defaults
- `:focus-visible` over `:focus` — only shows focus ring for keyboard users, not mouse clicks

## Responsive Design

- Mobile-first: `min-width` breakpoints (480px, 768px, 1024px, 1280px)
- Fluid typography: `font-size: clamp(1rem, 0.5rem + 1.5vw, 2rem)`
- Fluid spacing: `padding: clamp(1rem, 3vw, 4rem)`
- Auto-responsive grid: `grid-template-columns: repeat(auto-fit, minmax(min(300px, 100%), 1fr))` — zero media queries
- Viewport units: `dvh` (dynamic) for full-height sections, `svh` for small viewport, `lvh` for large
- `min()`/`max()` for responsive sizing: `width: min(100%, 1200px)`

## Custom Properties & Theming

- Theme tokens on `:root`: `--color-primary`, `--spacing-md`, `--font-size-base`, `--radius-sm`
- `light-dark()`: `color: light-dark(#333, #eee)` — system color-scheme-aware theming without JS or media query
- `color-mix()` for color manipulation: `background: color-mix(in srgb, var(--color-primary) 80%, white)`
- `var(--prop, fallback)` with fallbacks — always provide a fallback for defensive CSS

## Modern Features (2026)

- **Scroll-driven animations**: `@keyframes fade { ... } .card { animation: fade linear; animation-timeline: view() }` — scroll-linked without JS
- **View transitions**: `@view-transition { navigation: auto; }` + `::view-transition-old()` / `::view-transition-new()` — SPA-like transitions on MPA
- **Anchor positioning**: `position: absolute; position-anchor: --btn; top: anchor(bottom)` — tooltips and popovers without JS
- **`@property`**: `@property --x { syntax: '<length>'; inherits: false; initial-value: 0px }` — typed custom properties for animation

## Naming

- **BEM**: `.block__element--modifier` — works at any scale
- **Utility-first (Tailwind)**: functional classes for rapid UI, purge unused
- Keep specificity low: one class per element, avoid `!important`, prefer `@layer` for override order
- Never use `#id` for styling (only for JS anchors and fragment links)
