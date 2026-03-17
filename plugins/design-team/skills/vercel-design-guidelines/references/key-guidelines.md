# Vercel Design Guidelines — Key Rules

Snapshot of non-obvious rules from vercel.com/design/guidelines.

## Interactions
- All interactive elements must be keyboard accessible
- Visible focus rings on every focusable element (never `outline: none` without replacement)
- Hit targets: ≥24px desktop, ≥44px mobile
- Loading states: add 150-300ms delay before showing spinner, minimum 300-500ms visibility
- URLs must reflect application state (deep-linkable)

## Animations
- Always respect `prefers-reduced-motion` — wrap animations in `@media (prefers-reduced-motion: no-preference)`
- Never use `transition: all` — specify individual properties
- Use GPU-friendly properties: `transform`, `opacity` only
- All animations must be interruptible (user can cancel mid-transition)
- Easing: `cubic-bezier(0.25, 0.1, 0.25, 1)` for most transitions

## Layout
- Use optical alignment, not mathematical (e.g., play button in circle appears off-center if mathematically centered)
- Test at real breakpoints: 375, 390, 768, 1024, 1440
- Account for safe areas on iOS (notch + home indicator)

## Content
- Use skeleton screens, never spinners, for initial page loads
- Empty states must guide user to action (not just "No items found")
- Inline help > tooltips > documentation links

## Forms
- Every input needs a visible label (placeholder is NOT a label)
- Show validation inline on blur, not on submit
- Use `autocomplete` attributes for all personal data fields
- Submit buttons show loading state with minimum visibility duration

## Contrast & Color
- Use APCA contrast (not WCAG 2.x AA) — APCA better predicts readability
- Don't rely on color alone to convey meaning — add icons or text
- Test with simulated color blindness (protanopia, deuteranopia)

## Copywriting
- Active voice, present tense
- Title Case for headings, sentence case for body
- Error messages: explain what went wrong AND how to fix it
- Never use "invalid" — say what's expected instead
