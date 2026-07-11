#!/usr/bin/env bash
set -euo pipefail

AI_LAB_ROOT="/home/local/AI-Agent-Lab"
WEB_ROOT="/home/local/AI-Research-Garden"
WEB_CONTENT="$WEB_ROOT/content"
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
    [ -f "$WEB_CONTENT/$target.md" ] && return 0
    return 1
  fi

  for base in "$STAGE" "$WEB_CONTENT"; do
    for dir in Daily Papers Tools Projects Concepts People; do
      [ -f "$base/$dir/$target.md" ] && return 0
    done
  done

  return 1
}

check_duplicates() {
  local daily="$STAGE/Daily/$DATE.md"
  local tmpfile="$(mktemp)"
  
  # Extract titles and URLs from Daily items
  grep -E '^### [0-9]+\. ' "$daily" | while IFS= read -r line; do
    title="${line#### *. }"
    echo "TITLE:$title" >> "$tmpfile"
  done
  
  grep -E 'Source：https?://' "$daily" | while IFS= read -r line; do
    url="${line#*Source：}"
    echo "URL:$url" >> "$tmpfile"
  done
  
  # Check against existing files in WEB_CONTENT
  for folder in Papers Tools Projects Concepts People; do
    if [ -d "$WEB_CONTENT/$folder" ]; then
      while IFS= read -r -d '' file; do
        existing_title="$(grep -m1 '^title:' "$file" | cut -d'"' -f2)"
        if [ -n "$existing_title" ]; then
          if grep -q "^TITLE:$existing_title$" "$tmpfile"; then
            echo "Duplicate title found: $existing_title (in $WEB_CONTENT/$folder/$(basename "$file"))"
            rm -f "$tmpfile"
            return 1
          fi
        fi
        existing_url="$(grep -m1 'source_url:' "$file" | cut -d'"' -f2)"
        if [ -n "$existing_url" ]; then
          if grep -q "^URL:$existing_url$" "$tmpfile"; then
            echo "Duplicate URL found: $existing_url (in $WEB_CONTENT/$folder/$(basename "$file"))"
            rm -f "$tmpfile"
            return 1
          fi
        fi
        existing_arxiv="$(grep -m1 'arxiv:' "$file" | cut -d'"' -f2)"
        if [ -n "$existing_arxiv" ]; then
          if grep -q "$existing_arxiv" "$tmpfile"; then
            echo "Duplicate arXiv ID found: $existing_arxiv (in $WEB_CONTENT/$folder/$(basename "$file"))"
            rm -f "$tmpfile"
            return 1
          fi
        fi
        existing_github="$(grep -m1 'github.com' "$file" | head -1)"
        if [ -n "$existing_github" ]; then
          if grep -q "$existing_github" "$tmpfile"; then
            echo "Duplicate GitHub URL found: $existing_github (in $WEB_CONTENT/$folder/$(basename "$file"))"
            rm -f "$tmpfile"
            return 1
          fi
        fi
      done < <(find "$WEB_CONTENT/$folder" -type f -name "*.md" -print0)
    fi
  done
  
  rm -f "$tmpfile"
  return 0
}

[ -n "$STAGE" ] || fail "missing stage directory"

case "$STAGE" in
  "$AI_LAB_ROOT/.openclaw-stage/research-daily-"????-??-??|"$AI_LAB_ROOT/.openclaw-stage/research-daily-"????-??-??/)
    ;;
  ./.openclaw-stage/research-daily-????-??-??|.openclaw-stage/research-daily-????-??-??)
    STAGE="$AI_LAB_ROOT/${STAGE#./}"
    ;;
  *)
    fail "invalid stage path. must be: $AI_LAB_ROOT/.openclaw-stage/research-daily-YYYY-MM-DD, got: $STAGE"
    ;;
esac

[ -d "$STAGE" ] || fail "stage directory does not exist: $STAGE"

