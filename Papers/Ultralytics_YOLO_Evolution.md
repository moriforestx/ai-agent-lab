---
type: paper
title: "Ultralytics YOLO Evolution: An Overview of YOLO26, YOLO11, YOLOv8, and YOLOv5"
category: "Computer Vision"
score: "5"
date_collected: "2026-07-11"
published_date: "2025-10"
source_url: "https://arxiv.org/html/2510.09653v3"
tags:
  - ai/paper
---

# Ultralytics YOLO Evolution: An Overview of YOLO26, YOLO11, YOLOv8, and YOLOv5

## 基本資訊

- 類別：Computer Vision
- 日期：2025-10
- 新鮮度：0–3 個月
- Source：arXiv:2510.09653v3
- Score：5

## 摘要

本文系統綜述 Ultralytics YOLO 家族架構演進，從 YOLOv5 到最新 YOLO26 (2025)。YOLO26 引入關鍵創新：移除 Distribution Focal Loss (DFL)、原生 NMS-free 推理、Progressive Loss Balancing (ProgLoss)、Small-Target-Aware Label Assignment (STAL)、MuSGD 優化器。首個原生統一五大任務：目標檢測、實例分割、分類、姿態/關鍵點檢測、定向邊界框檢測。

## 核心重點

- YOLO26 移除 DFL 簡化頭部，採用 NMS-free 解碼大幅提速
- ProgLoss 動態平衡各尺度損失，改善小目標檢測
- STAL 標籤分配專針對小目標優化
- MuSGD 優化器穩定大規模訓練
- 單模型統一 5 任務，部署極大簡化
- 在 COCO、LVIS 等基準達 SOTA

## 為什麼重要

YOLO 系列是實時檢測事實標準。YOLO26 代表架構成熟度新高度，單模型多任務對工程部署價值極大。Ultralytics 生態 (Python API、ONNX/TensorRT 導出、活躍社群) 使其落地門檻最低。

## 可能影響我

- Tools/YOLOv11.md 需更新為 YOLO26 內容
- Projects 中 Computer Vision 管線可評估遷移至 YOLO26 統一架構
- Concepts/Object_Detection_Transformer.md、RT_DETR.md 需對比更新

## 相關概念

- [[YOLOv11]]
- [[Object_Detection_Transformer]]
- [[RT_DETR]]
- [[EfficientViT_SAM]]

## 更新紀錄

- 2026-07-11：首次收錄。
