---
type: paper
title: "Step-Audio 2 Technical Report"
category: "Audio / Speech"
score: "5"
date_collected: "2026-07-11"
published_date: "2025-07"
source_url: "https://arxiv.org/html/2507.16632v1"
tags:
  - ai/paper
  - audio
  - speech-recognition
  - multimodal-llm
---

# Step-Audio 2 Technical Report

## 基本資訊

- 類別：Audio / Speech
- 日期：2025-07
- 新鮮度：0–3 個月
- Source：https://arxiv.org/html/2507.16632v1
- Score：5

## 摘要

Step-Audio 2 是端到端多模態大語言模型，整合潛在音頻編碼器與推理導向強化學習 (RL)，達成工業級語音識別 (ASR) 與音頻理解性能。將離散音頻 token 生成納入語言建模，實現真正端到端語音對話。在數百萬小時語音音頻數據訓練，130B 參數規模。在多語言 ASR、音頻理解、對話基準上達到 SOTA，超越開源與商業方案。

## 核心重點

- 端到端多模態 LLM：潛在音頻編碼器 + 推理導向 RL
- 真正端到端語音對話：離散音頻 token 整合語言建模
- 規模：數百萬小時訓練數據、130B 參數
- SOTA：多語言 ASR、音頻理解、對話基準
- 開源系列：Step-Audio、Step-Audio-AQAA (首個統一理解生成的 130B LALM)

## 為什麼重要

音頻 LLM 領域里程碑：從級聯系統 (ASR+LLM+TTS) 邁向真正端到端，保留韻律、情感、說話人身分等聲學細節。推理導向 RL 提升對話質量。開源釋出推動社區發展。

## 可能影響我

- Audio AI Hub 專案可評估整合 Step-Audio 2 作為核心模型
- Concepts/Open_Source_ASR.md、Open_Source_ASR_TTS.md、Open_Source_Speech_Models.md 需更新
- 長期研究方向：端到端語音 Agent 架構參考

## 相關概念

- [[Open_Source_ASR]]
- [[Open_Source_ASR_TTS]]
- [[Open_Source_Speech_Models]]
- [[Unified_Audio_LLM]]
- [[Streaming_ASR]]

## 更新紀錄

- 2026-07-11：首次收錄。