# 不允許 .stage-* 目錄存在於 AI-Agent-Lab 根目錄
if find "$AI_LAB_ROOT" -maxdepth 1 -type d -name '.stage-*' | grep -q .; then
  find "$AI_LAB_ROOT" -maxdepth 1 -type d -name '.stage-*'
  fail ".stage-* directories are not allowed in AI-Agent-Lab"
fi

cd "$WEB_ROOT"

# 檢查 Web repo 正式內容資料夾是否有未提交變更
dirty_official="$(
  git status --short -- content/Daily content/Papers content/Tools content/Projects content/Concepts content/People content/Assets || true
)"

if [ -n "$dirty_official" ]; then
  echo "$dirty_official"
  fail "official content folders have uncommitted changes before promote"
fi

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
  "## 📌 行動建議"
  "## 今日新增 / 更新檔案"
)

for section in "${required_sections[@]}"; do
  grep -Fq "$section" "$DAILY" || fail "missing Daily section: $section"
done

if grep -R -nE "No relevant data found|無符合|沒有找到|找不到相關|近期無符合" "$DAILY"; then
  fail "Daily contains empty-category placeholder"
fi

empty_sources="$(
  grep -nE 'Source：$|Source：[[:space:]]*$|Source：N/A|Source：無|Source：-|Source：null' "$DAILY" || true
)"

if [ -n "$empty_sources" ]; then
  echo "$empty_sources"
  fail "Daily contains empty Source lines"
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
    *$\u0027\n'*|*$\u0027\r'*|*\u0027}'*|*\u0027{'*|*/*)
      fail "invalid filename: $file"
      ;;
  esac
done < <(find "$STAGE" -type f -print0)

# Valid tags: daily-research, ai-research, ai, paper, tool, project, concept, people, prompt (no spaces, no #)
invalid_tags="$(
  find "$STAGE" -type f -name "*.md" -print0 \
    | xargs -0 -r grep -nE '^[[:space:]]+-[[:space:]]+(AI Tool|AI Project|AI|Concept|People|#[^[:space:]]+|ai/paper|ai/tool|ai/project)$' || true
)"

if [ -n "$invalid_tags" ]; then
  echo "$invalid_tags"
  fail "invalid Obsidian tag format. Use: daily-research, ai-research, ai, paper, tool, project, concept, people, prompt (no spaces, no #)"
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
    target="$(printf '%s' '$target' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

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

# Check duplicates against existing Web Content
if ! check_duplicates; then
  fail "Duplicate content detected in Web Repository"
fi

# Promote to Web Content using rsync -a (preserve history, no --delete)
promote_list="$(mktemp)"
for dir in Daily Papers Tools Projects Concepts People Assets; do
  if [ -d "$STAGE/$dir" ]; then
    rsync -a "$STAGE/$dir/" "$WEB_CONTENT/$dir/"
    find "$STAGE/$dir" -type f -name "*.md" | while IFS= read -r f; do
      rel="${f#$STAGE/}"
      echo "$rel" >> "$promote_list"
    done
  fi
done

# 保護網站控制檔案 - 不可被覆蓋或刪除
protected_files=(
  "content/index.md"
  "content/Daily/index.md"
  "content/Papers/index.md"
  "content/Tools/index.md"
  "content/Projects/index.md"
  "content/Concepts/index.md"
  "content/People/index.md"
)

for pf in "${protected_files[@]}"; do
  if grep -q "^$pf$" "$promote_list"; then
    echo "ERROR: Staging contains protected index file: $pf"
    rm -f "$promote_list"
    fail "Staging must not contain protected index.md files"
  fi
  # 如果被意外覆蓋，從 git 恢復
  if [ -f "$WEB_ROOT/$pf" ]; then
    git -C "$WEB_ROOT" checkout HEAD -- "$pf" 2>/dev/null || true
  fi
done

rm -f "$promote_list"

# 執行 Web 發布腳本
echo "===== Running Web publish script ====="
if ! "$AI_LAB_ROOT/Scripts/publish-research-web.sh"; then
  fail "Web publish script failed"
fi

echo "PROMOTE_AND_PUSH_OK"
