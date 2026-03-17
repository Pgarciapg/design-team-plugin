---
name: vercel-design-guidelines
description: Check web interfaces against Vercel's design guidelines. Use when asked to "review my UI", "check accessibility", "audit design", "review UX", "check my site against best practices", or "apply Vercel design guidelines".
---

# Vercel Design Guidelines Audit

Review web interfaces against Vercel's design guidelines and propose fixes.

**Key rules snapshot:** See `references/key-guidelines.md` in this skill folder for the most important non-obvious rules.

For the latest guidelines, fetch from: https://vercel.com/design/guidelines

## How To Audit

1. Read the relevant source files (components, styles, HTML)
2. Check against the key guidelines in `references/key-guidelines.md`
3. Optionally fetch live guidelines for completeness
4. Report findings grouped by category with severity

## Quick Checklist (High-Impact Items)

- [ ] All interactive elements keyboard accessible
- [ ] Visible focus rings on focusable elements
- [ ] Hit targets ≥24px (44px on mobile)
- [ ] Form inputs have visible labels (not just placeholder)
- [ ] Loading states don't flicker (150ms delay + 300ms minimum)
- [ ] `prefers-reduced-motion` respected
- [ ] No `transition: all` — specify properties
- [ ] Errors explain how to fix, not just what's wrong
- [ ] APCA contrast (not just WCAG 2.x)
- [ ] No zoom disabled (`maximum-scale=1` or `user-scalable=no`)

## Output Format

```
## {Category} Issues

### {Severity}: {Guideline Name}
**File:** `path/to/file.tsx:42`
**Issue:** {Description}
**Fix:**
```tsx
{code fix}
```
```

Severity levels:
- **Critical**: Accessibility violations, broken functionality
- **Warning**: UX issues, performance concerns
- **Suggestion**: Polish, best practices

## Gotchas

- **`outline: none` without replacement** is the most common accessibility violation — always provide a visible focus indicator.
- **Placeholder-only inputs** fail accessibility audits even if they look fine visually — screen readers skip placeholders.
- **`transition: all`** causes jank on complex components — always enumerate: `transition-property: color, background-color, transform`.
- **APCA vs WCAG**: Vercel uses APCA for contrast. A WCAG-passing 4.5:1 ratio can still fail APCA for small text. Use an APCA calculator.
- **Loading spinners appearing instantly** feel jarring — add a 150-300ms delay before showing any loading indicator.
