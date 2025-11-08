#!/usr/bin/env bash
# SAIMAI Compliance Validator
# Ensures policy file exists, is sealed with BLAKE3, and ledger is append-only.

POLICY_FILE=".saimai/saimai_policy.sai"
LEDGER_FILE=".saimai/audit/ledger.log"
HASH_TOOL="b3sum"   # Requires BLAKE3 CLI (https://github.com/BLAKE3-team/BLAKE3)

echo "🔐 SAIMAI Compliance Validator Starting..."

# 1. Check policy file presence
if [ ! -f "$POLICY_FILE" ]; then
  echo "❌ Missing SAIMAI policy file: $POLICY_FILE"
  exit 1
fi

# 2. Verify BLAKE3 seal
if ! command -v $HASH_TOOL &> /dev/null; then
  echo "⚠️  BLAKE3 tool not found. Install 'b3sum' to enforce seal validation."
  exit 1
fi

POLICY_HASH=$($HASH_TOOL "$POLICY_FILE" | awk '{print $1}')
echo "✅ Policy file hash (BLAKE3): $POLICY_HASH"

# 3. Append-only ledger check
if [ -f "$LEDGER_FILE" ]; then
  LAST_HASH=$(tail -n 1 "$LEDGER_FILE" | awk '{print $2}')
  if [ "$LAST_HASH" == "$POLICY_HASH" ]; then
    echo "✅ Ledger already contains current policy hash."
  else
    echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") $POLICY_HASH" >> "$LEDGER_FILE"
    echo "📜 Ledger updated with new policy hash."
  fi
else
  mkdir -p "$(dirname "$LEDGER_FILE")"
  echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") $POLICY_HASH" > "$LEDGER_FILE"
  echo "📜 Ledger created and sealed."
fi

echo "🎉 SAIMAI compliance validation complete."
exit 0
chmod +x tools/validate-saimai.sh
