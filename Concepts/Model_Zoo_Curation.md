---
type: concept
title: "Model Zoo Curation (模型庫策展與管理)"
date_updated: "2026-07-10"
tags:
  - concept
  - mlops
  - management
---

# Model Zoo Curation

## 定義

系統化收集、評估、版本管理、部署優化開源/自訓練模型的工程實踐。不只是「存模型」，而是建立可信、可用、可演進的模型資產庫。

## 核心能力

1. **發現與評估**：自動追蹤 Hugging Face Trending、Papers with Code、GitHub Trending
2. **基準測試**：統一基準 (MMLU, HumanEval, GSM8K, 專有業務基準) 定期跑分
3. **版本管理**：模型卡片、訓練配置、數據血統、檢查點版本
4. **部署優化**：量化 (AWQ, GPTQ, GGUF)、蒸餾、編譯 (TensorRT, ONNX Runtime)
5. **治理與合規**：授權檢查、偏見評估、安全紅隊、EU AI Act 對齊

## 2026 工具鏈

- **註冊表**：MLflow, Weights & Biases, ClearML, Hugging Face Hub (Enterprise)
- **基準**：Open LLM Leaderboard v2, LMSYS Chatbot Arena, 自建評測管線
- **部署**：vLLM, TGI, SGLang, Ollama, LM Studio
- **量化**：AutoAWQ, AutoGPTQ, llama.cpp (GGUF), Calibre

## 為什麼重要

開源模型爆發式增長 (每週 100+ 新模型)。無策展 = 無法決策選型、無法合規、無法複現。

## 出現在哪些內容

- [[audio-ai-hub]] (Projects)
- [[LLM_Tools_Ecosystem]] (Concepts)
- [[Open_Source_ASR]] (Concepts)
- [[Open_Source_Speech_Models]] (Concepts)

## 相關概念

- [[Model_Card]]
- [[Benchmark_Automation]]
- [[Quantization]]
- [[LLM_Tools_Ecosystem]]

## 更新紀錄

- 2026-07-10：首次建立，基於 OSS Insight GitHub Trending AI 分析。
