#!/usr/bin/env bash

set -euo pipefail

WEB_REPO="/home/local/ai-research-garden"
CONTENT_DIR="$WEB_REPO/content"
TODAY="$(date +%F)"

echo "===== Research web publish started: $TODAY ====="

if [[ ! -d "$WEB_REPO/.git" ]]; then
  echo "錯誤：找不到 Web Git repository：$WEB_REPO" >&2
  exit 1
fi

if [[ ! -d "$CONTENT_DIR" ]]; then
  echo "錯誤：找不到 Quartz content 目錄：$CONTENT_DIR" >&2
  exit 1
fi

echo "===== Checking sensitive information ====="

PATTERN='(github_pat_[A-Za-z0-9_]+|ghp_[A-Za-z0-9]+|sk-[A-Za-z0-9_-]{16,}|Bearer[[:space:]]+[A-Za-z0-9._-]+|bot[0-9]+:[A-Za-z0-9_-]+|OPENROUTER_API_KEY|TELEGRAM_BOT_TOKEN|GITHUB_TOKEN)'

if grep -RInE \
  --exclude-dir=".git" \
  --exclude-dir=".obsidian" \
  --exclude-dir="Templates" \
  "$PATTERN" \
  "$CONTENT_DIR"; then
  echo "錯誤：公開內容中疑似含有 API Key 或 Token，停止發布。" >&2
  exit 1
fi

cd "$WEB_REPO"

echo "===== Validating Quartz build ====="

npx quartz build

echo "===== Preparing Git commit ====="

git add content/

if git diff --cached --quiet; then
  echo "沒有新的研究內容，不需要 commit。"
  exit 0
fi

git commit -m "research: update $TODAY"
git push origin HEAD

echo "===== Research web publish completed ====="

