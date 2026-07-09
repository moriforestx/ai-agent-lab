#!/usr/bin/env bash
set -euo pipefail

ROOT="/home/local/AI-Agent-Lab"
DATE="${1:-$(date +%F)}"
STAGE="$ROOT/.openclaw-stage/research-daily-$DATE"

echo "===== RESEARCH DAILY STATUS ====="
echo "DATE=$DATE"
echo "STAGE=$STAGE"
echo

cd "$ROOT"

echo "===== git ====="
git status --short
git log --oneline -3
echo

echo "===== stage files ====="
if [ -d "$STAGE" ]; then
  find "$STAGE" -maxdepth 3 -type f | sed "s#$ROOT/##" | sort | head -n 80
else
  echo "NO_STAGE_DIR"
fi
echo

echo "===== STATUS.md ====="
if [ -f "$STAGE/STATUS.md" ]; then
  tail -n 80 "$STAGE/STATUS.md"
else
  echo "NO_STATUS_FILE"
fi
echo

echo "===== RUNLOG tail ====="
if [ -f "$STAGE/RUNLOG.md" ]; then
  tail -n 80 "$STAGE/RUNLOG.md"
else
  echo "NO_RUNLOG_FILE"
fi
echo

echo "===== validation / promote traces ====="
grep -RniE "PHASE|PROMOTE_AND_PUSH_OK|ERROR:|validation|git commit|git push|web_search|tool_call failed|Unknown tool" \
  "$STAGE" \
  2>/dev/null | tail -n 80 || true
