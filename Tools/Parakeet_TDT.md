---
type: tool
title: "Parakeet TDT 1.1B"
score: "8"
date_collected: "2026-07-10"
source_url: "https://www.codesota.com/speech"
tags:
  - ai/tool
---

# Parakeet TDT 1.1B

## 這是什麼

NVIDIA 開源的 Token-and-Duration Transducer (TDT) 語音辨識模型，1.1B 參數，在 LibriSpeech test-clean 達成 1.4% WER，達商用級開源 ASR 基準。

## 主要功能

- 架構：Token-and-Duration Transducer，流式與非流式雙模支援
- 參數量：1.1B
- 語言：英文為主，支援多語言微調
- 推理：ONNX Runtime、TensorRT 優化，支援 GPU/CPU
- 授權：開源 (Apache 2.0)，商用友善

## 為什麼重要

開源 ASR 首次在獨立基準測試中達到 1.4% WER，打破商用 API (Google、Azure、AWS) 的精度壟斷，私有化部署零授權成本。

## 可能影響我

語音轉錄管線可完全開源化，避免數據上傳隱私風險，成本僅為 GPU 推理算力。

## 相關概念

- [[Token_Duration_Transducer_TDT]]
- [[NVIDIA_NeMo]]
- [[Open_Source_ASR]]
- [[Streaming_ASR]]

## 更新紀錄

- 2026-07-10：首次收錄。
