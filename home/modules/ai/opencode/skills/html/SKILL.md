---
name: html
description: Semantic HTML5, accessibility (WCAG AA), modern APIs (Popover, Dialog), forms, SEO/OG meta, and lazy loading
license: MIT
compatibility: opencode
metadata:
  language: html
  audience: developers
---

## Semantics

- Use semantic elements: `<header>`, `<nav>`, `<main>` (exactly one), `<section>`, `<article>`, `<aside>`, `<footer>`, `<search>`
- One `<h1>` per page, logical hierarchy (`h1`→`h2`→`h3`), never skip levels
- `<ul>`/`<ol>` for lists, `<dl>`/`<dt>`/`<dd>` for definition lists
- `<table>` for tabular data only (not layout), with `<thead>`, `<tbody>`, `<th scope="col/row">`
- `<figure>`/`<figcaption>` for self-contained media with caption
- Fall back to `<div>`/`<span>` only when no semantic element fits — never for layout structure

## Accessibility (WCAG AA)

- `alt` on all `<img>` (explanatory for content images, `alt=""` for decorative) — never omit
- `<label for="id">` or wrapping `<label>` for every form input
- `aria-label`, `aria-labelledby`, `aria-describedby` where native semantics are insufficient
- Focusable elements must have visible focus indicators — never `outline: none` without replacement
- `aria-live="polite"` / `aria-live="assertive"` for dynamic content regions
- Landmarks: exactly one `<main>`, use `aria-label` on multiple `<nav>` to distinguish
- Skip-to-content link as first focusable element
- Test with keyboard only (Tab, Enter, Space, Escape) and a screen reader (NVDA/VoiceOver)

## Modern APIs

- `<dialog>` for modals — `.showModal()` for blocking dialogs, `.show()` for non-modal overlays
- Popover API: `popover="auto"`/`popover="manual"` + `popovertarget` for tooltips, menus, and flyouts without JS
- `<details>`/`<summary>` for native disclosure widgets (accordions)
- `<datalist>` for input suggestions, `<output>` for form result display
- `<template>` for declarative shadow DOM: `<template shadowrootmode="open">`
- `<input type="checkbox" switch>` for native toggle switches (experimental, browser-dependent)

## Forms

- Proper `type` attributes: `email`, `tel`, `url`, `number`, `date`, `datetime-local`, `color`, `range`
- Validation: `required`, `minlength`, `maxlength`, `min`, `max`, `step`, `pattern`
- `autocomplete` for user convenience: `given-name`, `family-name`, `email`, `current-password`, `one-time-code`
- `<fieldset>`/`<legend>` for grouped radio buttons and checkboxes
- Accessible error messages: `aria-describedby` linking input to error element

## Performance & Meta

- `<meta charset="UTF-8">` and `<meta name="viewport" content="width=device-width, initial-scale=1.0">` — required in `<head>`
- `<title>` per page: unique, descriptive, under 60 chars
- Open Graph: `og:title`, `og:description`, `og:image`, `og:url` — required for social sharing
- `<link rel="canonical" href="...">` — prevent duplicate content issues
- Lazy loading: `<img loading="lazy">`, `<iframe loading="lazy">` — never eager load below-fold media
- `<link rel="preload">` / `<link rel="preconnect">` for critical resources
- `<script defer>` or `<script type="module">` — never render-blocking scripts in `<head>`
