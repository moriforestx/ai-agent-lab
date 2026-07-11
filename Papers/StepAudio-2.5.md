---
type: paper
title: "StepAudio 2.5 Technical Report: Unified Audio-Language Foundation Model"
category: "Audio / Speech"
score: "5"
date_collected: "2026-07-11"
published_date: "2026-05"
source_url: "https://arxiv.org/html/2605.23463v1"
tags:
  - ai/paper
---

# StepAudio 2.5 Technical Report: Unified Audio-Language Foundation Model

## 基本資訊

- 類別：Audio / Speech
- 日期：2026-05
- 新鮮度：0–3 個月
- Source：https://arxiv.org/html/2605.23463v1
- Score：5

## 摘要

StepAudio 2.5 為統一音訊語言基礎模型，整合自動語音辨識 (ASR)、文字轉語音 (TTS)、即時語音對話三大能力於單一模型。採用 7.5 Hz 超低幀率連續語音 tokenizer (VibeVoice 技術)，較傳統 50-100 Hz 模型大幅降低序列長度與計算量。在標準基準測試中，ASR、TTS、Realtime 三項能力均達 SOTA 或超越專用系統，證明統一架構可內化語音理解、生成、即時互動的不同部署目標。

## 核心重點

- 統一架構：單一模型支援理解、生成、即時對話
- 7.5 Hz tokenizer：序列長度縮減 7-13 倍，推理效率大幅提升
- 三合一能力：ASR 準確度、TTS 自然度、即時互動延遲均達產品級
- 開放技術報告：架構細節與訓練策略透明化

## 為什麼重要

音訊領域長期由專用模型主導 (Whisper ASR、VITS TTS、獨立對話系統)，StepAudio 2.5 證明統一模型可達專用系統水平，簡化部署管線、降低維護成本、啟用跨模態推理。超低幀率 tokenizer 為邊緣部署、即時應用提供關鍵技術突破。

## 可能影響我

OpenClaw 語音技能可評估整合 StepAudio 2.5 架構，簡化 ASR/TTS/對話三合一管線。VibeVoice tokenizer 技術可應用於自訂語音模型訓練。

## 相關概念

- [[Unified Audio-Language Model]]
- [[VibeVoice]]
- [[Speech Tokenizer]]
- [[Text-to-Speech]]
- [[Automatic Speech Recognition]]
- [[Realtime Speech Interaction]]

## 更新紀錄

- 2026-07-11：首次收錄。

