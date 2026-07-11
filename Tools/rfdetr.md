---
type: tool
name: "rfdetr"
score: "5"
date_collected: "2026-07-11"
source_url: "https://github.com/roboflow/rf-detr"
tags:
  - ai/tool
---

# rfdetr

## 這是什麼

Roboflow 開源的即時物件偵測與分割 Python 套件，基於 RF-DETR 模型架構。提供統一 API 支援物件偵測、實例分割、關鍵點偵測三大任務。安裝簡單：`pip install rfdetr` (需 Python>=3.10)。

## 主要功能

- 即時推理：RF-DETR-N 384x384 輸入達 30+ FPS
- 多任務統一：偵測、分割、關鍵點單一 API
- 易於微調：支援自訂資料集訓練，DINOv2 backbone 適應小資料集
- Apache 2.0 授權：商業使用無限制
- Ultralytics 格式相容：標註資料可直接使用

## 為什麼重要

首個突破 COCO 60 mAP 的即時 Transformer 偵測器，超越 YOLO 系列。開源生態完善，降低採用門檻，邊緣部署與機器人視覺應用可直接整合。

## 可能影響我

OpenClaw 視覺技能可整合 `rfdetr` 套件提供即時偵測能力。邊緣設備部署參考架構。

## 相關概念

- [[RF-DETR]]
- [[DINOv2]]
- [[Object Detection]]
- [[Instance Segmentation]]

## 更新紀錄

- 2026-07-11：首次收錄。