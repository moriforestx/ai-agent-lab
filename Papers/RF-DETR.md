---
type: paper
title: "RF-DETR: Neural Architecture Search for Real-Time Detection Transformers"
category: "Computer Vision / 影像辨識 AI"
score: "5"
date_collected: "2026-07-11"
published_date: "2026-03"
source_url: "https://github.com/roboflow/rf-detr"
tags:
  - ai/paper
---

# RF-DETR: Neural Architecture Search for Real-Time Detection Transformers

## 基本資訊

- 類別：Computer Vision / 影像辨識 AI
- 日期：2026-03
- 新鮮度：3–6 個月
- Source：https://github.com/roboflow/rf-detr
- Score：5

## 摘要

Roboflow 推出 RF-DETR，基於 DINOv2 Vision Transformer backbone 的即時物件偵測、實例分割、關鍵點偵測統一架構。透過神經架構搜尋 (NAS) 針對即時推理優化，RF-DETR-N 在 COCO val2017 達成 67.6 AP，為首個突破 60 mAP 的即時模型，超越 YOLO11-N (52.0 AP) 與 LW-DETR。模型提供 N/Base/Large 三種尺寸，開源 Apache 2.0 授權，支援 Python>=3.10 環境 pip 安裝。

## 核心重點

- DINOv2 ViT backbone 提供強大視覺表徵基礎
- NAS 自動搜尋最佳即時架構配置，平衡精度與延遲
- 單一 API 支援偵測、分割、關鍵點三任務
- RF100-VL 基準驗證跨域泛化能力優於 YOLO 系列
- Apache 2.0 開源，生態整合度高 (Ultralytics 格式相容)

## 為什麼重要

即時物件偵測領域長期由 CNN-based YOLO 系列主導，RF-DETR 證明 Transformer 架構經 NAS 優化後可在速度與精度雙贏，重新定義即時 SOTA 基準。對邊緣部署、機器人視覺、自動駕駛感知具備直接應用價值。

## 可能影響我

OpenClaw 視覺相關技能可整合 `rfdetr` 套件，提供即時物件偵測能力。邊緣設備部署參考架構，為 AI Agent 賦予視覺感知能力。

## 相關概念

- [[DINOv2]]
- [[Object Detection]]
- [[Instance Segmentation]]
- [[Vision Transformer]]
- [[Neural Architecture Search]]

## 更新紀錄

- 2026-07-11：首次收錄。

