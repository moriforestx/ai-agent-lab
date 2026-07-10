---
type: concept
title: "Long Input Fine-Tuning (LIFT)"
date_updated: "2026-07-10"
tags:
  - concept
---

# Long Input Fine-Tuning (LIFT)

## 定義

將長輸入序列的知識通過微調直接編碼進模型參數，使模型在推理時無需提供長上下文即可回答相關問題。不同於 RAG (外部檢索) 與長上下文模型 (注意力機制)，LIFT 以參數內化知識，推理計算量與上下文長度無關。

## 為什麼重要

解決長上下文 LLM 部署的三大痛點：(1) 二次注意力計算導致推理延遲隨長度平方增長；(2) KV Cache 記憶體壓力大；(3) 長上下文模型訓練成本高。LIFT 將成本前置於微調階段，推理極輕量。

## 出現在哪些內容

- [[LIFT_Long_Input_Fine_Tuning]]
- [[Long_Context_LLM]]
- [[RAG_vs_Long_Context]]

## 相關概念

- [[Parameter_Efficient_Fine_Tuning]]
- [[Knowledge_Distillation]]
- [[Long_Context_Window]]
- [[RAG_Retrieval_Augmented_Generation]]

## 更新紀錄

- 2026-07-10：首次收錄。
