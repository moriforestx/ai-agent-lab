#!/usr/bin/env bash
set -euo pipefail

# research-daily-preflight.sh
# Preflight checks for research-daily workflow

ROOT="/home/local/AI-Agent-Lab"
DATE="$(date +%F)"
STAGE="$ROOT/.openclaw-stage/research-daily-$DATE"

# 1. Ensure official folders exist
for d in Daily Papers Tools Projects Concepts People; do
  mkdir -p "$ROOT/$d"
done

# 2. Git status check - stash any uncommitted changes in official folders
dirty=$(git -C "$ROOT" status --short -- Daily Papers Tools Projects Concepts People 2>/dev/null || true)
if [ -n "$dirty" ]; then
  echo "⚠️  Uncommitted changes in official folders, stashing..."
  echo "$dirty"
  git -C "$ROOT" stash push -m "pre-research-daily-$DATE" -- Daily Papers Tools Projects Concepts People
  echo "Stashed: $(git -C "$ROOT" stash list | head -1)"
else
  echo "✅ Official folders clean"
fi

# 3. Create staging (handle conflicts)
if [ -d "$STAGE" ]; then
  NEW_STAGE="$STAGE-retry-$(date +%H%M%S)"
  mv "$STAGE" "$NEW_STAGE"
  echo "Existing staging moved to $NEW_STAGE"
fi
mkdir -p "$STAGE"/{Daily,Papers,Tools,Projects,Concepts,People}

# 4. CLEANUP: Remove old retry staging dirs (keep only current date's staging)
# This implements the retention policy: on new run, clean up old retry folders
find "$ROOT/.openclaw-stage" -maxdepth 1 -type d -name 'research-daily-*-retry-*' 2>/dev/null | while IFS= read -r old_stage; do
  # Only remove retry folders, not the current date's main staging
  if [[ "$old_stage" != "$STAGE-retry-"* ]]; then
    echo "🧹 Cleaning up old retry staging: $old_stage"
    rm -rf "$old_stage"
  fi
done

# 5. Initialize RUNLOG.md
cat > "$STAGE/RUNLOG.md" <<EOF
# Research Daily Run Log — $DATE

## Phase 0: Preflight [$(date -Iseconds)]
- Repo: $ROOT
- Git commit: $(git -C "$ROOT" rev-parse HEAD 2>/dev/null || echo 'unknown')
- Staging: $STAGE
- Preflight: PASS
EOF

# 6. Verify web_search availability (tavily)
if [ -n "${TAVILY_API_KEY:-}" ] || command -v web_search >/dev/null 2>&1; then
  echo "✅ web_search available"
  echo "- web_search: available" >> "$STAGE/RUNLOG.md"
else
  echo "⚠️  web_search unavailable, degraded mode"
  echo "- Degraded: web_search unavailable" >> "$STAGE/RUNLOG.md"
fi

echo "Preflight complete. Staging: $STAGE"
