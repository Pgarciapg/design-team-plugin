#!/bin/bash
# Check domain availability using whois, with history logging
# Usage: check-domain.sh example.com [example2.com ...]

HISTORY_FILE="$(dirname "$0")/../data/domain-history.jsonl"
mkdir -p "$(dirname "$HISTORY_FILE")"

for domain in "$@"; do
  echo "=== $domain ==="
  result=$(whois "$domain" 2>/dev/null)
  timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)

  if echo "$result" | grep -qi "no match\|not found\|no data found\|domain not found\|no entries found\|available"; then
    status="available"
    echo "  ✓ LIKELY AVAILABLE"
  elif echo "$result" | grep -qi "registrar\|creation date\|registered"; then
    status="taken"
    registrar=$(echo "$result" | grep -i "registrar:" | head -1 | sed 's/.*Registrar: *//')
    created=$(echo "$result" | grep -i "creation date\|created:" | head -1 | sed 's/.*: *//')
    echo "  ✗ TAKEN"
    [ -n "$registrar" ] && echo "    Registrar: $registrar"
    [ -n "$created" ] && echo "    Created: $created"
  else
    status="unknown"
    echo "  ? UNKNOWN (whois returned unusual response)"
  fi

  # Log to history
  echo "{\"domain\":\"$domain\",\"status\":\"$status\",\"checked_at\":\"$timestamp\"}" >> "$HISTORY_FILE"
  echo ""
done

# Show recent history count
if [ -f "$HISTORY_FILE" ]; then
  total=$(wc -l < "$HISTORY_FILE" | tr -d ' ')
  echo "--- $total domains checked historically (see data/domain-history.jsonl) ---"
fi
