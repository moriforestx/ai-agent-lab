#!/usr/bin/env bash
set -euo pipefail

ROOT="/home/local/AI-Agent-Lab"
WEB_ROOT="/home/local/AI-Research-Garden"
WEB_CONTENT="$WEB_ROOT/content"
DATE="${1:-$(date +%F)}"
STAGE="$ROOT/.openclaw-stage/research-daily-$DATE"

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

[[ "$DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] ||
  fail "Invalid date: $DATE"

echo "===== Checking repositories ====="

for dir in \
  "$ROOT" \
  "$ROOT/.git" \
  "$ROOT/Templates" \
  "$ROOT/Scripts" \
  "$WEB_ROOT" \
  "$WEB_ROOT/.git" \
  "$WEB_CONTENT"
do
  [ -d "$dir" ] || fail "Missing directory: $dir"
  echo "OK: $dir"
done

echo "===== Checking templates ====="

templates=(
  Daily.md
  Paper.md
  Report.md
  Tool.md
  Project.md
  TechnicalDevelopment.md
  Application.md
  Concept.md
  Person.md
)

for template in "${templates[@]}"; do
  file="$ROOT/Templates/$template"
  [ -s "$file" ] || fail "Missing or empty template: $file"
  echo "OK: $file"
done

echo "===== Checking required commands ====="

for command_name in git rsync node npm npx python3; do
  command -v "$command_name" >/dev/null 2>&1 ||
    fail "Required command unavailable: $command_name"
  echo "OK: $command_name"
done

echo "===== Checking repository state ====="

if git -C "$WEB_ROOT" status |
  grep -qE '(merging|rebasing|cherry-picking)'; then
  fail "Quartz repository has an incomplete Git operation"
fi

dirty_web="$(git -C "$WEB_ROOT" status --short || true)"

if [ -n "$dirty_web" ]; then
  echo "$dirty_web"
  fail "Quartz repository contains uncommitted changes"
fi

current_branch="$(git -C "$WEB_ROOT" branch --show-current)"

[ "$current_branch" = "v5" ] ||
  fail "Quartz repository must be on branch v5; current: $current_branch"

echo "===== Preparing staging ====="

if [ -d "$STAGE" ]; then
  retry_stage="$STAGE-retry-$(date +%H%M%S)"
  mv "$STAGE" "$retry_stage"
  echo "Previous staging moved to: $retry_stage"
fi

for dir in \
  Daily \
  Papers \
  Reports \
  Tools \
  Projects \
  TechnicalDevelopments \
  Applications \
  Concepts \
  People \
  Assets
do
  mkdir -p "$STAGE/$dir"
done

find "$ROOT/.openclaw-stage" \
  -maxdepth 1 \
  -type d \
  -name 'research-daily-*-retry-*' \
  -mtime +2 \
  -exec rm -rf -- {} + 2>/dev/null || true

cat > "$STAGE/RUNLOG.md" <<RUNLOG
# Research Daily Run Log — $DATE

## Phase 0: Preflight

- Timestamp: $(date --iso-8601=seconds)
- AI-Agent-Lab: $ROOT
- AI-Research-Garden: $WEB_ROOT
- Staging: $STAGE
- AI-Agent-Lab commit: $(git -C "$ROOT" rev-parse HEAD)
- AI-Research-Garden commit: $(git -C "$WEB_ROOT" rev-parse HEAD)
- Result: PASS
RUNLOG

cat > "$STAGE/STATUS.md" <<STATUS
phase: 0
status: OK
date: $DATE
updated_at: $(date --iso-8601=seconds)
next_phase: 1
STATUS

test -s "$STAGE/RUNLOG.md"
test -s "$STAGE/STATUS.md"

echo "PREFLIGHT_OK"
echo "STAGE=$STAGE"
