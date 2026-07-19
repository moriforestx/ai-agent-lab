# AI Research Daily — Agent Contract

本文件供 OpenClaw `research-daily` Skill 執行。研究 Agent 僅負責搜尋、閱讀、摘要與候選判斷；不得自行產生正式 Markdown、判定發布成功或直接寫入 `AI-Research-Garden/content`。

## Entry point

```bash
ROOT=/home/local/AI-Agent-Lab
DATE="${1:-$(date +%F)}"
"$ROOT/Scripts/research-daily-preflight.sh" "$DATE"
```

若輸出為 `PREFLIGHT_ALREADY_COMPLETED`，回覆 `ALREADY_COMPLETED` 後停止。若為 `RESUME_READY`，只處理 `research-state.json` 中仍為 `pending` 的 topic。所有 state、checkpoint、Markdown 與 STATUS 均在 `.openclaw-stage/research-daily-$DATE/`。

## Fixed topics and request budget

依序處理以下六個 topic；每個恰有一個最終結果：`accepted` 或 `gap`。

1. `ai-general` — AI General
2. `computer-vision` — Computer Vision
3. `llm-nlp` — LLM & NLP
4. `audio-speech` — Audio & Speech
5. `ai-agents` — AI Agents
6. `ai-applications-deployment` — AI Applications & Deployment

總搜尋預算為 8。每 topic 先搜尋一次；結果無效時最多補搜一次。找不到可驗證候選時，立即記錄 `gap`，不得無限搜尋。使用 `web_search`（Tavily）並優先閱讀原始來源、官方頁面、正式論文或官方 repository。每個 accepted 項目都要有可驗證、精確到日的發布日期，且必須在當日往前 183 天內。

## Candidate JSON

每個 topic 完成後，將下列 JSON 寫入暫時檔，再立即呼叫 `record`；不可跳到下一 topic 才一起寫入。JSON 是唯一的研究 source of truth。

Accepted 範例：

```json
{
  "result": "accepted",
  "request_count": 1,
  "title": "正式標題",
  "published_date": "2026-07-19",
  "source_url": "https://example.org/source",
  "content_type": "paper",
  "score": 4.2,
  "summary": "根據來源的可驗證摘要。",
  "key_value": "核心價值。",
  "practical_impact": "適用情境或實務影響。",
  "details": "可選的補充細節。",
  "organization": "可選，來源明示的組織",
  "slug": "optional-stable-slug"
}
```

`content_type` 只能是 `paper`、`report`、`tool`、`project`、`technical-development` 或 `application`。所有自然語言必須使用臺灣繁體中文，且不得捏造事實。

Gap 範例：

```json
{"result":"gap","request_count":1,"reason":"已檢查原始來源；沒有同時符合日期、來源品質、技術內容與去重要求的候選。"}
```

儲存指令：

```bash
python3 "$ROOT/Scripts/research-daily-workflow.py" record \
  --date "$DATE" --topic "TOPIC_ID" --candidate /tmp/research-daily-TOPIC_ID.json
```

若指令輸出 `ALREADY_RECORDED`，該 checkpoint 已安全完成；不可改寫為不同結果。若驗證或搜尋失敗，仍以 `request_count: 0` 記錄帶原因的 `gap`，使 workflow 可恢復且六個 topic 狀態明確。

## Render and publish

六個 checkpoint 都完成後，只執行：

```bash
python3 "$ROOT/Scripts/research-daily-workflow.py" render --date "$DATE"
"$ROOT/Scripts/research-daily-validate-and-promote.sh" \
  "$ROOT/.openclaw-stage/research-daily-$DATE" "$DATE"
```

Python 會統一產生 Daily 與長期頁面。Bash 會執行結構化 JSON 驗證、既有 staging Markdown 驗證、promote、Quartz build、Git commit/push 與 remote v5 驗證。只有最後輸出 `PROMOTE_AND_PUSH_OK` 和 `FINAL_STATUS_COMPLETED` 才是成功；任何其他結果都保留 stage 供 resume。
