#!/usr/bin/env bash
set -euo pipefail

AI_LAB_ROOT="/home/local/AI-Agent-Lab"
WEB_ROOT="/home/local/AI-Research-Garden"
WEB_CONTENT="$WEB_ROOT/content"

STAGE="${1:-}"
DATE="${2:-$(date +%F)}"

TMP_FILES=()

cleanup() {
  local file

  for file in "${TMP_FILES[@]:-}"; do
    if [ -n "$file" ]; then
      rm -f -- "$file"
    fi
  done
}

trap cleanup EXIT

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

make_tmp() {
  local file

  file="$(mktemp)"
  TMP_FILES+=("$file")

  printf '%s\n' "$file"
}

count_md() {
  local dir="$1"

  if [ ! -d "$dir" ]; then
    echo 0
    return
  fi

  find "$dir" \
    -maxdepth 1 \
    -type f \
    -name '*.md' \
    -printf '.' |
    wc -c |
    tr -d ' '
}

extract_yaml_scalar() {
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
    BEGIN {
      in_tags = 0
      found = 0
    }

    /^tags:[[:space:]]*$/ {
      in_tags = 1
      next
    }

    in_tags && /^[[:space:]]*-[[:space:]]+/ {
      tag = $0
      sub(/^[[:space:]]*-[[:space:]]+/, "", tag)
      gsub(/^["'\'' ]+|["'\'' ]+$/, "", tag)

      if (tag == wanted) {
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

link_exists() {
  local target="$1"
  local base
  local dir

  if [[ "$target" == */* ]]; then
    [ -f "$STAGE/$target.md" ] && return 0
    [ -f "$WEB_CONTENT/$target.md" ] && return 0
    return 1
  fi

  for base in "$STAGE" "$WEB_CONTENT"; do
    for dir in Daily Papers Tools Projects Concepts People; do
      if [ -f "$base/$dir/$target.md" ]; then
        return 0
      fi
    done
  done

  return 1
}

check_stage_duplicate_against_web() {
  local staged_file="$1"
  local rel
  local staged_title
  local staged_source
  local staged_github
  local staged_arxiv

  local folder
  local official_file
  local official_rel
  local existing_title
  local existing_source
  local existing_github
  local existing_arxiv

  rel="${staged_file#$STAGE/}"

  staged_title="$(extract_yaml_scalar title "$staged_file")"
  staged_source="$(extract_yaml_scalar source_url "$staged_file")"
  staged_github="$(extract_yaml_scalar github_url "$staged_file")"
  staged_arxiv="$(extract_yaml_scalar arxiv "$staged_file")"

  for folder in Papers Tools Projects Concepts People; do
    [ -d "$WEB_CONTENT/$folder" ] || continue

    while IFS= read -r -d '' official_file; do
      official_rel="${official_file#$WEB_CONTENT/}"

      # 同一路徑代表更新既有頁面，允許覆蓋。
      if [ "$official_rel" = "$rel" ]; then
        continue
      fi

      existing_title="$(extract_yaml_scalar title "$official_file")"
      existing_source="$(extract_yaml_scalar source_url "$official_file")"
      existing_github="$(extract_yaml_scalar github_url "$official_file")"
      existing_arxiv="$(extract_yaml_scalar arxiv "$official_file")"

      if [ -n "$staged_title" ] &&
         [ -n "$existing_title" ] &&
         [ "$staged_title" = "$existing_title" ]; then
        echo "Duplicate title: $staged_title"
        echo "  staged:   $rel"
        echo "  existing: $official_rel"
        return 1
      fi

      if [ -n "$staged_source" ] &&
         [ -n "$existing_source" ] &&
         [ "$staged_source" = "$existing_source" ]; then
        echo "Duplicate source URL: $staged_source"
        echo "  staged:   $rel"
        echo "  existing: $official_rel"
        return 1
      fi

      if [ -n "$staged_github" ] &&
         [ -n "$existing_github" ] &&
         [ "$staged_github" = "$existing_github" ]; then
        echo "Duplicate GitHub URL: $staged_github"
        echo "  staged:   $rel"
        echo "  existing: $official_rel"
        return 1
      fi

      if [ -n "$staged_arxiv" ] &&
         [ -n "$existing_arxiv" ] &&
         [ "$staged_arxiv" = "$existing_arxiv" ]; then
        echo "Duplicate arXiv ID: $staged_arxiv"
        echo "  staged:   $rel"
        echo "  existing: $official_rel"
        return 1
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

  return 0
}

validate_content_file() {
  local file="$1"
  local expected_type="$2"

  shift 2

  local required_tag
  local actual_type
  local score

  grep -q '^---[[:space:]]*$' "$file" ||
    fail "missing YAML frontmatter in $file"

  grep -q '^tags:[[:space:]]*$' "$file" ||
    fail "missing tags in $file"

  grep -q '^title:[[:space:]]*' "$file" ||
    fail "missing title in $file"

  if [ "$expected_type" != "concept" ] &&
     [ "$expected_type" != "person" ]; then
    grep -q '^source_url:[[:space:]]*' "$file" ||
      fail "missing source_url in $file"
  fi

  actual_type="$(extract_yaml_scalar type "$file")"

  [ "$actual_type" = "$expected_type" ] ||
    fail "wrong type in $file: expected $expected_type, got ${actual_type:-missing}"

  for required_tag in "$@"; do
    has_tag "$file" "$required_tag" ||
      fail "missing required tag '$required_tag' in $file"
  done

  if [ "$expected_type" = "paper" ] ||
     [ "$expected_type" = "tool" ] ||
     [ "$expected_type" = "project" ]; then
    score="$(extract_yaml_scalar score "$file")"

    [[ "$score" =~ ^[1-5]$ ]] ||
      fail "score must be YAML number 1-5 in $file, got: ${score:-missing}"
  fi
}


update_homepage_latest_research() {
  local home="$WEB_CONTENT/index.md"
  local latest_daily

  [ -f "$home" ] ||
    fail "homepage missing: $home"

  latest_daily="$(
    find "$WEB_CONTENT/Daily" \
      -maxdepth 1 \
      -type f \
      -name '????-??-??.md' \
      -printf '%f\n' |
    sed 's/\.md$//' |
    LC_ALL=C sort -r |
    head -n 1
  )"

  [ -n "$latest_daily" ] ||
    fail "cannot determine latest Daily page"

  python3 - "$home" "$latest_daily" <<'PY_UPDATE_HOME'
from pathlib import Path
import sys

home = Path(sys.argv[1])
latest = sys.argv[2]

lines = home.read_text(encoding="utf-8").splitlines()

try:
    start = lines.index("## 最新研究")
except ValueError:
    raise SystemExit("ERROR: homepage missing 最新研究 section")

end = len(lines)

for index in range(start + 1, len(lines)):
    if lines[index].startswith("## "):
        end = index
        break

replacement = [
    "## 最新研究",
    "",
    f"- [[Daily/{latest}]]",
    "",
]

updated = lines[:start] + replacement + lines[end:]
home.write_text("\n".join(updated).rstrip() + "\n", encoding="utf-8")

print(f"HOMEPAGE_LATEST_DAILY={latest}")
PY_UPDATE_HOME
}

rollback_official_content() {
  echo "Rolling back official content changes..." >&2

  git -C "$WEB_ROOT" reset --hard HEAD >/dev/null

  git -C "$WEB_ROOT" clean -fd -- \
    content/Daily \
    content/Papers \
    content/Tools \
    content/Projects \
    content/Concepts \
    content/People \
    content/Assets >/dev/null
}

[ -n "$STAGE" ] ||
  fail "missing stage directory"

case "$STAGE" in
  "$AI_LAB_ROOT/.openclaw-stage/research-daily-"????-??-??)
    ;;

  "$AI_LAB_ROOT/.openclaw-stage/research-daily-"????-??-??/)
    STAGE="${STAGE%/}"
    ;;

  ./.openclaw-stage/research-daily-????-??-??)
    STAGE="$AI_LAB_ROOT/${STAGE#./}"
    ;;

  .openclaw-stage/research-daily-????-??-??)
    STAGE="$AI_LAB_ROOT/$STAGE"
    ;;

  *)
    fail "invalid stage path: $STAGE"
    ;;
esac

[[ "$DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] ||
  fail "invalid date format: $DATE"

expected_stage="$AI_LAB_ROOT/.openclaw-stage/research-daily-$DATE"

[ "$STAGE" = "$expected_stage" ] ||
  fail "stage/date mismatch: expected $expected_stage, got $STAGE"

[ -d "$STAGE" ] ||
  fail "stage directory does not exist: $STAGE"

if find "$AI_LAB_ROOT" \
  -maxdepth 1 \
  -type d \
  -name '.stage-*' \
  -print -quit |
  grep -q .; then

  find "$AI_LAB_ROOT" \
    -maxdepth 1 \
    -type d \
    -name '.stage-*'

  fail ".stage-* directories are not allowed in AI-Agent-Lab"
fi

for dir in Daily Papers Tools Projects Concepts People Assets; do
  mkdir -p "$WEB_CONTENT/$dir"
done

cd "$WEB_ROOT"

dirty_official="$(
  git status --short -- \
    content/Daily \
    content/Papers \
    content/Tools \
    content/Projects \
    content/Concepts \
    content/People \
    content/Assets ||
    true
)"

if [ -n "$dirty_official" ]; then
  echo "$dirty_official"
  fail "official content folders have uncommitted changes before promote"
fi

DAILY="$STAGE/Daily/$DATE.md"

[ -f "$DAILY" ] ||
  fail "Daily file missing: $DAILY"

[ -s "$DAILY" ] ||
  fail "Daily file is empty: $DAILY"

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
  grep -Fq "$section" "$DAILY" ||
    fail "missing Daily section: $section"
done

grep -q '^tags:[[:space:]]*$' "$DAILY" ||
  fail "Daily missing tags"

has_tag "$DAILY" "daily-research" ||
  fail "Daily missing tag: daily-research"

has_tag "$DAILY" "ai-research" ||
  fail "Daily missing tag: ai-research"

if grep -nE \
  'No relevant data found|無符合|沒有找到|找不到相關|近期無符合' \
  "$DAILY"; then

  fail "Daily contains empty-category placeholder"
fi

if grep -nE \
  'Source：$|Source：[[:space:]]*$|Source：N/A|Source：無|Source：-|Source：null' \
  "$DAILY"; then

  fail "Daily contains empty Source lines"
fi

source_count="$(
  grep -cE 'Source：.*https?://' "$DAILY" ||
  true
)"

[ "$source_count" -ge 6 ] ||
  fail "Daily must contain at least 6 source URLs, found: $source_count"

score_count="$(
  grep -cE 'Score：[[:space:]]*[1-5]([[:space:]]|$)' "$DAILY" ||
  true
)"

[ "$score_count" -ge 6 ] ||
  fail "Daily must contain at least 6 valid scored items, found: $score_count"

grep -Fq '[[' "$DAILY" ||
  fail "Daily does not contain Wiki links"

[ "$(count_md "$STAGE/Papers")" -ge 1 ] ||
  fail "must stage at least 1 Paper"

[ "$(count_md "$STAGE/Tools")" -ge 1 ] ||
  fail "must stage at least 1 Tool"

[ "$(count_md "$STAGE/Concepts")" -ge 3 ] ||
  fail "must stage at least 3 Concepts"


prohibited_first_person="$(
  grep -RInE \
    '可能影響我|對我的|對我而言|我的研究|我的工作|我可以|我們可以|我們的研究|我們的工作' \
    "$STAGE/Daily" \
    "$STAGE/Papers" \
    "$STAGE/Tools" \
    "$STAGE/Projects" \
    "$STAGE/Concepts" \
    "$STAGE/People" \
    --include='*.md' \
    2>/dev/null ||
  true
)"

if [ -n "$prohibited_first_person" ]; then
  echo "$prohibited_first_person"
  fail "knowledge-base content contains prohibited first-person wording"
fi

protected_files=(
  "index.md"
  "Daily/index.md"
  "Papers/index.md"
  "Tools/index.md"
  "Projects/index.md"
  "Concepts/index.md"
  "People/index.md"
)

for protected_file in "${protected_files[@]}"; do
  [ ! -e "$STAGE/$protected_file" ] ||
    fail "Staging contains protected file: $protected_file"
done

while IFS= read -r -d '' file; do
  base="$(basename "$file")"

  case "$base" in
    *$'\n'*|*$'\r'*|*'{'*|*'}'*)
      fail "invalid filename: $file"
      ;;
  esac
done < <(
  find "$STAGE" \
    -type f \
    -print0
)

invalid_tags="$(
  find \
    "$STAGE/Daily" \
    "$STAGE/Papers" \
    "$STAGE/Tools" \
    "$STAGE/Projects" \
    "$STAGE/Concepts" \
    "$STAGE/People" \
    -type f \
    -name '*.md' \
    -print0 \
    2>/dev/null |
  xargs -0 -r grep -nE \
    '^[[:space:]]*-[[:space:]]+(AI Tool|AI Project|AI|Concept|People|#[^[:space:]]+|ai/paper|ai/tool|ai/project)$' ||
  true
)"

if [ -n "$invalid_tags" ]; then
  echo "$invalid_tags"
  fail "invalid Obsidian tags found"
fi

while IFS= read -r -d '' file; do
  validate_content_file "$file" paper ai paper

  check_stage_duplicate_against_web "$file" ||
    fail "duplicate content detected"
done < <(
  find "$STAGE/Papers" \
    -maxdepth 1 \
    -type f \
    -name '*.md' \
    -print0
)

while IFS= read -r -d '' file; do
  validate_content_file "$file" tool ai tool

  check_stage_duplicate_against_web "$file" ||
    fail "duplicate content detected"
done < <(
  find "$STAGE/Tools" \
    -maxdepth 1 \
    -type f \
    -name '*.md' \
    -print0
)

while IFS= read -r -d '' file; do
  validate_content_file "$file" project ai project

  check_stage_duplicate_against_web "$file" ||
    fail "duplicate content detected"
done < <(
  find "$STAGE/Projects" \
    -maxdepth 1 \
    -type f \
    -name '*.md' \
    -print0
)

while IFS= read -r -d '' file; do
  validate_content_file "$file" concept concept

  check_stage_duplicate_against_web "$file" ||
    fail "duplicate content detected"
done < <(
  find "$STAGE/Concepts" \
    -maxdepth 1 \
    -type f \
    -name '*.md' \
    -print0
)

while IFS= read -r -d '' file; do
  validate_content_file "$file" person people

  check_stage_duplicate_against_web "$file" ||
    fail "duplicate content detected"
done < <(
  find "$STAGE/People" \
    -maxdepth 1 \
    -type f \
    -name '*.md' \
    -print0
)

missing_links_file="$(make_tmp)"

while IFS= read -r -d '' file; do
  while IFS= read -r raw; do
    target="${raw#\[\[}"
    target="${target%\]\]}"
    target="${target%%|*}"
    target="${target%%#*}"

    target="$(
      printf '%s' "$target" |
      sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
    )"

    [ -n "$target" ] ||
      continue

    if ! link_exists "$target"; then
      echo "$file -> [[$target]]" >> "$missing_links_file"
    fi
  done < <(
    grep -o '\[\[[^][]*\]\]' "$file" 2>/dev/null ||
    true
  )
done < <(
  find \
    "$STAGE/Daily" \
    "$STAGE/Papers" \
    "$STAGE/Tools" \
    "$STAGE/Projects" \
    "$STAGE/Concepts" \
    "$STAGE/People" \
    -type f \
    -name '*.md' \
    -print0 \
    2>/dev/null
)

if [ -s "$missing_links_file" ]; then
  cat "$missing_links_file"
  fail "Wiki link target file does not exist"
fi

promoted=0

for dir in Daily Papers Tools Projects Concepts People Assets; do
  if [ -d "$STAGE/$dir" ]; then
    rsync -a \
      "$STAGE/$dir/" \
      "$WEB_CONTENT/$dir/"

    promoted=1
  fi
done

update_homepage_latest_research

echo "===== Running Web publish script ====="

set +e

"$AI_LAB_ROOT/Scripts/publish-research-web.sh"

publish_rc=$?

set -e

if [ "$publish_rc" -ne 0 ]; then
  if [ "$promoted" -eq 1 ]; then
    rollback_official_content
  fi

  fail "Web publish script failed with exit code $publish_rc"
fi

test -s "$WEB_CONTENT/Daily/$DATE.md" ||
  fail "official Daily missing after publish"

local_head="$(
  git -C "$WEB_ROOT" rev-parse HEAD
)"

remote_head="$(
  git -C "$WEB_ROOT" \
    ls-remote origin refs/heads/v5 |
    awk '{print $1}'
)"

[ -n "$local_head" ] ||
  fail "cannot resolve local HEAD"

[ -n "$remote_head" ] ||
  fail "cannot resolve remote v5 HEAD"

[ "$local_head" = "$remote_head" ] ||
  fail "remote v5 does not contain local HEAD"

echo "PROMOTE_AND_PUSH_OK"
echo "COMMIT=$local_head"
