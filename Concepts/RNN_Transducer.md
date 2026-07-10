---
type: concept
title: "RNN Transducer (RNN-T, 循環神經網絡轉換器)"
date_updated: "2026-07-10"
tags:
  - concept
  - speech
  - architecture
---

# RNN Transducer (RNN-T)

## 定義

端到端流式語音辨識的經典架構，由 Graves et al. 2012 提出。結合聲學編碼器、預測網絡 (語言模型)、聯合網絡，輸出 Token 序列。

## 三大組件

1. **Audio Encoder (聲學模型)**：BiLSTM / Conformer / Transformer，輸入聲學特徵 (Mel-filterbank)
2. **Prediction Network (預測網絡/語言模型)**：LSTM/GRU，輸入歷史 Token，輸出語言模型隱藏狀態
3. **Joint Network (聯合網絡)**：Encoder + Prediction Network 輸出拼接 → 全連接 → Softmax over Vocabulary + Blank

## 訓練目標

**Transducer Loss**：對所有對齊路徑的邊緣概率求和，動態規劃計算 (Forward-Backward Algorithm)。

## 解碼

**Beam Search**：逐幀擴展 Hypothesis，Blank 表示不輸出 Token，非 Blank 輸出 Token 並送回 Prediction Network。

## 局限性

- **循環依賴**：Prediction Network 必須逐步運行，難並行化訓練/推理
- **Blank 佔比高**：∼70% 幀輸出 Blank，計算浪費
- **延遲下限**：受限於 Prediction Network 循環

## 演進：RNN-T → TDT

| 方面 | RNN-T | TDT (Token-and-Duration) |
|------|-------|--------------------------|
| Duration 建模 | 隱式 (Blank 計數) | **顯式 (Duration Predictor)** |
| 訓練並行度 | 低 | **高** |
| 推理延遲 | 較高 | **較低** |
| 精度 | 基準 | **更高 (1.4% WER)** |

## 為什麼重要

流式 ASR 的奠基架構。TDT 是其直接繼承者，理解 RNN-T 是理解 TDT 的前提。

## 出現在哪些內容

- [[Token_Duration_Transducer_TDT]] (Concepts)
- [[ASR_TDT_Architecture]] (Concepts)
- [[Streaming_ASR]] (Concepts)
- [[Parakeet_TDT_1.1B]] (Tools)

## 相關概念

- [[Token_Duration_Transducer_TDT]]
- [[Streaming_ASR]]
- [[End_to_End_ASR]]
- [[CTC]]

## 更新紀錄

- 2026-07-10：首次建立。
