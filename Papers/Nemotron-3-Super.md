---
type: paper
title: "Nemotron 3 Super: Open, Efficient Mixture-of-Experts Hybrid Mamba-Transformer Model for Agentic Reasoning"
category: "LLM / NLP"
score: "5"
date_collected: "2026-07-11"
published_date: "2026-04"
source_url: "https://arxiv.org/abs/2604.12374"
tags:
  - ai/paper
---

# Nemotron 3 Super: Open, Efficient Mixture-of-Experts Hybrid Mamba-Transformer Model for Agentic Reasoning

## 基本資訊

- 類別：LLM / NLP
- 日期：2026-04
- 新鮮度：3–6 個月
- Source：https://arxiv.org/abs/2604.12374
- Score：5

## 摘要

NVIDIA 發布 Nemotron 3 Super，120B 參數開源 Mixture-of-Experts 模型，採用混合 Mamba-Transformer 架構：Mamba 狀態空間層處理長序列線性複雜度，Transformer 注意力層保持表達能力。專為 Agentic Reasoning 優化，在 SWE-Bench Verified 達 60.47%，超越同參數級專有模型。同期發布 Mamba-3 (arXiv:2603.15569) 進一步改進序列建模。

## 核心重點

- 混合架構：Mamba 線性注意力 + Transformer 稀疏注意力
- MoE 結構：專家路由機制降低推理計算量
- Agentic Reasoning 導向：工具使用、規劃、多步推理基準優化
- 開源權重：商業友善授權，支援本地部署與微調

## 為什麼重要

混合架構解決長文本推理記憶體瓶頸，MoE 提升參數效率，為本地部署大模型提供可行路徑。Agent 任務專項優化填補開源模型在工具使用、規劃能力上的缺口。

## 可能影響我

AI Agent Lab 本地模型部署可評估 Nemotron 3 Super 作為推理引擎；混合架構設計原則可應用於自訂模型訓練；Agentic Reasoning 基準提供評測標準。

## 相關概念

- [[Mixture of Experts]]
- [[Mamba-3]]
- [[Agentic Reasoning]]
- [[Hybrid Architecture]]
- [[Long Context LLM]]

## 更新紀錄

- 2026-07-11：首次收錄。

