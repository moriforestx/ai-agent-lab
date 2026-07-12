#!/usr/bin/env bash
set -euo pipefail

AI_LAB_ROOT="/home/local/AI-Agent-Lab"
WEB_ROOT="/home/local/AI-Research-Garden"
WEB_CONTENT="$WEB_ROOT/content"

STAGE="${1:-}"
DATE="${2:-$(date +%F)}"

CONTENT_DIRS=(
  Daily
  Papers
  Reports
  Tools
  Projects
  TechnicalDevelopments
  Applications
  Concepts
  People
  Assets
)

ROLLBACK_REQUIRED=0

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

rollback() {
  if [ "$ROLLBACK_REQUIRED" -eq 1 ]; then
    echo "Rolling back Quartz content..." >&2

    git -C "$WEB_ROOT" reset --hard HEAD >/dev/null

    git -C "$WEB_ROOT" clean -fd -- \
      content/Daily \
      content/Papers \
      content/Reports \
      content/Tools \
      content/Projects \
      content/TechnicalDevelopments \
      content/Applications \
      content/Concepts \
      content/People \
      content/Assets >/dev/null
  fi
}

trap rollback EXIT

count_md() {
  local dir="$1"

  [ -d "$dir" ] || {
    echo 0
    return
  }

  find "$dir" \
    -maxdepth 1 \
    -type f \
    -name '*.md' \
    ! -name 'index.md' |
  wc -l |
  tr -d ' '
}

extract_scalar() {
  local key="$1"
  local file="$2"

  sed -nE \
    "s/^${key}:[[:space:]]*[\"']?([^\"']*)[\"']?[[:space:]]*$/\1/p" \
    "$file" |
  head -n 1
}

has_tag() {
  local file="$1"
  local wanted="$2"

  awk -v wanted="$wanted" '
    /^tags:[[:space:]]*$/ {
      in_tags = 1
      next
    }

    in_tags && /^[[:space:]]*-[[:space:]]+/ {
      value = $0
      sub(/^[[:space:]]*-[[:space:]]+/, "", value)
      gsub(/^["'\'' ]+|["'\'' ]+$/, "", value)

      if (value == wanted) {
        found = 1
      }

      next
    }

    in_tags && /^[^[:space:]]/ {
      in_tags = 0
    }

    END {
      exit(found ? 0 : 1)
    }
  ' "$file"
}

validate_frontmatter_shape() {
  local file="$1"

  [ "$(head -n 1 "$file")" = "---" ] ||
    fail "Frontmatter must begin on line 1: $file"

  closing_line="$(
    awk 'NR > 1 && $0 == "---" {print NR; exit}' "$file"
  )"

  [ -n "$closing_line" ] ||
    fail "Frontmatter closing delimiter missing: $file"

  grep -q '^title:[[:space:]]*' "$file" ||
    fail "title missing: $file"

  grep -q '^type:[[:space:]]*' "$file" ||
    fail "type missing: $file"

  grep -q '^tags:[[:space:]]*$' "$file" ||
    fail "tags missing: $file"
}

validate_page() {
  local file="$1"
  local expected_type="$2"
  local required_tag="$3"

  validate_frontmatter_shape "$file"

  actual_type="$(extract_scalar type "$file")"

  [ "$actual_type" = "$expected_type" ] ||
    fail "Wrong type in $file: expected $expected_type, got ${actual_type:-missing}"

  has_tag "$file" ai ||
    fail "Missing ai tag: $file"

  has_tag "$file" "$required_tag" ||
    fail "Missing tag '$required_tag': $file"

  if grep -nE '\{\{[^}]+\}\}|\[\[\.\.\.\]\]|(^|[[:space:]])(N/A|TBD)([[:space:]]|$)' "$file"; then
    fail "Unresolved placeholder found: $file"
  fi

  if grep -nE '/home/local/|research-daily Prompt|SEARCH_THROTTLE_OK|PHASE_[0-9]' "$file"; then
    fail "Internal workflow content found in public Markdown: $file"
  fi
}

link_exists() {
  local target="$1"

  [ -f "$STAGE/$target.md" ] && return 0
  [ -f "$WEB_CONTENT/$target.md" ] && return 0

  return 1
}

