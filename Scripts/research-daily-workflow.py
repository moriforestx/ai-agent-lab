#!/usr/bin/env python3
"""Deterministic state, validation, and rendering for AI Research Daily.

The research agent only supplies one JSON candidate per fixed topic.  This
program owns the state transitions and all Markdown generated from that JSON.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
import sys
from datetime import date, datetime
from pathlib import Path
from urllib.parse import urlparse

ROOT = Path("/home/local/AI-Agent-Lab")
GARDEN = Path("/home/local/AI-Research-Garden")
STAGE_BASE = ROOT / ".openclaw-stage"
TOPICS = (
    ("ai-general", "AI 綜合動態 / General AI Updates"),
    ("computer-vision", "電腦視覺 / Computer Vision"),
    ("llm-nlp", "大型語言模型與自然語言處理 / LLM & NLP"),
    ("audio-speech", "音訊與語音 / Audio & Speech"),
    ("ai-agents", "AI 代理人 / AI Agents"),
    ("ai-applications-deployment", "AI 應用與部署 / AI Applications & Deployment"),
)
TOPIC_NAMES = dict(TOPICS)
TYPES = {
    "paper": ("Papers", "paper", "paper"),
    "report": ("Reports", "report", "report"),
    "tool": ("Tools", "tool", "tool"),
    "project": ("Projects", "project", "project"),
    "technical-development": ("TechnicalDevelopments", "technical-development", "technical-development"),
    "application": ("Applications", "application", "application"),
}


def fail(message: str) -> None:
    raise SystemExit(f"ERROR: {message}")


def stage_for(day: str) -> Path:
    try:
        date.fromisoformat(day)
    except ValueError:
        fail(f"invalid date: {day}")
    return STAGE_BASE / f"research-daily-{day}"


def state_path(stage: Path) -> Path:
    return stage / "research-state.json"


def write_json(path: Path, value: object) -> None:
    temp = path.with_suffix(path.suffix + ".tmp")
    temp.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    temp.replace(path)


def load_state(stage: Path) -> dict:
    path = state_path(stage)
    if not path.is_file():
        fail(f"state missing: {path}")
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        fail(f"invalid state JSON: {exc}")


def now() -> str:
    return datetime.now().astimezone().isoformat(timespec="seconds")


def initial_state(day: str) -> dict:
    return {
        "schema_version": 1,
        "date": day,
        "created_at": now(),
        "updated_at": now(),
        "request_budget": {"limit": 8, "used": 0},
        "topics": {key: {"name": name, "result": "pending"} for key, name in TOPICS},
        "render": {"status": "pending"},
        "final": {"status": "PENDING"},
    }


def save(stage: Path, state: dict) -> None:
    state["updated_at"] = now()
    write_json(state_path(stage), state)


def append_log(stage: Path, line: str) -> None:
    path = stage / "RUNLOG.md"
    with path.open("a", encoding="utf-8") as stream:
        stream.write(f"\n- {now()}: {line}\n")


def init(day: str) -> None:
    stage = stage_for(day)
    if stage.exists() and state_path(stage).exists():
        state = load_state(stage)
        if state.get("final", {}).get("status") == "COMPLETED":
            verify_remote(state)
            print("ALREADY_COMPLETED")
            return
        print("RESUME_READY")
        return
    legacy_stage = None
    if stage.exists() and any(stage.iterdir()):
        # Legacy Markdown-only stages cannot be resumed safely because they do
        # not contain per-topic outcomes. Preserve, rather than overwrite,
        # the audit trail and start a canonical structured stage.
        legacy_stage = stage.with_name(f"{stage.name}.legacy-{datetime.now().strftime('%H%M%S')}")
        stage.replace(legacy_stage)
    for name in ("Daily", "Papers", "Reports", "Tools", "Projects", "TechnicalDevelopments", "Applications", "Concepts", "People", "Assets", "checkpoints"):
        (stage / name).mkdir(parents=True, exist_ok=True)
    state = initial_state(day)
    save(stage, state)
    legacy_note = f"; preserved legacy stage at {legacy_stage.name}" if legacy_stage else ""
    (stage / "RUNLOG.md").write_text(f"# Research Daily Run Log — {day}\n\n- {now()}: initialized structured workflow{legacy_note}\n", encoding="utf-8")
    write_status(stage, state, "READY")
    print("INITIALIZED")


def validate_candidate(day: str, topic: str, candidate: dict) -> None:
    if set(candidate) - {"result", "reason", "request_count", "search_query", "searched_urls", "title", "published_date", "source_url", "content_type", "score", "summary", "key_value", "practical_impact", "details", "organization", "slug"}:
        fail("candidate has unsupported fields")
    request_count = candidate.get("request_count")
    if not isinstance(request_count, int) or not 1 <= request_count <= 2:
        fail("request_count must be an integer from 1 to 2")
    if candidate.get("result") == "gap":
        if not isinstance(candidate.get("reason"), str) or not candidate["reason"].strip():
            fail("gap requires a non-empty reason")
        if "測試" in candidate["reason"] or "test" in candidate["reason"].lower():
            fail("gap reason must not contain test data")
        if not isinstance(candidate.get("search_query"), str) or not candidate["search_query"].strip():
            fail("gap requires the executed search_query")
        urls = candidate.get("searched_urls")
        if not isinstance(urls, list) or not urls or not all(isinstance(url, str) and urlparse(url).scheme in {"http", "https"} and urlparse(url).netloc for url in urls):
            fail("gap requires one or more searched_urls")
        return
    if candidate.get("result") != "accepted":
        fail("candidate result must be accepted or gap")
    required = ("title", "published_date", "source_url", "content_type", "summary", "key_value", "practical_impact")
    if any(not isinstance(candidate.get(field), str) or not candidate[field].strip() for field in required):
        fail("accepted candidate is missing a required text field")
    if candidate["content_type"] not in TYPES:
        fail(f"unsupported content_type: {candidate['content_type']}")
    try:
        published = date.fromisoformat(candidate["published_date"])
    except ValueError:
        fail("published_date must be YYYY-MM-DD")
    age = (date.fromisoformat(day) - published).days
    if not 0 <= age <= 183:
        fail("published_date must be within the previous 183 days")
    parsed = urlparse(candidate["source_url"])
    if parsed.scheme not in {"http", "https"} or not parsed.netloc:
        fail("source_url must be an absolute HTTP(S) URL")
    score = candidate.get("score", 0)
    if not isinstance(score, (int, float)) or not 1 <= score <= 5:
        fail("score must be a number from 1 to 5")
    if candidate.get("slug") and not re.fullmatch(r"[A-Za-z0-9][A-Za-z0-9._-]*", candidate["slug"]):
        fail("slug contains unsupported characters")


def record(day: str, topic: str, candidate_file: Path) -> None:
    if topic not in TOPIC_NAMES:
        fail(f"unknown topic: {topic}")
    stage = stage_for(day)
    state = load_state(stage)
    try:
        candidate = json.loads(candidate_file.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        fail(f"cannot read candidate JSON: {exc}")
    if not isinstance(candidate, dict):
        fail("candidate must be a JSON object")
    validate_candidate(day, topic, candidate)
    request_count = candidate["request_count"]
    existing = state["topics"][topic]
    if existing["result"] != "pending":
        if existing.get("digest") == hashlib.sha256(json.dumps(candidate, ensure_ascii=False, sort_keys=True).encode()).hexdigest():
            print("ALREADY_RECORDED")
            return
        fail(f"topic already finalized: {topic}")
    if state["request_budget"]["used"] + request_count > state["request_budget"]["limit"]:
        fail("request budget exceeded")
    digest = hashlib.sha256(json.dumps(candidate, ensure_ascii=False, sort_keys=True).encode()).hexdigest()
    checkpoint = {"schema_version": 1, "topic": topic, "recorded_at": now(), "digest": digest, "candidate": candidate}
    write_json(stage / "checkpoints" / f"{list(TOPIC_NAMES).index(topic) + 1:02d}-{topic}.json", checkpoint)
    state["topics"][topic] = {"name": TOPIC_NAMES[topic], "result": candidate["result"], "digest": digest, "checkpoint": str((stage / "checkpoints" / f"{list(TOPIC_NAMES).index(topic) + 1:02d}-{topic}.json").relative_to(stage))}
    state["request_budget"]["used"] += request_count
    save(stage, state)
    append_log(stage, f"checkpointed {topic}: {candidate['result']}; requests={request_count}")
    write_status(stage, state, "RESEARCHING")
    print("CHECKPOINT_SAVED")


def slug_for(candidate: dict) -> str:
    if candidate.get("slug"):
        return candidate["slug"]
    result = re.sub(r"[^A-Za-z0-9]+", "-", candidate["title"]).strip("-")
    return result[:96] or hashlib.sha256(candidate["title"].encode()).hexdigest()[:16]


def candidate_for(stage: Path, topic: str) -> dict:
    check = json.loads((stage / "checkpoints" / f"{list(TOPIC_NAMES).index(topic) + 1:02d}-{topic}.json").read_text(encoding="utf-8"))
    return check["candidate"]


def render_page(day: str, topic: str, candidate: dict, target: Path) -> None:
    folder, page_type, tag = TYPES[candidate["content_type"]]
    title = candidate["title"].replace('"', "'")
    details = candidate.get("details", "") or candidate["summary"]
    org = candidate.get("organization", "未於主要來源明示")
    text = f'''---
title: "{title}"
type: {page_type}
research_topic: "{TOPIC_NAMES[topic]}"
published_date: "{candidate['published_date']}"
organization: "{org}"
source_url: "{candidate['source_url']}"
date_collected: "{day}"
date_updated: "{day}"
tags:
  - ai
  - {tag}
---

# {candidate['title']}

## 基本資訊

- 發布日期：{candidate['published_date']}
- 研究主題：{TOPIC_NAMES[topic]}
- 主要來源：{candidate['source_url']}

## 概要

{candidate['summary']}

## 核心價值

{candidate['key_value']}

## 應用情境與實務影響

{candidate['practical_impact']}

## 補充細節

{details}

## 維護紀錄

- 收錄日期：{day}
- 最後更新：{day}
'''
    target.write_text(text, encoding="utf-8")


def render(day: str) -> None:
    stage = stage_for(day)
    state = load_state(stage)
    if state["final"]["status"] == "COMPLETED":
        print("ALREADY_COMPLETED")
        return
    pending = [key for key, value in state["topics"].items() if value["result"] == "pending"]
    if pending:
        fail("cannot render while topics are pending: " + ", ".join(pending))
    accepted = []
    sections = []
    gaps = []
    for topic, heading in TOPICS:
        candidate = candidate_for(stage, topic)
        if candidate["result"] == "gap":
            gaps.append(f"- {TOPIC_NAMES[topic]}：{candidate['reason']}")
            sections.append(f"## {heading}\n\n> 今日未找到符合日期、來源品質、技術內容與去重要求的項目。\n\n原因：{candidate['reason']}")
            continue
        folder, _, _ = TYPES[candidate["content_type"]]
        slug = slug_for(candidate)
        render_page(day, topic, candidate, stage / folder / f"{slug}.md")
        age = (date.fromisoformat(day) - date.fromisoformat(candidate["published_date"])).days
        label = {"paper": "研究成果 / Research", "report": "研究成果 / Research", "tool": "工具與專案 / Tools & Projects", "project": "工具與專案 / Tools & Projects", "technical-development": "技術動態與落地 / Technical Developments & Applications", "application": "技術動態與落地 / Technical Developments & Applications"}[candidate["content_type"]]
        sections.append(f'''## {heading}

### {candidate['title']}

- 🗂 內容類型：{label}
- 📅 發布日期：{candidate['published_date']}
- 🕒 收錄時距發布：{age} 天
- 🔗 主要來源：{candidate['source_url']}
- 📊 綜合評分（AI 判斷）：{candidate['score']:.1f} / 5
- 🧠 內容摘要：{candidate['summary']}
- 📌 核心價值：{candidate['key_value']}
- 🌍 應用情境與實務影響：{candidate['practical_impact']}
- 🗂 知識庫連結：[[{folder}/{slug}]]''')
        accepted.append(f"[[{folder}/{slug}]]")
    status = "COMPLETED" if len(accepted) == 6 else "COMPLETED_WITH_GAP"
    summary = f"今日完成六個固定主題的研究整理，收錄 {len(accepted)} 個通過來源、日期與重複檢查的項目。"
    daily = f'''---
title: "{day} AI Research Daily"
type: daily
date: "{day}"
status: "{status}"
item_count: "{len(accepted)}"
date_created: "{day}"
tags:
  - ai
  - research-daily
---

# {day} AI Research Daily

## 今日總結

{summary}

{chr(10).join(sections)}

## 跨領域洞察

本日內容以可驗證來源為準；跨領域比較僅限於各主題已記錄的事實。

## 行動建議

- 依主要來源檢視原始材料，再決定是否納入後續研究或實作。

## 今日新增檔案

{chr(10).join('- ' + item for item in accepted) if accepted else '- 無'}

## 今日更新檔案

- 無
'''
    (stage / "Daily" / f"{day}.md").write_text(daily, encoding="utf-8")
    rejected = stage / "rejected-items.md"
    if gaps:
        rejected.write_text("# Rejected Items\n\n" + "\n".join(gaps) + "\n", encoding="utf-8")
    elif rejected.exists():
        rejected.unlink()
    state["render"] = {"status": "RENDERED", "at": now(), "daily": f"Daily/{day}.md"}
    save(stage, state)
    append_log(stage, "rendered Markdown from checkpoints")
    write_status(stage, state, "RENDERED")
    print("RENDERED")


def validate(day: str) -> None:
    stage = stage_for(day)
    state = load_state(stage)
    if state["date"] != day or state.get("schema_version") != 1:
        fail("state date or schema mismatch")
    results = [state["topics"][key]["result"] for key, _ in TOPICS]
    if any(result not in {"accepted", "gap"} for result in results):
        fail("each fixed topic must have exactly one accepted or gap result")
    if state["request_budget"]["used"] > state["request_budget"]["limit"]:
        fail("request budget exceeded")
    if state["render"].get("status") != "RENDERED" or not (stage / "Daily" / f"{day}.md").is_file():
        fail("Markdown has not been rendered")
    for topic, _ in TOPICS:
        candidate = candidate_for(stage, topic)
        validate_candidate(day, topic, candidate)
    print("STRUCTURED_VALIDATION_OK")


def verify_remote(state: dict) -> None:
    commit = state.get("final", {}).get("commit")
    if not commit:
        fail("completed state missing commit")
    result = subprocess.run(["git", "ls-remote", "origin", "refs/heads/v5"], cwd=GARDEN, capture_output=True, text=True)
    remote = result.stdout.split()[0] if result.returncode == 0 and result.stdout.split() else ""
    if remote != commit:
        fail("remote v5 HEAD does not match recorded completion commit")


def finalize(day: str, commit: str) -> None:
    if not re.fullmatch(r"[0-9a-f]{40}", commit):
        fail("commit must be a full SHA-1")
    stage = stage_for(day)
    state = load_state(stage)
    validate(day)
    state["final"] = {"status": "COMPLETED", "commit": commit, "completed_at": now()}
    verify_remote(state)
    save(stage, state)
    append_log(stage, f"remote verified and completed: {commit}")
    write_status(stage, state, "COMPLETED")
    print("FINAL_STATUS_COMPLETED")


def mark_failed(day: str, reason: str) -> None:
    if not reason.strip():
        fail("failure reason is required")
    stage = stage_for(day)
    state = load_state(stage)
    if state["final"].get("status") == "COMPLETED":
        fail("cannot mark a completed workflow as failed")
    state["final"] = {"status": "FAILED", "reason": reason.strip(), "failed_at": now()}
    save(stage, state)
    append_log(stage, f"workflow failure recorded: {reason.strip()}")
    write_status(stage, state, "FAILED")
    print("FINAL_STATUS_FAILED")


def write_status(stage: Path, state: dict, status: str) -> None:
    outcomes = {key: value["result"] for key, value in state["topics"].items()}
    text = "\n".join((f"status: {status}", f"date: {state['date']}", f"updated_at: {now()}", f"request_budget: {state['request_budget']['used']}/{state['request_budget']['limit']}", "topics:") + tuple(f"  {key}: {value}" for key, value in outcomes.items()) + (f"final: {state['final']['status']}", ""))
    (stage / "STATUS.md").write_text(text, encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("command", choices=("init", "record", "render", "validate", "finalize", "fail"))
    parser.add_argument("--date", default=date.today().isoformat())
    parser.add_argument("--topic")
    parser.add_argument("--candidate")
    parser.add_argument("--commit")
    parser.add_argument("--reason")
    args = parser.parse_args()
    if args.command == "init": init(args.date)
    elif args.command == "record":
        if not args.topic or not args.candidate: fail("record requires --topic and --candidate")
        record(args.date, args.topic, Path(args.candidate))
    elif args.command == "render": render(args.date)
    elif args.command == "validate": validate(args.date)
    elif args.command == "finalize":
        if not args.commit: fail("finalize requires --commit")
        finalize(args.date, args.commit)
    else:
        if not args.reason: fail("fail requires --reason")
        mark_failed(args.date, args.reason)


if __name__ == "__main__":
    main()
