#!/bin/bash
# Check domain availability using whois
# Usage: check-domain.sh example.com [example2.com ...]

for domain in "$@"; do
  echo "=== $domain ==="
  result=$(whois "$domain" 2>/dev/null)

  if echo "$result" | grep -qi "no match\|not found\|no data found\|domain not found\|no entries found\|available"; then
    echo "  ✓ LIKELY AVAILABLE"
  elif echo "$result" | grep -qi "registrar\|creation date\|registered"; then
    registrar=$(echo "$result" | grep -i "registrar:" | head -1 | sed 's/.*Registrar: *//')
    created=$(echo "$result" | grep -i "creation date\|created:" | head -1 | sed 's/.*: *//')
    echo "  ✗ TAKEN"
    [ -n "$registrar" ] && echo "    Registrar: $registrar"
    [ -n "$created" ] && echo "    Created: $created"
  else
    echo "  ? UNKNOWN (whois returned unusual response)"
  fi
  echo ""
done