check_links() {
  local file="$1"
  local target

  while IFS= read -r target; do
    target="${target%%|*}"
    target="${target%%#*}"

    [ -n "$target" ] || continue

    link_exists "$target" ||
      fail "Broken Wiki Link in $file: [[$target]]"
  done < <(
    grep -oE '\[\[[^][]+\]\]' "$file" |
    sed -E 's/^\[\[//; s/\]\]$//' ||
    true
  )
}

check_duplicate_against_web() {
  local staged_file="$1"
  local staged_rel="${staged_file#$STAGE/}"
  local staged_title
  local staged_source
  local staged_identifier
  local staged_repository

  staged_title="$(extract_scalar title "$staged_file")"
  staged_source="$(extract_scalar source_url "$staged_file")"
  staged_identifier="$(extract_scalar identifier "$staged_file")"
  staged_repository="$(extract_scalar repository_url "$staged_file")"

  for folder in \
    Papers \
    Reports \
    Tools \
    Projects \
    TechnicalDevelopments \
    Applications \
    Concepts \
    People
  do
    [ -d "$WEB_CONTENT/$folder" ] || continue

    while IFS= read -r -d '' existing; do
      existing_rel="${existing#$WEB_CONTENT/}"

      [ "$existing_rel" = "$staged_rel" ] && continue

      existing_title="$(extract_scalar title "$existing")"
      existing_source="$(extract_scalar source_url "$existing")"
      existing_identifier="$(extract_scalar identifier "$existing")"
      existing_repository="$(extract_scalar repository_url "$existing")"

      if [ -n "$staged_title" ] &&
         [ -n "$existing_title" ] &&
         [ "$staged_title" = "$existing_title" ]; then
        fail "Duplicate title: $staged_title ($staged_rel / $existing_rel)"
      fi

      if [ -n "$staged_source" ] &&
         [ -n "$existing_source" ] &&
         [ "$staged_source" = "$existing_source" ]; then
        fail "Duplicate source URL: $staged_source"
      fi

      if [ -n "$staged_identifier" ] &&
         [ -n "$existing_identifier" ] &&
         [ "$staged_identifier" = "$existing_identifier" ]; then
        fail "Duplicate identifier: $staged_identifier"
      fi

      if [ -n "$staged_repository" ] &&
         [ -n "$existing_repository" ] &&
         [ "$staged_repository" = "$existing_repository" ]; then
        fail "Duplicate repository URL: $staged_repository"
      fi
    done < <(
      find "$WEB_CONTENT/$folder" \
        -maxdepth 1 \
        -type f \
        -name '*.md' \
        ! -name 'index.md' \
        -print0
    )
  done
}

update_homepage() {
  local homepage="$WEB_CONTENT/index.md"

  [ -f "$homepage" ] ||
    fail "Homepage missing: $homepage"

  python3 - "$homepage" "$DATE" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
date = sys.argv[2]
lines = path.read_text(encoding="utf-8").splitlines()

try:
    start = lines.index("## 最新研究")
except ValueError:
    raise SystemExit("Homepage missing section: ## 最新研究")

end = len(lines)

for i in range(start + 1, len(lines)):
    if lines[i].startswith("## "):
        end = i
        break

replacement = [
    "## 最新研究",
    "",
    f"- [[Daily/{date}]]",
    "",
]

updated = lines[:start] + replacement + lines[end:]
path.write_text("\n".join(updated).rstrip() + "\n", encoding="utf-8")
PY
}

[ -n "$STAGE" ] ||
  fail "Stage path is required"

[[ "$DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] ||
  fail "Invalid date: $DATE"

expected_stage="$AI_LAB_ROOT/.openclaw-stage/research-daily-$DATE"

case "$STAGE" in
  "$expected_stage"|"$expected_stage/")
    STAGE="${STAGE%/}"
    ;;
  *)
    fail "Stage path must be: $expected_stage"
    ;;
esac

[ -d "$STAGE" ] ||
  fail "Stage directory missing: $STAGE"

[ -d "$WEB_ROOT/.git" ] ||
  fail "Quartz Git repository missing"

for dir in "${CONTENT_DIRS[@]}"; do
  [ -d "$STAGE/$dir" ] ||
    fail "Stage directory missing: $STAGE/$dir"

  mkdir -p "$WEB_CONTENT/$dir"
