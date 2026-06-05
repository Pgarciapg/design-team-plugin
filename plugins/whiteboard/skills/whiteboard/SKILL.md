---
name: whiteboard
description: Draw a single self-contained HTML page that visually recaps the current work — a goal line, what's done / what's next, and Mermaid diagrams of how the pieces actually work — then open it. Use when the user types /whiteboard, or asks to visualize, diagram, map out, or recap where things stand. An optional argument focuses it, e.g. /whiteboard data flow.
---

Make a **whiteboard**: one HTML file that lets the user *see* how the work fits together, then open it. Lean on diagrams — this is a visual artifact, not a prose summary.

**Write for the audience, and default to plain language.** Unless the user says it's for engineers, assume anyone should get it in one read — a marketer, a client, a new teammate. Label steps by what they *accomplish*, not by the mechanism (`a 2nd AI checks every fact is real`, not `provenance check`). Cut jargon, internal IDs, and library names (`Jaccard`, `scopeHash`, `0-970`, `deterministic Node`) or translate them. Open with a one-breath "what it does" and, for anything non-obvious, a single real-world analogy. The depth still shows — it just shows in outcomes a human cares about (won't make things up / won't overspend / won't act without approval), not in implementation terms.

1. **Build from the current conversation and the files touched this session.** If you're missing a key fact, read that file first — don't guess. For depth (how something *works* — a quality loop, error handling, a browser/external channel), read the actual source; don't hand-wave it. With a focus argument (e.g. `/whiteboard auth flow`), scope to that topic; otherwise recap the whole thread.

2. **Scale the visual depth to the subject** — this is the main lever:
   - A small/simple topic → one diagram is right. Don't pad it.
   - A rich system → give each facet its own diagram. Typically: the **main flow**, the **quality / error-handling loop** (how outputs get validated, what the failure paths are), any **state machine** (budget tiers, status transitions), and **external channels** (browser automation, API calls, third-party writes). Four small clear diagrams beat one giant one.

3. **Make it genuinely visual.** Read the template at `${CLAUDE_PLUGIN_ROOT}/skills/whiteboard/templates/whiteboard-template.html`. Use **color** — Mermaid `classDef` to tint nodes by role (deterministic=green, LLM/agent=amber, approval gate=blue, fail/blocked=red, external=grey) — and keep the legend in sync. Give every diagram a one-sentence caption saying what it shows. Pick the right type per facet: `flowchart TD` (architecture/flow), `sequenceDiagram` (call order), `stateDiagram-v2` (state machine), `erDiagram` (data model).

4. **Keep the header tight.** Goal line + a few Done / Next bullets. The diagrams carry the depth; the text just frames them.

5. **Write** to `/tmp/whiteboard-<topic>.html`, **open** it, and reply with a one-line summary.

**Mermaid gotcha:** wrap any node label containing special characters (`()`, `/`, `:`, quotes, `≥`, `%`) in double quotes — `A["fetch(/api)"]` — or the diagram renders as a red error box. Keep labels short; split a 30-node diagram into two.
