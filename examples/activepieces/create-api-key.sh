#!/bin/bash
# Generate a new Activepieces platform API key for self-hosted instances.
# In Community edition, platform API keys (sk-...) are not available via UI.
# This script inserts a new key directly into the PostgreSQL database.

set -euo pipefail

# ── Configuration (override via env vars) ──────────────────────────────────
NAMESPACE="${AP_NAMESPACE:-activepieces-example}"
PG_STATEFULSET="${AP_PG_STATEFULSET:-postgres}"
PG_DB="${AP_PG_DB:-activepieces}"
PG_USER="${AP_PG_USER:-postgres}"
PLATFORM_ID="${AP_PLATFORM_ID:-}"
DISPLAY_NAME="${AP_DISPLAY_NAME:-CLI Generated Key}"

# ── Resolve Platform ID ───────────────────────────────────────────────────
if [ -z "$PLATFORM_ID" ]; then
  echo "Resolving platform ID..."
  PLATFORM_ID=$(kubectl exec -n "$NAMESPACE" statefulset/"$PG_STATEFULSET" \
    -- psql -U "$PG_USER" -d "$PG_DB" -t -A \
    -c "SELECT id FROM platform LIMIT 1;" | tr -d '[:space:]')
  if [ -z "$PLATFORM_ID" ]; then
    echo "Error: no platform found in the database." >&2
    exit 1
  fi
  echo "  platformId = $PLATFORM_ID"
fi

# ── Generate Key ──────────────────────────────────────────────────────────
KEY=$(echo -n "sk-" && openssl rand -hex 30)
HASH=$(echo -n "$KEY" | sha256sum | awk '{print $1}')
TRUNCATED=$(echo -n "$KEY" | tail -c 4)
NEW_ID=$(head -c 21 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | head -c 21)

# ── Insert into Database ──────────────────────────────────────────────────
kubectl exec -n "$NAMESPACE" statefulset/"$PG_STATEFULSET" \
  -- psql -U "$PG_USER" -d "$PG_DB" -t -A \
  -c "
    INSERT INTO api_key (id, \"displayName\", \"platformId\", \"hashedValue\", \"truncatedValue\", created, updated)
    VALUES ('${NEW_ID}', '${DISPLAY_NAME}', '${PLATFORM_ID}', '${HASH}', '${TRUNCATED}', NOW(), NOW());
  " > /dev/null

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  New API Key:"
echo ""
echo "  Bearer ${KEY}"
echo ""
echo "  Authorization: Bearer ${KEY}"
echo ""
echo "═══════════════════════════════════════════════════════════"