done

if find "$STAGE" -type f -name 'index.md' -print -quit | grep -q .; then
  fail "Staging must not contain index.md"
fi

dirty_content="$(
  git -C "$WEB_ROOT" status --short -- content/ || true
)"

if [ -n "$dirty_content" ]; then
  echo "$dirty_content"
  fail "Quartz content contains uncommitted changes before promotion"
fi

DAILY="$STAGE/Daily/$DATE.md"

[ -s "$DAILY" ] ||
  fail "Daily missing or empty: $DAILY"

validate_frontmatter_shape "$DAILY"

[ "$(extract_scalar type "$DAILY")" = "daily" ] ||
  fail "Daily type must be daily"

daily_status="$(extract_scalar status "$DAILY")"

case "$daily_status" in
  COMPLETED|COMPLETED_WITH_GAP)
    ;;
  *)
    fail "Invalid Daily status: ${daily_status:-missing}"
    ;;
esac

item_count="$(extract_scalar item_count "$DAILY")"

[[ "$item_count" =~ ^[0-6]$ ]] ||
  fail "Daily item_count must be an integer from 0 to 6"

has_tag "$DAILY" ai ||
  fail "Daily missing ai tag"

has_tag "$DAILY" research-daily ||
  fail "Daily missing research-daily tag"

required_sections=(
  "# $DATE AI Research Daily"
  "## 今日總結"
  "## AI 綜合動態 / General AI Updates"
  "## 電腦視覺 / Computer Vision"
  "## 大型語言模型與自然語言處理 / LLM & NLP"
  "## 音訊與語音 / Audio & Speech"
  "## AI 代理人 / AI Agents"
  "## AI 應用與部署 / AI Applications & Deployment"
  "## 跨領域洞察"
  "## 行動建議"
  "## 今日新增檔案"
  "## 今日更新檔案"
)

for section in "${required_sections[@]}"; do
  grep -Fq "$section" "$DAILY" ||
    fail "Daily section missing: $section"
done

if grep -nE '\{\{[^}]+\}\}|\[\[\.\.\.\]\]|(^|[[:space:]])(N/A|TBD)([[:space:]]|$)' "$DAILY"; then
  fail "Daily contains unresolved placeholders"
fi

if grep -nE '/home/local/|research-daily Prompt|SEARCH_THROTTLE_OK|PHASE_[0-9]' "$DAILY"; then
  fail "Daily contains internal workflow content"
fi

valid_item_count="$(
  grep -cE '^- 🗂 內容類型：(研究成果 / Research|工具與專案 / Tools & Projects|技術動態與落地 / Technical Developments & Applications)$' \
    "$DAILY" ||
  true
)"

[ "$valid_item_count" -eq "$item_count" ] ||
  fail "item_count mismatch: frontmatter=$item_count, actual=$valid_item_count"

source_count="$(
  grep -cE '^- 🔗 主要來源：https?://' "$DAILY" ||
  true
)"

[ "$source_count" -eq "$item_count" ] ||
  fail "Daily source count mismatch: expected $item_count, found $source_count"

date_count="$(
  grep -cE '^- 📅 發布日期：[0-9]{4}-[0-9]{2}-[0-9]{2}$' "$DAILY" ||
  true
)"

[ "$date_count" -eq "$item_count" ] ||
  fail "Daily publication-date count mismatch"

age_count="$(
  grep -cE '^- 🕒 收錄時距發布：[0-9]+ 天$' "$DAILY" ||
  true
)"

[ "$age_count" -eq "$item_count" ] ||
  fail "Daily publication-age count mismatch"

score_count="$(
  grep -cE '^- 📊 綜合評分（AI 判斷）：[1-5](\.[0-9])? / 5$' "$DAILY" ||
  true
)"

[ "$score_count" -eq "$item_count" ] ||
  fail "Daily score count mismatch"

summary_count="$(
  grep -cE '^- 🧠 內容摘要：.+' "$DAILY" ||
  true
)"

[ "$summary_count" -eq "$item_count" ] ||
  fail "Daily summary count mismatch"

