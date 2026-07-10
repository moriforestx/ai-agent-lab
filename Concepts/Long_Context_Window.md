---
type: concept
title: "Long Context Window (長上下文窗口技術)"
date_updated: "2026-07-10"
tags:
  - concept
  - llm
  - architecture
---

# Long Context Window

## 定義

模型單次前向傳播可處理的最大 Token 數量。決定了模型能「一次看多少」內容，直接影響 RAG 需求、Agent 記憶深度、代碼庫理解能力。

## 發展里程碑

- 2023: 4k (GPT-3.5, Llama 2)
- 2024 Q1: 32k (GPT-4 Turbo, Claude 3)
- 2024 Q3: 128k (Llama 3.1, Qwen 2.5, GLM-4)
- 2025: 1M-2M (Gemini 1.5, Magic LTM-2)
- 2026: 10M+ (研究階段，Infini-attention, Titans)

## 關鍵技術

1. **RoPE 延展**：YaRN (NTK-aware), LongRoPE, PI (Position Interpolation)
2. **稀疏/線性注意力**：FlashAttention-3, Ring Attention, Mamba/SSM, RWKV-7
3. **記憶機制**：Memory Layers (Titans), Compressive Memory (Infini-attention)
4. **分層處理**：Chunk-level + Global-level (Gemini 1.5)

## 挑戰

- 二次複雜度 O(n²) 記憶體/計算爆炸
- 長距離依賴建模困難 (Lost in the Middle)
- 訓練數據稀缺 (高質量長文本)
- 推理延遲 (TTFT 隨 Context 線性增長)

## 為什麼重要

Context Window 是 LLM 應用的硬約束。突破它意味著：少做 RAG、長記憶 Agent、全代碼庫推理。

## 出現在哪些內容

- [[Long_Context_LLM]] (Concepts)
- [[Context_Compression]] (Concepts)
- [[RAG_vs_Long_Context]] (Concepts)
- [[LIFT_Framework]] (Concepts)

## 相關概念

- [[Context_Compression]]
- [[Long_Context_LLM]]
- [[Knowledge_Distillation]]
- [[Parameter_Efficient_Fine_Tuning]]

## 更新紀錄

- 2026-07-10：首次建立。
