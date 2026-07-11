---
type: concept
name: "Local Inference Stack"
date_updated: "2026-07-11"
tags:
  - concept
  - inference
  - local-llm
  - deployment
---

# Local Inference Stack

## 定義

本地 LLM/多模態模型推理完整技術棧：推理引擎 (llama.cpp, vLLM, TensorRT-LLM)、模型格式 (GGUF, Safetensors)、服務層 (LocalAI, Ollama, OpenAI 兼容 API)、量化管線、硬體適配 (Metal, CUDA, Vulkan, NPU)。

## 為什麼重要

GitHub 熱門專案聚焦本地推理生態：llama.cpp (核心引擎)、LocalAI (OpenAI 兼容服務)、nano-vLLM (高吞吐)、goose (本地助手)。成熟生態使隱私優先、離線、成本可控部署成為現實選項。

## 出現在哪些內容

- [[llama.cpp]]
- [[LocalAI]]
- [[nano-vLLM]]
- [[Model_Zoo_Curation]]
- [[Edge_AI_Deployment]]

## 相關概念

- [[Quantization]]
- [[Model_Serving]]
- [[OpenAI_Compatible_API]]
- [[Hardware_Abstraction]]

## 更新紀錄

- 2026-07-11：建立。
