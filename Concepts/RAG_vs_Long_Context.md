---
type: concept
name: "RAG vs Long Context"
date_updated: "2026-07-10"
tags:
  - concept
---

# RAG vs Long Context

## 定義

長文檔處理的三大路徑對比：(1) RAG - 外部檢索增強；(2) 原生長上下文模型 - 注意力機制處理長序列；(3) LIFT 等參數內化知識方案。

## 三路徑對比

| 維度 | RAG | 原生長上下文 | LIFT 微調 |
|------|-----|--------------|-----------|
| 推理延遲 | 低 (檢索+短上下文) | 高 (O(n²) 注意力) | 低 (固定上下文) |
| 知識更新 | 即時 (更新索引) | 需重新訓練/微調 | 需重新微調 |
| 部署成本 | 中 (向量資料庫) | 高 (長上下文模型) | 低 (微調後模型) |
| 幻覺風險 | 低 (有來源) | 中 | 中 |

## 為什麼重要

2026 年三足鼎立，選型取決於業務場景：知識頻繁更新用 RAG、固定長文檔用長上下文、資源受限用 LIFT。

## 出現在哪些內容

- [[LIFT_Long_Input_Fine_Tuning]]
- [[Long_Input_Fine_Tuning_LIFT]]

## 相關概念

- [[RAG_Retrieval_Augmented_Generation]]
- [[Long_Context_LLM]]
- [[Context_Compression]]

## 更新紀錄

- 2026-07-10：首次收錄。
