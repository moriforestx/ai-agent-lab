---
type: concept
title: "Benchmark Automation (基準測試自動化)"
date_updated: "2026-07-10"
tags:
  - concept
  - mlops
  - evaluation
---

# Benchmark Automation

## 定義

將模型評估標準化、自動化、持續化：從數據準備、推理執行、指標計算到報告生成全流程無人值守，支援 CI/CD 整合與定時排程。

## 自動化管線架構

```
排程觸發 (每日/每周/新模型發布)
    ↓
模型發現 (HF Hub API, GitHub Releases, 內部註冊表)
    ↓
環境準備 (容器化、量化編譯、依賴鎖定)
    ↓
基準執行 (並行多 GPU、批次推理、快取複用)
    ↓
指標計算 (準確率、延遲 P50/P99、吞吐、顯存、成本)
    ↓
結果存儲 (時序資料庫、向量檢索、歷史對比)
    ↓
報告與告警 (Dashboard、Slack/Telegram、回歸檢測)
```

## 核心基準套件 (2026)

| 領域 | 基準 |
|------|------|
| 通用推理 | MMLU-Pro, GPQA, MATH, HumanEval+ |
| 指令遵循 | IFEval, MT-Bench, WildBench |
| 代碼 | SWE-bench, LiveCodeBench, CodeContests |
| 長上下文 | RULER, NeedleInHaystack, LongBench |
| Agent | τ-bench, AgentBench, WebShop |
| 語音 | LibriSpeech, GigaSpeech, CommonVoice |
| 多模態 | MMMU, MathVista, ChartQA |
| 安全 | RedTeaming, HarmBench, AIR-Bench |

## 工具鏈

- **評測框架**：lm-evaluation-harness, LightEval, OpenCompass, FlagEval
- **推理引擎**：vLLM (高吞吐), SGLang (長上下文), TGI (生產)
- **編排**：Airflow, Prefect, Temporal, GitHub Actions
- **可視化**：Grafana, LangSmith, Weave, MLflow

## 為什麼重要

模型選型不靠「感覺」靠「數據」。自動化讓每次決策都有據可查、可回溯、可複現。

## 出現在哪些內容

- [[audio-ai-hub]] (Projects)
- [[Model_Zoo_Curation]] (Concepts)
- [[LLM_Tools_Ecosystem]] (Concepts)

## 相關概念

- [[Model_Card]]
- [[CI_CD_ML]]
- [[Quantization]]
- [[Inference_Engines]]

## 更新紀錄

- 2026-07-10：首次建立。
