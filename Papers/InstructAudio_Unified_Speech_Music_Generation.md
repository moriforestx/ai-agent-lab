---
type: paper
title: "InstructAudio: Unified Speech and Music Generation with Natural Language Instruction"
category: "Audio / Speech"
score: "4"
date_collected: "2026-07-11"
published_date: "2025-11"
source_url: "https://arxiv.org/pdf/2511.18487"
tags:
  - ai/paper
  - audio
  - speech-generation
  - music-generation
  - diffusion-transformer
---

# InstructAudio: Unified Speech and Music Generation with Natural Language Instruction

## 基本資訊

- 類別：Audio / Speech
- 日期：2025-11
- 新鮮度：0–3 個月
- Source：arXiv:2511.18487
- Score：4

## 摘要

InstructAudio 統一語音合成 (TTS) 與音樂生成 (TTM) 的指令控制。解決 TTS 依賴參考音頻、文本層級屬性控制有限、不支援對話生成；TTM 指令控制異質性高難以聯合建模。提出統一框架：自然語言描述控制音色 (性別、年齡)、超語言 (情感、風格、口音)、音樂 (流派、樂器、節奏、氛圍)。採用聯合與單擴散 Transformer 層，標準化指令-音素輸入格式，50K 小時語音 + 20K 小時音樂訓練，實現多任務學習與跨模態對齊。

## 核心重點

- 自然語言指令統一控制語音與音樂屬性
- 聯合/單擴散 Transformer 混合架構
- 標準化 instruction-phoneme 輸入格式
- 大規模訓練：50K h 語音 + 20K h 音樂
- 跨模態對齊：語音與音樂共享表示空間

## 為什麼重要

首個實現自然語言指令級控制的統一語音音樂生成模型，大幅降低使用門檻，為表達式音頻生成建立新范式。

## 可能影響我

- Audio AI Hub 專案可評估整合 InstructAudio 作為表達式生成後端
- Concepts/Open_Source_ASR_TTS.md 需新增統一生成模型類別

## 相關概念

- [[Open_Source_ASR_TTS]]
- [[Open_Source_Speech_Models]]
- [[Unified_Audio_LLM]]
- [[Audio_AI_Research]]

## 更新紀錄

- 2026-07-11：首次收錄。
