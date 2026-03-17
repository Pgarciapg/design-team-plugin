---
name: Domain Name Generation
description: Use when brainstorming domain names, brand names, or website URLs for a project.
version: 1.0.0
---

# Domain Name Generation

Generate memorable, available domain names for projects.

**Availability checker:** Run `~/.claude/plugins/marketplaces/pgarciapg-plugins/plugins/domain-scout/skills/name-generation/scripts/check-domain.sh example.com` to check if domains are taken.

## Extension Pricing & Trust

| Extension | Price Range | Audience | Notes |
|-----------|------------|----------|-------|
| .com | $10-15/yr | Everyone | Highest trust, hardest to find |
| .io | $30-50/yr | Developers | De facto tech standard |
| .co | $25-35/yr | Startups | Short .com alternative |
| .app | $15-20/yr | Mobile/web | Requires HTTPS |
| .dev | $12-15/yr | Developers | Requires HTTPS |
| .ai | $80-120/yr | AI products | Premium pricing, trendy |
| .so | $20-30/yr | Creative | Cool factor, less known |

## Quality Tests

Before suggesting a name, run these checks:

1. **Phone test**: Can you say it clearly in a phone call without spelling it out?
2. **Radio test**: Would it work in a podcast ad? ("Visit example dot com")
3. **Search test**: Is it unique enough to rank on Google?
4. **Social test**: Is the @handle available on Twitter/GitHub?
5. **Global test**: Any negative meanings in Spanish, Chinese, or Arabic?
6. **Typo test**: Are common misspellings taken by competitors?

## Process

1. Understand the project's purpose and audience
2. Generate 10-15 candidates across strategies (compound, invented, modified, action, metaphor)
3. Run `scripts/check-domain.sh` on top candidates
4. Filter by quality tests above
5. Present 5-7 available options with rationale

## Gotchas

- **Checking a domain on GoDaddy may flag it** — some registrars are suspected of preemptively registering queried domains. Use `whois` CLI or Namecheap instead.
- **`.ai` domains cost $80-120/year** and require renewal through Anguilla's NIC — budget accordingly.
- **Premium domains on Namecheap** show inflated "aftermarket" prices — check the actual registry price at the registrar directly.
- **Two-letter .com domains don't exist** in the open market — they're all taken or reserved. Don't suggest them.
- **Expired domains may have spam history** — check the Wayback Machine and Google Safe Browsing before buying a previously-owned domain.
- **HTTPS-required TLDs** (.app, .dev) will not serve over HTTP — your site MUST have SSL configured.
- **Country-code TLDs** (.io = British Indian Ocean Territory, .ai = Anguilla) can have geopolitical risks — the .io TLD's future is uncertain after the Chagos Islands sovereignty transfer.
- **Domain privacy is free at most registrars now** — always enable WHOIS privacy to avoid spam.
