---
type: tool
name: "LocalAI"
score: "5"
date_collected: "2026-07-11"
source_url: "https://github.com/mudler/LocalAI"
tags:
  - ai/tool
  - local-llm
  - inference
  - openai-compatible
---

# LocalAI

## 這是什麼

免費開源 OpenAI API 替代品。本地運行 LLMs、音頻、圖像模型，提供 OpenAI 兼容 REST API。支援 llama.cpp、GGUF、ONNX、TensorRT 等多種後端。

## 主要功能

- OpenAI API 兼容：/v1/chat/completions, /v1/embeddings, /v1/audio/transcriptions 等
- 多後端支援：llama.cpp (CPU/Metal/CUDA)、ONNX Runtime、TensorRT-LLM、vLLM
- 模型管理：自動下載、量化轉換、版本管理
- 多模態：文本生成、嵌入、語音識別 (Whisper)、TTS、圖像生成
- 離線優先：無需外部網絡，隱私保護
- 輕量部署：單二進制、Docker、Kubernetes

## 為什麼重要

本地推理基礎設施標準選擇。解決隱私、成本、離線、延遲四大痛點。OpenClaw 節點部署可直接集成。

## 可能影響我

- OpenClaw 邊緣節點：替換雲端 API 為本地 LocalAI
- 成本控制：自建推理集群替代付費 API
- 隱私合規：數據不出設備/內網
- Model_Zoo_Curation.md 需記錄 LocalAI 支援模型列表

## 相關概念

- [[Local_Inference_Stack]]
- [[Model_Zoo_Curation]]
- [[Open_Source_ASR_TTS]]
- [[Edge_AI_Deployment]]

## 更新紀錄

- 2026-07-11：首次收錄。
