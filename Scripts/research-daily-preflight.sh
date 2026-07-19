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

workflow_output="$(python3 "$ROOT/Scripts/research-daily-workflow.py" init --date "$DATE")"
echo "$workflow_output"

if [ "$workflow_output" = "ALREADY_COMPLETED" ]; then
  echo "PREFLIGHT_ALREADY_COMPLETED"
  exit 0
fi

test -s "$STAGE/research-state.json"
test -s "$STAGE/RUNLOG.md"
test -s "$STAGE/STATUS.md"

echo "PREFLIGHT_OK"
echo "STAGE=$STAGE"
