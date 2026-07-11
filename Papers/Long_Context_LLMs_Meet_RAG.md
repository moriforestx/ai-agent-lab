---
type: paper
title: "Long-Context LLMs Meet RAG: Overcoming Challenges for Long Inputs in RAG"
category: "LLM / NLP"
score: "5"
date_collected: "2026-07-11"
published_date: "2024-10"
source_url: "https://arxiv.org/html/2410.05983v1"
tags:
  - ai/paper
  - llm
  - rag
  - long-context
---

# Long-Context LLMs Meet RAG: Overcoming Challenges for Long Inputs in RAG

## 基本資訊

- 類別：LLM / NLP
- 日期：2024-10
- 新鮮度：3–6 個月
- Source：https://arxiv.org/html/2410.05983v1
- Score：5

## 摘要

系統性研究長上下文 LLM 在 RAG 中的表現：隨檢索段落增加，生成質量先升後降。提出三種魯棒性方案：(1) 訓練免費：檢索重排序 (2) 隱式微調：針對難負樣本魯棒性 (3) 顯式微調：中間推理識別相關性。並深入分析數據分布、檢索器選擇、訓練上下文長度等設計選擇。

## 核心重點

- 關鍵發現：長上下文 ≠ RAG 無限制受益，存在「更多檢索反而有害」現象
- 訓練免費方案：檢索重排序，零成本部署
- 隱式微調：增強對難負樣本 (hard negatives) 魯棒性
- 顯式微調：引入中間推理步驟判斷相關性
- 系統性消融：數據分布、檢索器、訓練長度對結果影響大

## 為什麼重要

長上下文 LLM (2M+ tokens) 與 RAG 關係的實證研究，打破「長上下文取代 RAG」迷思，給出生產級 RAG 系統具體優化路徑。

## 可能影響我

- Concepts/RAG_Retrieval_Augmented_Generation.md 需整合三種魯棒性方案
- Concepts/Long_Context_LLM.md、Long_Context_Window.md、RAG_vs_Long_Context.md 需更新
- LIFT_Framework.md 相關長輸入微調技術可參考

## 相關概念

- [[RAG_Retrieval_Augmented_Generation]]
- [[Long_Context_LLM]]
- [[Long_Context_Window]]
- [[RAG_vs_Long_Context]]
- [[LIFT_Framework]]

## 更新紀錄

- 2026-07-11：首次收錄。
