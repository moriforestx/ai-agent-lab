---
type: concept
title: "NVIDIA NeMo (端到端語音 AI 工具包)"
date_updated: "2026-07-10"
tags:
  - concept
  - speech
  - toolkit
---

# NVIDIA NeMo

## 定義

NVIDIA 開源的端到端語音 AI 工具包，涵蓋 ASR、TTS、NLP、語言模型的訓練、微調、推理、部署全流程。PyTorch Lightning 架構，支援多 GPU/多節點分佈式訓練。

## 核心模組

- **NeMo ASR**：CTC、RNN-T、TDT、Conformer、FastConformer、Parakeet、Canary
- **NeMo TTS**：FastPitch, HiFi-GAN, VITS, StyleTTS2, CosyVoice, Tortoise
- **NeMo NLP**：BERT, GPT, T5, Llama, Nemotron 微調管線
- **NeMo Curator**：數據清洗、去重、質量過濾 (CC-Net, FineWeb 處理)
- **NeMo Guardrails**：對話安全、主題引導、工具調用防護
- **NeMo Deploy**：TensorRT-LLM、TRT-LLM、vLLM 整合部署

## Parakeet 系列 (2026 亮點)

- **Parakeet TDT 1.1B**：1.4% WER，開源 SOTA
- **Parakeet CTC 1.1B**：非流式，極快推理
- **Canary 1B**：多語言 ASR+翻譯+標點

## 為什麼重要

企業級語音 AI 開發標準框架。從數據處理到生產部署一條龍，GPU 加速原生支援。

## 出現在哪些內容

- [[Parakeet_TDT_1.1B]] (Tools)
- [[ASR_TDT_Architecture]] (Concepts)
- [[Open_Source_ASR]] (Concepts)
- [[Open_Source_Speech_Models]] (Concepts)
- [[Audio_AI_Research]] (Concepts)

## 相關概念

- [[NVIDIA_AI_Enterprise]]
- [[TensorRT_LLM]]
- [[Private_AI_Deployment]]
- [[Speech_Foundation_Models]]

## 更新紀錄

- 2026-07-10：首次建立。
