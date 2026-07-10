---
type: concept
title: "LIFT Framework (Long Input Fine-Tuning)"
date_updated: "2026-07-10"
tags:
  - concept
  - llm
  - fine-tuning
---

# LIFT Framework

## 定義

LIFT (Long Input Fine-Tuning) 是一種將任意短上下文 LLM（如 Llama-3.1-8B 4k context）透過微調擴展為長上下文模型（32k-128k+）的框架，由 Meta/學術界提出 (arXiv:2502.14644)。

## 核心創新

1. **長輸入構建**：從短文檔合成長輸入樣本（拼接、重複、插入噪聲）
2. **損失函數設計**：結合 Next-Token Prediction 與長距離依賴預測目標
3. **高效微調**：僅需 <10B tokens、單機 8xA100 <1 天完成
4. **推理零開銷**：微調後模型無需額外機制即可處理長上下文

## 關鍵指標

- TTFT (Time to First Token) <10s @ 8k context
- 無需推理時提供上下文（參數內化知識）
- 適用 Llama、Mistral、Qwen 等主流架構

## 為什麼重要

解決「原生長上下文模型訓練成本高、推理慢、記憶體大」三大痛點，提供低成本升級路徑。

## 出現在哪些內容

- [[LIFT_Long_Input_Fine_Tuning]] (Papers)
- [[Long_Input_Fine_Tuning_LIFT]] (Concepts)
- [[Long_Context_LLM]] (Concepts)
- [[Parameter_Efficient_Fine_Tuning]] (Concepts)

## 相關概念

- [[Long_Context_Window]]
- [[RAG_vs_Long_Context]]
- [[Knowledge_Distillation]]
- [[RAG_Retrieval_Augmented_Generation]]

## 更新紀錄

- 2026-07-10：首次建立，基於 arXiv:2502.14644v4。
