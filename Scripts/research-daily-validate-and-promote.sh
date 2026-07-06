#!/usr/bin/env bash
set -euo pipefail

ROOT="/home/local/AI-Agent-Lab"
STAGE="${1:-}"
DATE="${2:-$(date +%F)}"

fail() {
  echo "ERROR: $*"
  exit 1
}

count_md() {
  local dir="$1"
  if [ ! -d "$dir" ]; then
    echo 0
    return
  fi
  find "$dir" -maxdepth 1 -type f -name "*.md" | wc -l | tr -d ' '
}

link_exists() {
  local target="$1"
  local base dir

  if [[ "$target" == */* ]]; then
    [ -f "$STAGE/$target.md" ] && return 0
    [ -f "$ROOT/$target.md" ] && return 0
    return 1
  fi

  for base in "$STAGE" "$ROOT"; do
    for dir in Daily Papers Tools Projects Concepts People; do
      [ -f "$base/$dir/$target.md" ] && return 0
    done
  done

  return 1
}

[ -n "$STAGE" ] || fail "missing stage directory"
[ -d "$STAGE" ] || fail "stage directory does not exist: $STAGE"

DAILY="$STAGE/Daily/$DATE.md"

[ -f "$DAILY" ] || fail "Daily file missing: $DAILY"
[ -s "$DAILY" ] || fail "Daily file is empty: $DAILY"

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
  grep -Fq "$section" "$DAILY" || fail "missing Daily section: $section"
done

if grep -R -nE "No relevant data found|無符合|沒有找到|找不到相關|近期無符合" "$DAILY"; then
  fail "Daily contains empty-category placeholder"
fi

source_count="$(grep -cE 'Source：.*https?://' "$DAILY" || true)"
[ "$source_count" -ge 6 ] || fail "Daily must contain at least 6 source URLs, found: $source_count"

score_count="$(grep -cE 'Score：' "$DAILY" || true)"
[ "$score_count" -ge 6 ] || fail "Daily must contain at least 6 scored items, found: $score_count"

grep -Fq "[[" "$DAILY" || fail "Daily does not contain Obsidian links"

[ "$(count_md "$STAGE/Papers")" -ge 1 ] || fail "must create at least 1 Paper"
[ "$(count_md "$STAGE/Tools")" -ge 1 ] || fail "must create at least 1 Tool"
[ "$(count_md "$STAGE/Projects")" -ge 1 ] || fail "must create at least 1 Project"
[ "$(count_md "$STAGE/Concepts")" -ge 3 ] || fail "must create at least 3 Concepts"

while IFS= read -r -d '' file; do
  base="$(basename "$file")"

  case "$base" in
    *$'\n'*|*$'\r'*|*'}'*|*'{'*)
      fail "invalid filename: $file"
      ;;
  esac
done < <(find "$STAGE" -type f -print0)

invalid_tags="$(
  find "$STAGE" -type f -name "*.md" -print0 \
    | xargs -0 -r grep -nE '^[[:space:]]+-[[:space:]]+(AI Tool|AI Project|AI|Concept|People)$' || true
)"

if [ -n "$invalid_tags" ]; then
  echo "$invalid_tags"
  fail "invalid Obsidian tag format"
fi

hash_tags="$(
  find "$STAGE" -type f -name "*.md" -print0 \
    | xargs -0 -r grep -nE '^[[:space:]]+-[[:space:]]+#' || true
)"

if [ -n "$hash_tags" ]; then
  echo "$hash_tags"
  fail "tags must not include #"
fi

for dir in Papers Tools Projects Concepts People; do
  if [ -d "$STAGE/$dir" ]; then
    while IFS= read -r -d '' file; do
      grep -q '^---' "$file" || fail "missing YAML frontmatter in $file"
      grep -q '^tags:' "$file" || fail "missing tags in $file"
    done < <(find "$STAGE/$dir" -type f -name "*.md" -print0)
  fi
done

missing_links_file="$(mktemp)"

while IFS= read -r -d '' file; do
  grep -o '\[\[[^][]*\]\]' "$file" 2>/dev/null | while IFS= read -r raw; do
    target="${raw#\[\[}"
    target="${target%\]\]}"
    target="${target%%|*}"
    target="${target%%#*}"
    target="$(printf '%s' "$target" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

    [ -n "$target" ] || continue

    if ! link_exists "$target"; then
      echo "$file -> [[$target]]" >> "$missing_links_file"
    fi
  done
done < <(find "$STAGE" -type f -name "*.md" -print0)

if [ -s "$missing_links_file" ]; then
  cat "$missing_links_file"
  rm -f "$missing_links_file"
  fail "Obsidian link target file does not exist"
fi

rm -f "$missing_links_file"

mkdir -p "$ROOT/Daily" "$ROOT/Papers" "$ROOT/Tools" "$ROOT/Projects" "$ROOT/Concepts" "$ROOT/People"

for dir in Daily Papers Tools Projects Concepts People; do
  if [ -d "$STAGE/$dir" ]; then
    cp -a "$STAGE/$dir/." "$ROOT/$dir/"
  fi
done

cd "$ROOT"

git add Daily Papers Tools Projects Concepts People

if git diff --cached --quiet; then
  echo "PROMOTE_AND_PUSH_OK_NO_CHANGES"
  exit 0
fi

git commit -m "daily research update $DATE"
git push origin main

echo "PROMOTE_AND_PUSH_OK"
