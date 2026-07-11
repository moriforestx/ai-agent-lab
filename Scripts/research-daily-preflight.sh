#!/usr/bin/env bash
set -euo pipefail

# research-daily-preflight.sh
# Preflight checks for research-daily workflow (dual-repo architecture)

ROOT="/home/local/AI-Agent-Lab"
WEB_ROOT="/home/local/AI-Research-Garden"
WEB_CONTENT="$WEB_ROOT/content"
DATE="$(date +%F)"
STAGE="$ROOT/.openclaw-stage/research-daily-$DATE"

# 1. 確認必要目錄存在
echo "===== Checking required directories ====="
for d in "$ROOT" "$WEB_ROOT" "$WEB_ROOT/.git" "$WEB_CONTENT"; do
  if [ ! -d "$d" ]; then
    echo "ERROR: Missing required directory: $d" >&2
    exit 1
  fi
  echo "✅ $d exists"
done

# 2. 建立當日 staging（處理衝突）
echo "===== Creating staging directory ====="
if [ -d "$STAGE" ]; then
  NEW_STAGE="$STAGE-retry-$(date +%H%M%S)"
  mv "$STAGE" "$NEW_STAGE"
  echo "Existing staging moved to $NEW_STAGE"
fi
mkdir -p "$STAGE"/{Daily,Papers,Tools,Projects,Concepts,People,Assets}
echo "Staging created: $STAGE"

# 3. 清理舊的 retry staging（保留當日 main staging）
echo "===== Cleaning old retry staging ====="
find "$ROOT/.openclaw-stage" -maxdepth 1 -type d -name 'research-daily-*-retry-*' 2>/dev/null | while IFS= read -r old_stage; do
  if [[ "$old_stage" != "$STAGE-retry-"* ]]; then
    echo "🧹 Cleaning up old retry staging: $old_stage"
    rm -rf "$old_stage"
  fi
done

# 4. 檢查 Web Repository 是否有未完成的操作
echo "===== Checking Web Repository state ====="
cd "$WEB_ROOT"
if git status | grep -qE '(merging|rebasing|cherry-picking)'; then
  echo "ERROR: Web repository has incomplete merge/rebase/cherry-pick" >&2
  exit 1
fi

# 檢查是否有人工未提交變更
dirty_web="$(git status --short || true)"
if [ -n "$dirty_web" ]; then
  echo "WARNING: Web repository has uncommitted changes:"
  echo "$dirty_web"
  echo "Stopping auto-publish to avoid overwriting manual changes." >&2
  exit 1
fi
echo "✅ Web repository clean"

# 5. 檢查必要工具
echo "===== Checking required tools ====="
for tool in git rsync node npm npx; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "ERROR: Required tool not found: $tool" >&2
    exit 1
  fi
  echo "✅ $tool available"
done

# 6. 確認 AI-Agent-Lab/Home.md 仍存在
if [ ! -f "$ROOT/Home.md" ]; then
  echo "ERROR: $ROOT/Home.md missing" >&2
  exit 1
fi
echo "✅ $ROOT/Home.md exists"

# 7. 確認 AI-Agent-Lab/Templates/ 仍存在且可讀取
if [ ! -d "$ROOT/Templates" ] || [ ! -r "$ROOT/Templates" ]; then
  echo "ERROR: $ROOT/Templates missing or not readable" >&2
  exit 1
fi
echo "✅ $ROOT/Templates exists and readable"

# 8. Initialize RUNLOG.md
cat > "$STAGE/RUNLOG.md" <<RUNEOF
# Research Daily Run Log — $DATE

## Phase 0: Preflight [$(date -Iseconds)]
- AI-Agent-Lab: $ROOT
- AI-Research-Garden: $WEB_ROOT
- Web Content: $WEB_CONTENT
- Staging: $STAGE
- Git commit (AI-Agent-Lab): $(git -C "$ROOT" rev-parse HEAD 2>/dev/null || echo 'unknown')
- Git commit (AI-Research-Garden): $(git -C "$WEB_ROOT" rev-parse HEAD 2>/dev/null || echo 'unknown')
- Preflight: PASS
RUNEOF

# 9. Verify web_search availability (tavily)
if [ -n "${TAVILY_API_KEY:-}" ] || command -v web_search >/dev/null 2>&1; then
  echo "✅ web_search available"
  echo "- web_search: available" >> "$STAGE/RUNLOG.md"
else
  echo "⚠️  web_search unavailable, degraded mode"
  echo "- Degraded: web_search unavailable" >> "$STAGE/RUNLOG.md"
fi

echo "Preflight complete. Staging: $STAGE"
