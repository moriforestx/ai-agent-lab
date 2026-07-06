#!/usr/bin/env bash
set -euo pipefail

ROOT="/home/local/AI-Agent-Lab"
STAGE="${1:-}"
DATE="${2:-$(date +%F)}"

if [ -z "$STAGE" ]; then
  echo "ERROR: missing stage directory"
  exit 1
fi

if [ ! -d "$STAGE" ]; then
  echo "ERROR: stage directory does not exist: $STAGE"
  exit 1
fi

DAILY="$STAGE/Daily/$DATE.md"

if [ ! -f "$DAILY" ]; then
  echo "ERROR: Daily file missing: $DAILY"
  exit 1
fi

if [ ! -s "$DAILY" ]; then
  echo "ERROR: Daily file is empty"
  exit 1
fi

required_sections=(
  "## 今日總結"
  "## 🧠 AI 最新資訊"
  "## 👁 Computer Vision / 影像辨識 AI"
  "## 🧾 LLM / NLP"
  "## 🎧 Audio / Speech"
  "## 🤖 AI Agents"
  "## 🛠 GitHub / Tools / Projects"
  "## 💡 今日跨領域洞察"
  "## 📌 對我的行動建議"
  "## 今日新增 / 更新檔案"
)

for section in "${required_sections[@]}"; do
  if ! grep -Fq "$section" "$DAILY"; then
    echo "ERROR: missing Daily section: $section"
    exit 1
  fi
done

if grep -R -n "No relevant data found\|無符合\|沒有找到\|找不到相關" "$DAILY"; then
  echo "ERROR: Daily contains empty-category placeholder"
  exit 1
fi

if ! grep -Fq "[[" "$DAILY"; then
  echo "ERROR: Daily does not contain Obsidian links"
  exit 1
fi

source_count="$(grep -cE '🔗 Source：https?://' "$DAILY" || true)"
if [ "$source_count" -lt 6 ]; then
  echo "ERROR: Daily must contain at least 6 source URLs, found: $source_count"
  exit 1
fi

score_count="$(grep -cE '⭐ Score：' "$DAILY" || true)"
if [ "$score_count" -lt 6 ]; then
  echo "ERROR: Daily must contain at least 6 scored items, found: $score_count"
  exit 1
fi

while IFS= read -r -d '' file; do
  case "$file" in
    *$'\n'*|*$'\r'*|*'}'*)
      echo "ERROR: invalid filename: $file"
      exit 1
      ;;
  esac
done < <(find "$STAGE" -type f -print0)

if find "$STAGE" -type f -name "*.md" -print0 \
  | xargs -0 -r grep -nE '^[[:space:]]+-[[:space:]]+(AI Tool|AI Project|AI|Concept|People)$'
then
  echo "ERROR: invalid Obsidian tag format"
  exit 1
fi

for dir in Papers Tools Projects Concepts People; do
  if [ -d "$STAGE/$dir" ]; then
    while IFS= read -r -d '' file; do
      if ! grep -q '^tags:' "$file"; then
        echo "ERROR: missing frontmatter tags in $file"
        exit 1
      fi
    done < <(find "$STAGE/$dir" -type f -name "*.md" -print0)
  fi
done

mkdir -p "$ROOT/Daily" "$ROOT/Papers" "$ROOT/Tools" "$ROOT/Projects" "$ROOT/Concepts" "$ROOT/People"

for dir in Daily Papers Tools Projects Concepts People; do
  if [ -d "$STAGE/$dir" ]; then
    cp -a "$STAGE/$dir/." "$ROOT/$dir/"
  fi
done

cd "$ROOT"

git add Daily Papers Tools Projects Concepts People

if git diff --cached --quiet; then
  echo "No changes to commit"
  exit 0
fi

git commit -m "daily research update $DATE"
git push origin main

echo "PROMOTE_AND_PUSH_OK"
