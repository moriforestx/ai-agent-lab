---
type: concept
title: "Open Source ASR (開源自動語音辨識)"
date_updated: "2026-07-10"
tags:
  - concept
  - speech
  - open-source
---

# Open Source ASR

## 定義

模型權重、架構、訓練代碼完全開源的自動語音辨識系統。2026 年開源 ASR 已達商用級精度 (WER 1-2%)，成熟可生產部署。

## 主流開源 ASR 模型對比 (2026)

| 模型 | 架構 | 參數 | WER (clean) | 流式 | 授權 | 部署 |
|------|------|------|-------------|------|------|------|
| **Parakeet TDT 1.1B** | TDT | 1.1B | **1.4%** | ✅ | Apache 2.0 | ONNX/TensorRT |
| Whisper large-v3 | Enc-Dec | 1.5B | 1.8% | ❌ | MIT | whisper.cpp |
| Moonshine Base | RNN-T | 0.5B | 2.1% | ✅ | Apache 2.0 | ONNX |
| FunASR Paraformer | Non-AR | 0.3B | 2.3% | ✅ | Apache 2.0 | ONNX |
| NeMo Canary 1B | Enc-Dec | 1B | 1.9% | ❌ | CC-BY-4.0 | NeMo |
| **Granite 4.0 Speech** | Enc-Dec | 8B | 1.6% | ❌ | Apache 2.0 | vLLM |

## 部署選型建議

- **即時流式 (字幕、語音助手)**：Parakeet TDT、Moonshine
- **高精度離線 (會議紀錄、醫療/法律)**：Whisper large-v3、Granite 4.0 Speech
- **資源受限邊緣 (手機、IoT)**：Moonshine、Whisper.cpp (量化)
- **多語言混合**：Canary、SeamlessM4T

## 關鍵技術棧

- **推理引擎**：whisper.cpp (CPU/Metal), ONNX Runtime, TensorRT, vLLM
- **服務化**：Triton Inference Server, FastAPI + vLLM, BentoML
- **流式協議**：WebSocket, gRPC streaming, Server-Sent Events

## 為什麼重要

私有化部署零授權費、數據不出廠、定製化微調自由。

## 出現在哪些內容

- [[Parakeet_TDT_1.1B]] (Tools)
- [[Open_Source_ASR_TTS]] (Concepts)
- [[Open_Source_Speech_Models]] (Concepts)
- [[Audio_AI_Research]] (Concepts)
- [[audio-ai-hub]] (Projects)

## 相關概念

- [[ASR_TDT_Architecture]]
- [[ASR_Architecture]]
- [[Streaming_ASR]]
- [[Private_AI_Deployment]]
- [[Speech_Foundation_Models]]

## 更新紀錄

- 2026-07-10：首次建立。
