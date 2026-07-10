---
type: concept
title: "RAG (Retrieval-Augmented Generation, 檢索增強生成)"
date_updated: "2026-07-10"
tags:
  - concept
  - llm
  - architecture
---

# RAG (Retrieval-Augmented Generation)

## 定義

結合資訊檢索與文本生成：先從知識庫檢索相關片段，再作為上下文餵給 LLM 生成答案。解決 LLM 知識截止、幻覺、私有數據不可用問題。

## 標準流程 (Naive RAG)

1. **索引構建**：文檔 → 切塊 → Embedding → 向量資料庫
2. **檢索**：查詢 → Embedding → 向量搜索 Top-K
3. **生成**：查詢 + Top-K 片段 → Prompt → LLM → 答案

## 2026 進階 RAG 技術棧

| 階段 | 技術 |
|------|------|
| **切塊** | 語義切塊、層級切塊、Agentic Chunking |
| **檢索** | 混合搜索 (稀疏+稠密)、重排序、查詢重寫、多跳檢索 |
| **生成** | 引用標註、自我修正、迭代生成 |
| **評估** | RAGAS, TruLens, DeepEval (忠實度、相關性、完整性) |

## 主流框架

- **LlamaIndex**：企業級、多模態、Agentic RAG
- **LangChain**：組件豐富、生態大
- **Haystack**：生產級、K8s 原生
- **RAGFlow**：文檔解析強、中文友好

## 為什麼重要

企業級 LLM 應用 90%+ 基於 RAG。是私有數據落地的標準路徑。

## 出現在哪些內容

- [[LIFT_Long_Input_Fine_Tuning]] (Papers)
- [[Long_Context_LLM]] (Concepts)
- [[RAG_vs_Long_Context]] (Concepts)
- [[Context_Compression]] (Concepts)
- [[Long_Input_Fine_Tuning_LIFT]] (Concepts)

## 相關概念

- [[Vector_Databases]]
- [[Embedding_Models]]
- [[Long_Context_Window]]
- [[Knowledge_Distillation]]

## 更新紀錄

- 2026-07-10：首次建立。
