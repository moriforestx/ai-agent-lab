---
type: concept
title: "Open Source ASR & TTS (開源語音辨識與合成)"
date_updated: "2026-07-10"
tags:
  - concept
  - speech
  - open-source
---

# Open Source ASR & TTS

## 定義

完全開源 (模型權重、訓練代碼、數據、授權) 的自動語音辨識 (ASR) 與語音合成 (TTS) 系統，支援私有化部署、商業使用、二次開發。

## 2026 開源 SOTA 全景

### ASR (語音辨識)
| 模型 | 架構 | WER (LibriSpeech clean) | 語言 | 授權 |
|------|------|------------------------|------|------|
| **Parakeet TDT 1.1B** | TDT | **1.4%** | En | Apache 2.0 |
| Whisper large-v3 | Transformer | 1.8% | 100+ | MIT |
| Moonshine | RNN-T | 2.1% | En | Apache 2.0 |
| FunASR (Paraformer) | Non-autoregressive | 2.3% | Zh/En | Apache 2.0 |
| NeMo Canary | Enc-Dec | 1.9% | 多語 | CC-BY-4.0 |

### TTS (語音合成)
| 模型 | 類型 | 自然度 | 語言 | 授權 |
|------|------|--------|------|------|
| **CosyVoice 2** | Flow Matching | ⭐⭐⭐⭐⭐ | 多語 | Apache 2.0 |
| **Fish Speech 1.5** | VQ-GAN + LM | ⭐⭐⭐⭐⭐ | 多語 | MIT |
| VALL-E 2 | Codec LM | ⭐⭐⭐⭐ | En/Zh | 非商業 |
| GPT-SoVITS | VITS + GPT | ⭐⭐⭐⭐ | 多語 | MIT |
| StyleTTS 2 | Diffusion | ⭐⭐⭐⭐ | En | MIT |

## 關鍵趨勢

1. **流式 ASR 成熟**：TDT、Chunkformer 支援 <200ms 延遲
2. **零樣本 TTS**：3-10s 參考音頻克隆音色
3. **統一語音模型**：SeamlessM4T、Spirit-LM、Moshi (語音對話)
4. **邊緣部署**：Whisper.cpp、Moonshine、Parakeet ONNX 在手機/嵌入式跑滿速

## 為什麼重要

語音是下一代交互主介面。開源 SOTA 讓語音能力不再被少數巨頭壟斷。

## 出現在哪些內容

- [[Parakeet_TDT_1.1B]] (Tools)
- [[Open_Source_ASR]] (Concepts)
- [[Open_Source_Speech_Models]] (Concepts)
- [[Audio_AI_Research]] (Concepts)
- [[audio-ai-hub]] (Projects)

## 相關概念

- [[ASR_TDT_Architecture]]
- [[TTS_Architecture]]
- [[Streaming_ASR]]
- [[Private_AI_Deployment]]
- [[Speech_Foundation_Models]]

## 更新紀錄

- 2026-07-10：首次建立，基於 Codesota Speech AI Hub 2026 報告。
