---
type: paper
title: "LIFT: Long Input Fine-Tuning for Long-Context Understanding"
category: "LLM / NLP"
score: "8"
date_collected: "2026-07-10"
published_date: "2026-02-14"
source_url: "https://arxiv.org/html/2502.14644v4"
tags:
  - ai/paper
---

# LIFT: Long Input Fine-Tuning for Long-Context Understanding

## 基本資訊

- 類別：LLM / NLP
- 日期：2026-02-14
- 新鮮度：3–6 個月
- Source：https://arxiv.org/html/2502.14644v4
- Score：8

## 摘要

LIFT (Long Input Fine-Tuning) 框架透過長輸入微調，將任意短上下文 LLM 擴展為長上下文模型，避免二次注意力複雜度。設計高度優化管線，實現 <10s TTFT (Time to First Token) 於 8k context。微調後模型無需推理時提供上下文即可回答問題，參數內化長輸入知識。

## 核心重點

- 突破長上下文推理的二次複雜度瓶頸
- 微調成本可控，推理延遲大幅降低
- 適用於任意短上下文基座模型 (Llama, Mistral, Qwen 等)
- 為 RAG + 長上下文混合架構提供新選項

## 為什麼重要

解決長上下文推理成本與效能的根本矛盾，為資源受限環境部署長文本能力提供可行路徑。

## 可能影響我

可評估將現有短上下文模型透過 LIFT 升級，替代昂貴的原生長上下文模型，降低部署成本。

## 相關概念

- [[Long Context LLM]]
- [[RAG]]
- [[Fine-Tuning]]

## 更新紀錄

- 2026-07-10：首次收錄。

