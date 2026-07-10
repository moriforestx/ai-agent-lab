---
type: concept
title: "ASR TDT Architecture (Token-and-Duration Transducer 架構詳解)"
date_updated: "2026-07-10"
tags:
  - concept
  - speech
  - architecture
---

# ASR TDT Architecture

## 定義

Token-and-Duration Transducer (TDT) 是 RNN-T 的改進：在保持流式能力的同時，引入 **Duration Predictor** 顯式建模每個 Token 的幀級持續時間，實現非自回歸並行解碼與流式解雙重能力。

## 架構組件

```
音頻輸入
    ↓
音頻編碼器 (Conformer/Transformer)
    ↓
┌─────────────────────────────┐
│  Joint Network              │
│  ├─ Token Predictor (AR)    │
│  └─ Duration Predictor (NAR)│
└─────────────────────────────┘
    ↓
Token 序列 + Duration 序列
    ↓
解碼器 (逐幀展開 Duration → Token)
```

## 核心創新

1. **Duration Predictor**：輸出每個 Token 對應的幀數，消除 RNN-T 的逐步依賴
2. **並行訓練**：Token + Duration 聯合損失，無需 Teacher Forcing 循環
3. **流式解碼**：逐幀輸入 → 即時輸出 Token，延遲僅取決於編碼器幀率
4. **動態幀率**：自適應跳過靜音/低資訊幀

## Parakeet TDT 1.1B 實現細節

- 編碼器：12 層 Conformer, 1024 dim, 8 heads
- Token Predictor: 2 層 LSTM, 640 dim
- Duration Predictor: 2 層 Conv1D + Linear
- 詞表：1024 BPE (英文)
- 訓練數據：280k 小時 (公開 + 內部)
- 推理：ONNX Runtime CPU 0.3xRT, TensorRT GPU 0.05xRT

## 優勢總結

| 指標 | RNN-T | TDT (Parakeet) |
|------|-------|----------------|
| 訓練並行度 | 低 (循環依賴) | **高 (無循環)** |
| 推理延遲 | ~150ms | **~80ms** |
| WER (LibriSpeech) | ~2.0% | **1.4%** |
| 部署複雜度 | 中 | 低 (ONNX 原生) |

## 為什麼重要

重新定義開源流式 ASR 天花板，證明 TDT 架構在精度、延遲、部署三方面同時優於 RNN-T。

## 出現在哪些內容

- [[Parakeet_TDT_1.1B]] (Tools)
- [[Token_Duration_Transducer_TDT]] (Concepts)
- [[Streaming_ASR]] (Concepts)
- [[Open_Source_ASR]] (Concepts)
- [[NVIDIA_NeMo]] (Concepts)

## 相關概念

- [[RNN_Transducer]]
- [[Token_Duration_Transducer_TDT]]
- [[Streaming_ASR]]
- [[Conformer]]

## 更新紀錄

- 2026-07-10：首次建立。
