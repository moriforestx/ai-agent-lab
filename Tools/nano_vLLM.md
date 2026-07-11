---
type: tool
name: "nano-vLLM"
score: "4"
date_collected: "2026-07-11"
source_url: "https://github.com/GeeeekExplorer/nano-vllm"
tags:
  - ai/tool
  - inference
  - high-throughput
  - vllm
---

# nano-vLLM

## 這是什麼

高吞吐 LLM 推理引擎。vLLM 輕量化實現，專注性能極致。

## 主要功能

- PagedAttention 高效 KV Cache 管理
- 連續批處理 (Continuous Batching)
- 預填充/解碼分離
- 多 GPU 張量並行
- OpenAI 兼容 API
- 輕量依賴，易嵌入

## 為什麼重要

高併發推理場景首選。生產環境吞吐優化參考實現。

## 可能影響我

- 高負載推理服務選型
- 推理引擎基準測試參考

## 相關概念

- [[Local_Inference_Stack]]
- [[vLLM]]
- [[PagedAttention]]
- [[Continuous_Batching]]

## 更新紀錄

- 2026-07-11：首次收錄。
