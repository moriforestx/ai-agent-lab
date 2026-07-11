---
type: tool
name: "llama.cpp"
score: "5"
date_collected: "2026-07-11"
source_url: "https://github.com/ggml-org/llama.cpp"
tags:
  - ai/tool
  - inference
  - local-llm
  - ggml
  - quantization
---

# llama.cpp

## 這是什麼

通用本地 LLM 推理引擎核心。C/C++ 實現，支援 Apple Metal、CUDA、Vulkan、CPU、NPU。GGUF 格式創始者。

## 主要功能

- 跨平台：macOS (Metal)、Linux/Windows (CUDA/Vulkan/CPU)、iOS/Android
- 量化：2-bit 到 8-bit 多種量化方案 (Q4_K_M, Q8_0, IQ 系列)
- 模型支援：LLaMA, Mistral, Qwen, Gemma, Phi, DeepSeek, 等數百種
- 工具鏈：量化 (llama-quantize)、轉換、基準測試、服務器
- 語法約束：GBNF 文法強制結構化輸出
- 嵌入提取、重排序

## 為什麼重要

本地推理生態基石。幾乎所有本地 LLM 工具 (LocalAI, Ollama, Kobold.cpp, Jan, LM Studio) 底層依賴 llama.cpp。

## 可能影響我

- OpenClaw 節點推理後端首選
- 量化策略選型指導
- 邊緣設備部署 (手機、嵌入式) 核心依賴

## 相關概念

- [[Local_Inference_Stack]]
- [[Quantization]]
- [[GGUF_Format]]
- [[Edge_AI_Deployment]]
- [[Model_Zoo_Curation]]

## 更新紀錄

- 2026-07-11：首次收錄。
