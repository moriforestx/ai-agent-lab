---
type: concept
title: "RAG vs Long Context (檢索增強生成 vs 長上下文)"
date_updated: "2026-07-10"
tags:
  - concept
  - llm
  - architecture
---

# RAG vs Long Context

## 核心權衡

| 維度 | RAG | Long Context |
|------|-----|--------------|
| **成本** | 低 (固定檢索+短上下文) | 高 (完整上下文計算) |
| **精度** | 依賴檢索質量 | 原生理解全文 |
| **更新** | 即時 (更新索引) | 需重新預訓練/微調 |
| **隱私** | 數據留在向量庫 | 需餵入模型上下文 |
| **延遲** | 兩階段 (檢索+生成) | 單階段但 TTFT 高 |
| **幻覺** | 可溯源到檢索片段 | 整體生成難溯源 |

## 2026 共識：**混合架構**

```
用戶查詢
    ↓
意圖分類 → 短查詢? → RAG (低成本)
           ↓
      長查詢/需推理? → Long Context (高精度)
           ↓
      複雜推理? → RAG + Long Context 混合
```

## 混合策略

1. **RAG 預檢索 → Long Context 推理**：檢索 Top-K → 拼接為長上下文餵入長模型
2. **Long Context 壓縮 → RAG 索引**：長文檔壓縮摘要建索引，查詢時檢索摘要
3. **Agent 級選擇**：Agent 根據任務類型動態選擇

## 為什麼重要

單一技術無法覆蓋所有場景。混合架構是生產級 LLM 應用的標配。

## 出現在哪些內容

- [[LIFT_Long_Input_Fine_Tuning]] (Papers)
- [[Long_Context_LLM]] (Concepts)
- [[Context_Compression]] (Concepts)
- [[Long_Input_Fine_Tuning_LIFT]] (Concepts)
- [[Knowledge_Distillation]] (Concepts)

## 相關概念

- [[RAG_Retrieval_Augmented_Generation]]
- [[Long_Context_Window]]
- [[Parameter_Efficient_Fine_Tuning]]
- [[Knowledge_Distillation]]

## 更新紀錄

- 2026-07-10：首次建立。
