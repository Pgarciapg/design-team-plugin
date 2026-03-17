---
name: mobile-polish
description: Use when generating UI components, page layouts, or reviewing responsive design to ensure balanced mobile/tablet/desktop behavior.
---

Ensure **balanced responsive design** across all screen sizes when producing UI specs.

## Breakpoint Strategy (Tailwind)
- `sm:` (640px+) — Single → two-column transition
- `md:` (768px+) — Tablet, side-by-side content
- `lg:` (1024px+) — Full multi-column, expanded nav
- `xl:` (1280px+) — Wide desktop, max-width containers

## Non-Obvious Rules
- Collapse to hamburger only below `md:` — keep expanded nav visible on tablet+
- Touch targets: 44x44 on mobile, standard on desktop — don't bloat desktop buttons
- Don't force `max-w-sm` on desktop cards — let them breathe with the layout
- Use `gap-*` over manual margin for grid/flex — handles responsive spacing better

## Key Principle
**Don't sacrifice desktop aesthetics for mobile optimization.** A great experience on ALL devices, not just mobile.

## Gotchas
- **Tailwind is mobile-first (`min-width`)** — if you write `hidden sm:block`, it's hidden on mobile, shown on 640px+. Don't confuse with `max-width` media queries.
- **`transition: all` kills performance** — always specify properties: `transition-colors`, `transition-transform`.
- **Forgetting `safe-area-inset`** on iOS — bottom nav bars get covered by the home indicator. Use `pb-safe` or `env(safe-area-inset-bottom)`.
- **Testing only at exact breakpoints** — test at 375px (iPhone SE), 390px (iPhone 15), 768px (iPad), and 1440px (desktop).
- **Stacking order on mobile** — visually important content should come first in the DOM (for screen readers too). Don't rely on CSS `order` for semantic flow.
- **Images without `aspect-ratio`** cause layout shift on mobile — always set explicit dimensions or `aspect-ratio`.
