---
type: concept
title: "Long Context LLM (長上下文大語言模型)"
date_updated: "2026-07-10"
tags:
  - concept
  - llm
  - architecture
---

# Long Context LLM

## 定義

原生支援超長上下文窗口 (32k-10M+ tokens) 的大語言模型，通過位置編碼改進、注意力優化、架構創新實現。

## 2026 產業全景

| 模型 | Context Window | 架構特色 | 可用性 |
|------|---------------|----------|--------|
| **Gemini 1.5 Pro** | **2M** | MoE + 深度 U-Net 注意力 | API |
| **Magic LTM-2** | **100M** | 線性注意力 + 記憶模組 | 研究 |
| **Llama 3.1** | 128k | RoPE 延展 (YaRN) + 長文繼訓 | 開源 |
| **Qwen2.5** | 128k | YaRN + 長文數據 | 開源 |
| **Nemotron 4 340B** | 128k | 合成數據 + 並行訓練 | 開源權重 |
| **GLM-4** | 128k | 部分 RoPE + 線性注意力混合 | 開源 |
| **Yi-1.5** | 200k | 動態 NTK + 插值 | 開源 |

## 技術路線圖

1. **RoPE 延展**：NTK-aware, YaRN, LongRoPE, Self-Extend
2. **線性注意力**：RWKV, Mamba, Griffin, H3, Based, Linear Transformer
3. **稀疏/分塊注意力**：BigBird, Longformer, Ring Attention, FlashAttention-3
4. **外部記憶**：Memory Layers, Titans, Infini-attention, Compressive Memory
5. **蒸餾/微調**：LIFT, LongLoRA, Short-to-Long

## 評測基準

- **RULER**：合成任務 (NIAH, VT, FWE, CWE)
- **LongBench**：真實長文任務
- **NeedleInHaystack**：檢索準確率
- **∞-Bench**：100k+ 實際場景

## 為什麼重要

長上下文 = 代碼庫級推理、完整文檔理解、多輪對話記憶、少樣本學習替代微調。

## 出現在哪些內容

- [[LIFT_Long_Input_Fine_Tuning]] (Papers)
- [[Long_Input_Fine_Tuning_LIFT]] (Concepts)
- [[Long_Context_Window]] (Concepts)
- [[RAG_vs_Long_Context]] (Concepts)
- [[Context_Compression]] (Concepts)

## 相關概念

- [[Parameter_Efficient_Fine_Tuning]]
- [[Knowledge_Distillation]]
- [[RAG_Retrieval_Augmented_Generation]]

## 更新紀錄

- 2026-07-10：首次建立。
