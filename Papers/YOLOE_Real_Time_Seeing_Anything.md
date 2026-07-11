---
type: paper
title: "YOLOE: Real-Time Seeing Anything"
category: "Computer Vision"
score: "5"
date_collected: "2026-07-11"
published_date: "2025-03"
source_url: "https://arxiv.org/html/2503.07465v1"
tags:
  - ai/paper
  - computer-vision
  - object-detection
  - open-vocabulary
---

# YOLOE: Real-Time Seeing Anything

## 基本資訊

- 類別：Computer Vision
- 日期：2025-03
- 新鮮度：0–3 個月
- Source：https://arxiv.org/html/2503.07465v1
- Score：5

## 摘要

YOLOE 統一文本提示、視覺提示、無提示三種開放詞彙檢測分割機制於單一高效模型。引入 SAVPE (Semantic-Activated Visual Prompt Encoder) 處理視覺提示。在 LVIS 上以 3× 更低訓練成本、1.4× 推理加速超越 YOLO-Worldv2-S 3.5 AP。遷移至 COCO 時 YOLOE-v8-L 在閉集基準上分別獲得 0.6 APb、0.4 APm 提升，訓練時間減少近 4×。視覺提示與無提示設定下分別以 2× 更少數據、6.3× 更少參數超越 T-Rex2 (3.3 APr) 與 GenerateU (0.4 AP)。

## 核心重點

- 統一文本、視覺、無提示三種開放詞彙模式
- SAVPE：語義激活視覺提示編碼器
- 極高效率：3× 訓練成本降低、1.4× 推理加速 (LVIS)
- 參數效率：較 GenerateU 少 6.3× 參數達成更好表現
- 部署友善：T4 GPU 與 iPhone 12 均實現實時

## 為什麼重要

開放詞彙檢測分割實用化關鍵突破。過往方法多需龐大模型、高昂訓練成本、或僅支援單一提示模式。YOLOE 以單一 YOLOv8 級骨幹統一三種模式，大幅降低部署門檻，使開放詞彙能力可真正用於生產環境。

## 可能影響我

- Computer Vision 專案可直接採用 YOLOE 替換傳統閉集檢測器
- Tools/YOLOv11.md 需更新納入 YOLOE 架構
- Projects 中涉及物件檢測的管線可評估遷移收益

## 相關概念

- [[Object_Detection_Transformer]]
- [[YOLOv11]]
- [[Open_Vocabulary_Detection]]
- [[EfficientViT_SAM]]

## 更新紀錄

- 2026-07-11：首次收錄。