value_count="$(
  grep -cE '^- 📌 核心價值：.+' "$DAILY" ||
  true
)"

[ "$value_count" -eq "$item_count" ] ||
  fail "Daily key-value count mismatch"

impact_count="$(
  grep -cE '^- 🌍 應用情境與實務影響：.+' "$DAILY" ||
  true
)"

[ "$impact_count" -eq "$item_count" ] ||
  fail "Daily practical-impact count mismatch"

link_count="$(
  grep -cE '^- 🗂 知識庫連結：\[\[.+\]\]$' "$DAILY" ||
  true
)"

[ "$link_count" -eq "$item_count" ] ||
  fail "Daily knowledge-base link count mismatch"

if [ "$daily_status" = "COMPLETED" ]; then
  [ "$item_count" -eq 6 ] ||
    fail "COMPLETED Daily must contain exactly 6 items"
fi

if [ "$daily_status" = "COMPLETED_WITH_GAP" ]; then
  [ "$item_count" -lt 6 ] ||
    fail "COMPLETED_WITH_GAP must contain fewer than 6 items"

  grep -Fq \
    "> 今日未找到符合日期、來源品質、技術內容與去重要求的項目。" \
    "$DAILY" ||
    fail "COMPLETED_WITH_GAP requires a visible topic gap notice"

  [ -s "$STAGE/rejected-items.md" ] ||
    fail "COMPLETED_WITH_GAP requires rejected-items.md"
fi

prohibited_first_person="$(
  grep -RInE \
    '可能影響我|對我的|對我而言|我的研究|我的工作|我可以|我們可以|我們的研究|我們的工作' \
    "$STAGE/Daily" \
    "$STAGE/Papers" \
    "$STAGE/Reports" \
    "$STAGE/Tools" \
    "$STAGE/Projects" \
    "$STAGE/TechnicalDevelopments" \
    "$STAGE/Applications" \
    "$STAGE/Concepts" \
    "$STAGE/People" \
    --include='*.md' \
    2>/dev/null ||
  true
)"

if [ -n "$prohibited_first_person" ]; then
  echo "$prohibited_first_person"
  fail "Public content contains prohibited first-person wording"
fi

declare -A TYPE_MAP=(
  [Papers]="paper:paper"
  [Reports]="report:report"
  [Tools]="tool:tool"
  [Projects]="project:project"
  [TechnicalDevelopments]="technical-development:technical-development"
  [Applications]="application:application"
  [Concepts]="concept:concept"
  [People]="person:person"
)

for folder in \
  Papers \
  Reports \
  Tools \
  Projects \
  TechnicalDevelopments \
  Applications \
  Concepts \
  People
do
  mapping="${TYPE_MAP[$folder]}"
  expected_type="${mapping%%:*}"
  required_tag="${mapping##*:}"

  while IFS= read -r -d '' file; do
    validate_page "$file" "$expected_type" "$required_tag"
    check_duplicate_against_web "$file"
  done < <(
    find "$STAGE/$folder" \
      -maxdepth 1 \
      -type f \
      -name '*.md' \
      ! -name 'index.md' \
      -print0
  )
done

while IFS= read -r -d '' file; do
  check_links "$file"
done < <(
  find "$STAGE" \
    -type f \
    -name '*.md' \
    \( \
      -path "$STAGE/Daily/*" -o \
      -path "$STAGE/Papers/*" -o \
      -path "$STAGE/Reports/*" -o \
      -path "$STAGE/Tools/*" -o \
      -path "$STAGE/Projects/*" -o \
      -path "$STAGE/TechnicalDevelopments/*" -o \
      -path "$STAGE/Applications/*" -o \
      -path "$STAGE/Concepts/*" -o \
      -path "$STAGE/People/*" \
    \) \
    -print0
)

echo "VALIDATION_OK"

ROLLBACK_REQUIRED=1

for dir in "${CONTENT_DIRS[@]}"; do
  rsync -a \
    --exclude='index.md' \
    "$STAGE/$dir/" \
    "$WEB_CONTENT/$dir/"
done

update_homepage

bash "$AI_LAB_ROOT/Scripts/publish-research-web.sh" "$DATE"

ROLLBACK_REQUIRED=0

echo "PROMOTE_AND_PUSH_OK"
