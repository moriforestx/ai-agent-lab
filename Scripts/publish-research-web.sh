#!/usr/bin/env bash
set -euo pipefail

WEB_ROOT="/home/local/AI-Research-Garden"
CONTENT_DIR="$WEB_ROOT/content"
DATE="${1:-$(date +%F)}"

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

[[ "$DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] ||
  fail "Invalid date: $DATE"

[ -d "$WEB_ROOT/.git" ] ||
  fail "Quartz Git repository missing: $WEB_ROOT"

[ -d "$CONTENT_DIR" ] ||
  fail "Quartz content directory missing: $CONTENT_DIR"

cd "$WEB_ROOT"

branch="$(git branch --show-current)"

[ "$branch" = "v5" ] ||
  fail "Expected branch v5, current branch: $branch"

git remote get-url origin >/dev/null 2>&1 ||
  fail "Git remote origin is missing"

echo "===== Sensitive-data scan ====="

pattern='(github_pat_[A-Za-z0-9_]{20,}|ghp_[A-Za-z0-9]{36,}|sk-[A-Za-z0-9_-]{20,}|Bearer[[:space:]]+[A-Za-z0-9._-]{20,}|bot[0-9]+:[A-Za-z0-9_-]{20,}|OPENROUTER_API_KEY[[:space:]]*[:=][[:space:]]*[A-Za-z0-9_-]{20,}|TAVILY_API_KEY[[:space:]]*[:=][[:space:]]*[A-Za-z0-9_-]{20,}|TELEGRAM_BOT_TOKEN[[:space:]]*[:=][[:space:]]*[0-9]+:[A-Za-z0-9_-]{20,}|GITHUB_TOKEN[[:space:]]*[:=][[:space:]]*[A-Za-z0-9_-]{20,})'

if grep -RInE \
  --exclude-dir='.git' \
  --exclude-dir='.obsidian' \
  "$pattern" \
  "$CONTENT_DIR"
then
  fail "Possible secret detected in public content"
fi

echo "===== Quartz build ====="

npx quartz build

echo "===== Git commit ====="

git add content/

if git diff --cached --quiet; then
  echo "NO_CONTENT_CHANGES"
  echo "PROMOTE_AND_PUSH_OK"
  echo "COMMIT=$(git rev-parse HEAD)"
  exit 0
fi

git commit -m "docs(research): publish research for $DATE"

commit_hash="$(git rev-parse HEAD)"

git push origin HEAD:v5

remote_hash="$(
  git ls-remote origin refs/heads/v5 |
  awk '{print $1}'
)"

[ -n "$remote_hash" ] ||
  fail "Unable to read remote v5 HEAD"

[ "$commit_hash" = "$remote_hash" ] ||
  fail "Remote v5 HEAD does not match local commit"

echo "BUILD_OK"
echo "PUSH_OK"
echo "PROMOTE_AND_PUSH_OK"
echo "COMMIT=$commit_hash"
