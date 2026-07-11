#!/usr/bin/env bash
set -euo pipefail

WEB_REPO="/home/local/AI-Research-Garden"
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

# 確認目前 branch
cd "$WEB_REPO"
CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
echo "Current branch: $CURRENT_BRANCH"

# 確認 origin 存在
if ! git remote get-url origin >/dev/null 2>&1; then
  echo "錯誤：找不到 origin remote" >&2
  exit 1
fi
ORIGIN_URL="$(git remote get-url origin)"
echo "Origin: $ORIGIN_URL"

echo "===== Checking sensitive information ====="

# 敏感資訊掃描模式（降低誤判）
PATTERN='(github_pat_[A-Za-z0-9_]{20,}|ghp_[A-Za-z0-9]{36,}|sk-[A-Za-z0-9_-]{20,}|Bearer[[:space:]]+[A-Za-z0-9._-]{20,}|bot[0-9]+:[A-Za-z0-9_-]{20,}|OPENROUTER_API_KEY[[:space:]]*[:=][[:space:]]*[A-Za-z0-9_-]{20,}|TELEGRAM_BOT_TOKEN[[:space:]]*[:=][[:space:]]*[0-9]+:[A-Za-z0-9_-]{20,}|GITHUB_TOKEN[[:space:]]*[:=][[:space:]]*[A-Za-z0-9_-]{20,})[[:space:]]*'

if grep -RInE \
  --exclude-dir=".git" \
  --exclude-dir=".obsidian" \
  --exclude-dir="Templates" \
  "$PATTERN" \
  "$CONTENT_DIR"; then
  echo "錯誤：公開內容中疑似含有 API Key 或 Token，停止發布。" >&2
  exit 1
fi

echo "===== Validating Quartz build ====="

npx quartz build
BUILD_EXIT=$?
if [ $BUILD_EXIT -ne 0 ]; then
  echo "Quartz build 失敗，停止發布。" >&2
  exit $BUILD_EXIT
fi

echo "===== Preparing Git commit ====="

# 只提交正式網站內容，避免意外提交 Quartz 暫存、log、設定或 secrets
git add content/

if git diff --cached --quiet; then
  echo "沒有新的研究內容，不需要 commit。"
  exit 0
fi

# Conventional Commits 格式
git commit -m "docs(research): publish research for $TODAY"
COMMIT_HASH="$(git rev-parse HEAD)"
echo "Commit: $COMMIT_HASH"

git push origin HEAD
PUSH_EXIT=$?
if [ $PUSH_EXIT -ne 0 ]; then
  echo "Git push 失敗" >&2
  exit $PUSH_EXIT
fi

echo "===== Research web publish completed ====="
echo "Build: SUCCESS"
echo "Commit: $COMMIT_HASH"
echo "Push: SUCCESS"
echo "GitHub Actions 將由 push 自動觸發"
