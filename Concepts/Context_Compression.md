---
type: concept
title: "Context Compression (上下文壓縮)"
date_updated: "2026-07-10"
tags:
  - concept
  - llm
  - optimization
---

# Context Compression

## 定義

在不損失關鍵資訊前提下，減少輸入上下文 Token 數量的技術。目標：降低推理成本、突破 Context Window 限制、提升長文檔處理效率。

## 主流方法

1. **摘要式壓縮**：LLM 生成摘要替換原文 (LLMLingua, LongLLMLingua)
2. **Token 級剪枝**：移除低重要性 Token (Selective Context, Contextual Compression)
3. **語義壓縮**：將文本映射為稠密向量/概念 (AutoCompressor, Gist)
4. **檢索增強壓縮**：RAG + 壓縮混合 (Raptor, RECOMP)

## 關鍵指標

- 壓縮比：2x-20x 常見
- 保真度：下游任務性能下降 <5%
- 延遲：壓縮本身需 <100ms

## 為什麼重要

單次推理成本 ∝ Context Length² (注意力) 或 ∝ Context Length (線性注意力)。壓縮直接降本增效。

## 出現在哪些內容

- [[RAG_vs_Long_Context]] (Concepts)
- [[Long_Context_LLM]] (Concepts)
- [[RAG_Retrieval_Augmented_Generation]] (Concepts)

## 相關概念

- [[Long_Context_Window]]
- [[Knowledge_Distillation]]
- [[RAG_Retrieval_Augmented_Generation]]

## 更新紀錄

- 2026-07-10：首次建立。
