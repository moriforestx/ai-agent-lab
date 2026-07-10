---
type: concept
title: "Parameter-Efficient Fine-Tuning (PEFT: 參數高效微調)"
date_updated: "2026-07-10"
tags:
  - concept
  - llm
  - optimization
---

# Parameter-Efficient Fine-Tuning (PEFT)

## 定義

凍結預訓練模型大部分參數，僅訓練少量新增/適配參數 (通常 <1%)，以極低成本適配下游任務。

## 主流方法對比 (2026)

| 方法 | 可訓練參數 | 存儲開銷 | 推理延遲 | 適用場景 |
|------|-----------|----------|----------|----------|
| **LoRA** | 0.1-1% | 低 (合併後無) | 無 | 通用首選 |
| **QLoRA** | 0.1-1% | 極低 (4bit) | 無 | 顯存受限 |
| **AdaLoRA** | 動態 | 低 | 無 | 參數預算固定 |
| **Adapter** | 0.5-2% | 低 (獨立) | +1 層 | 多任務切換 |
| **Prefix/Prompt Tuning** | 0.01% | 極低 | +前綴 | 凍結 Backbone |
| **LoRA+PEFT** | 混合 | 低 | 無 | 極致壓縮 |
| **Full Fine-Tuning** | 100% | 高 | 無 | 最大性能 |

## 2026 進展

- **LoRA 融合部署**：訓練後合併權重，推理零開銷
- **多 LoRA 服務**：vLLM/SGLang 支援單模型載入多 LoRA 適配器
- **長上下文 PEFT**：LongLoRA (Shifted Attention) 近似)、LIFT (長輸入微調)
- **MoE 專家微調**：僅訓練 Router + 部分 Expert

## 選型指南

| 條件 | 推薦 |
|------|------|
| 單卡 24GB 微調 7B | QLoRA (r=64, alpha=128) |
| 多卡 80GB 微調 70B | LoRA + FSDP / DeepSpeed ZeRO-3 |
| 需頻繁切換任務 | Adapter / Multi-LoRA serving |
| 極致成本敏感 | Prompt Tuning + 少樣本 |
| 追求最佳性能 | Full FT (如資源允許) |

## 為什麼重要

讓中小團隊用消費級/單張專業卡微調 SOTA 模型，實現「大模型能力、小模型成本」。

## 出現在哪些內容

- [[Long_Input_Fine_Tuning_LIFT]] (Concepts)
- [[LIFT_Long_Input_Fine_Tuning]] (Papers)
- [[Knowledge_Distillation]] (Concepts)
- [[Long_Context_LLM]] (Concepts)
- [[LLM_Tools_Ecosystem]] (Concepts)

## 相關概念

- [[LoRA]]
- [[QLoRA]]
- [[Adapter_Tuning]]
- [[Full_Fine_Tuning]]
- [[Knowledge_Distillation]]

## 更新紀錄

- 2026-07-10：首次建立。
