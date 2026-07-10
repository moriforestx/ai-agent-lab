---
type: concept
title: "Knowledge Distillation (知識蒸餾)"
date_updated: "2026-07-10"
tags:
  - concept
  - llm
  - optimization
---

# Knowledge Distillation

## 定義

將大模型 (Teacher) 的知識轉移到小模型 (Student) 的技術。核心思想：Student 學習 Teacher 的輸出分布 (Soft Labels) 而非硬標籤。

## 主流方法

1. **Logits Matching**：最小化 KL 散度 (Hinton et al. 2015)
2. **中間層蒸餾**：特徵圖對齊 (FitNets, PKD)
3. **資料蒸餾**：Teacher 生成合成數據訓練 Student
4. **LLM 專用**：Reverse KD、MiniLLM、GKD、LLM-KD

## LLM 時代關鍵應用

- **模型壓縮**：Llama-3.1-405B → 8B/70B 部署版
- **長上下文蒸餾**：長模型 → 短模型 (LIFT 相關)
- **推理蒸餾**：CoT 邏輯蒸餾到小模型
- **領域適配**：通用大模型 → 垂直領域小模型

## 為什麼重要

大模型推理成本高、延遲大。蒸餾讓小模型接近大模型性能，實現邊緣部署、私有化部署、低成本服務。

## 出現在哪些內容

- [[Long_Input_Fine_Tuning_LIFT]] (Concepts)
- [[LIFT_Framework]] (Concepts)
- [[Parameter_Efficient_Fine_Tuning]] (Concepts)
- [[Long_Context_LLM]] (Concepts)

## 相關概念

- [[Parameter_Efficient_Fine_Tuning]]
- [[Model_Compression]]
- [[Quantization]]
- [[RAG_vs_Long_Context]]

## 更新紀錄

- 2026-07-10：首次建立。
