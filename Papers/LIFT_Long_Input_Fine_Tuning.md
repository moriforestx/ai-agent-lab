---
type: paper
title: "LIFT: Long Input Fine-Tuning for Long-Context Understanding"
category: "LLM / NLP"
score: "8"
date_collected: "2026-07-10"
published_date: "2026-02-14"
source_url: "https://arxiv.org/html/2502.14644v4"
tags:
  - ai/paper
---

# LIFT: Long Input Fine-Tuning for Long-Context Understanding

## 基本資訊

- 類別：LLM / NLP
- 日期：2026-02-14
- 新鮮度：3–6 個月
- Source：https://arxiv.org/html/2502.14644v4
- Score：8

## 摘要

LIFT 框架透過長輸入微調，將任意長度輸入的知識直接編碼進模型參數中，使短上下文 LLM 獲得長上下文理解能力，同時避免注意力機制的二次計算複雜度。優化管線包含動態參數適配、梯度檢查點、記憶體高效注意力，實現 8k 上下文 <10s TTFT。推理階段無需提供長上下文即可回答問題，大幅降低部署成本。

## 核心重點

- 長輸入微調：將長序列知識蒸餾進模型權重
- 避免 O(n²) 注意力：推理時計算量與上下文長度無關
- 任意短上下文模型適用：可升級現有模型資產
- 優化管線：TTFT <10s (8k context)，記憶體效率高
- 推理零上下文：模型內化長文檔知識，直接作答

## 為什麼重要

為長上下文 LLM 部署提供第三條路徑 (除 RAG 與原生長上下文模型外)，特別適合資源受限環境與現有模型遷移場景。

## 可能影響我

Agent Lab 可低成本將現有模型擴展至長上下文任務 (代碼庫分析、長文檔問答、法規合規檢查)，無需重新訓練或採用昂貴的長上下文模型。

## 相關概念

- [[Long_Input_Fine_Tuning_LIFT]]
- [[Long_Context_LLM]]
- [[Parameter_Efficient_Fine_Tuning]]
- [[RAG_vs_Long_Context]]

## 更新紀錄

- 2026-07-10：首次收錄。
