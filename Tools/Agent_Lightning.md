---
type: tool
name: "Agent Lightning"
score: "4"
date_collected: "2026-07-11"
source_url: "https://github.com/microsoft/agent-lightning"
tags:
  - ai/tool
  - ai-agents
  - reinforcement-learning
  - training
  - microsoft
---

# Agent Lightning

## 這是什麼

Microsoft 開源：使用強化學習訓練 Agent。超越提示工程，通過 RL 優化多輪工具使用策略。

## 主要功能

- RL 訓練循環：環境交互 → 獎勵計算 → 策略更新
- 多輪軌跡優化：不再凍結於單輪 Prompt
- 獎勵建模：任務完成度、效率、錯誤恢復綜合獎勵
- 開箱即用環境：代碼執行、Web 操作、API 調用
- 分布式訓練支援

## 為什麼重要

Agent 行為從「提示工程固化」轉向「策略學習持續改進」。Microsoft 開源信號：RL for Agents 進入實用化階段。

## 可能影響我

- Agent 訓練管線建設參考
- ReAct_Loop.md 需增加 RL 優化章節
- 生產環境 Agent 持續學習架構設計

## 相關概念

- [[Agent_RL_Training]]
- [[AI_Agent_Production_Architecture]]
- [[ReAct_Loop]]
- [[Reward_Modeling]]

## 更新紀錄

- 2026-07-11：首次收錄。
