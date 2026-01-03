---
name: mobile-polish
description: Ensure all UI specs include responsive layout rules that work well across mobile, tablet, and desktop breakpoints.
---

Whenever producing UI or page specs, ensure **balanced responsive design** that works well at all screen sizes:

## Breakpoint Strategy
- Mobile: 375px–640px (single column, stacked layouts)
- Tablet: 641px–1024px (2-column grids, side-by-side content)
- Desktop: 1025px+ (full multi-column layouts, expanded navigation)

## Layout Rules
- Use fluid grids that adapt gracefully—avoid forcing mobile patterns onto desktop.
- On desktop (1025px+): utilize horizontal space with multi-column layouts, sidebars, and expanded content areas.
- On tablet: transition layouts gradually—don't collapse everything to single column prematurely.
- On mobile: single column with appropriate stacking.

## Touch & Interaction
- Minimum touch target 44x44 on mobile.
- On desktop: standard clickable areas (no need to bloat buttons for touch).
- Navigation: collapse to hamburger only below 768px; keep expanded nav visible on desktop/tablet.

## Typography & Spacing
- Scale typography appropriately per breakpoint—mobile text can be slightly smaller, desktop text should breathe.
- Avoid cramped line-height on any device.
- Spacing should feel generous on desktop; tighter but not cramped on mobile.

## Key Principle
**Don't sacrifice desktop aesthetics for mobile optimization.** The goal is a great experience on ALL devices, not just mobile.
