---
type: concept
title: "Streaming ASR (流式語音辨識)"
date_updated: "2026-07-10"
tags:
  - concept
  - speech
  - architecture
---

# Streaming ASR

## 定義

逐幀/逐塊處理音頻流，實時輸出識別結果，無需等待完整語句結束。關鍵指標：延遲 (Latency)、實時因子 (RTF)、精度 (WER)。

## 架構分類

| 類型 | 代表模型 | 延遲 | 精度 | 特點 |
|------|----------|------|------|------|
| **RNN-T** | Transducer, Emformer | ~100-300ms | 高 | 產業標準 |
| **TDT** | **Parakeet TDT**, Moonshine | **~50-150ms** | **最高** | NVIDIA 主推 |
| **Chunkformer** | Chunkformer, Zipformer | ~200-400ms | 高 | 開源友好 |
| **Non-AR** | Paraformer, FastConformer | ~300-500ms | 中 | 推理最快 |

## 關鍵技術

- **Chunk-based Attention**：固定窗口 + 右側上下文
- **Emformer**：Memory Bank 保存歷史信息
- **TDT Duration Predictor**：顯式建模 Token 持續時間，天生流式
- **外部 LM 融合**：Shallow Fusion, Deep Fusion 提升精度
- **端點檢測 (VAD/EOU)**：判斷語句結束觸發最終輸出

## 部署考量

- **ONNX Runtime / TensorRT**：GPU/CPU 統一部署
- **聲音活動檢測 (VAD)**：Silero VAD, WebRTC VAD 前置
- **標點/逆文本正規化 (ITN)**：流式加標點模型
- **多語言切換**：語言識別 (LID) + 動態模型切換

## 為什麼重要

語音助手、即時字幕、會議轉錄、呼叫中心、車載語音 — 所有實時語音應用的基礎設施。

## 出現在哪些內容

- [[Parakeet_TDT_1.1B]] (Tools)
- [[ASR_TDT_Architecture]] (Concepts)
- [[Open_Source_ASR]] (Concepts)
- [[Token_Duration_Transducer_TDT]] (Concepts)
- [[RNN_Transducer]] (Concepts)

## 相關概念

- [[RNN_Transducer]]
- [[Token_Duration_Transducer_TDT]]
- [[ASR_TDT_Architecture]]
- [[Private_AI_Deployment]]

## 更新紀錄

- 2026-07-10：首次建立。
