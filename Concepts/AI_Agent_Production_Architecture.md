---
type: concept
name: "AI Agent Production Architecture"
date_updated: "2026-07-10"
tags:
  - concept
---

# AI Agent Production Architecture

## 定義

生產級 AI 代理系統的標準化五層架構：(1) 接入層 - API Gateway、認證、限流；(2) 編排層 - 工作流引擎 (LangGraph/CrewAI)、狀態機、人間回環；(3) 代理層 - ReAct 循環、工具註冊、提示工程、記憶管理；(4) 基礎設施層 - 向量資料庫、快取、訊息佇列、監控；(5) 治理層 - OWASP LLM Top 10 防護、EU AI Act 合規、審計日誌、模型風險管理。

## 為什麼重要

提供代理系統從原型到生產的標準化路徑，解決狀態管理、工具調用、安全合規、可觀測性等工程挑戰。

## 出現在哪些內容

- AI Agents in 2026 Guide (AI Agents)
- OWASP LLM Top 10 2026
- EU AI Act Compliance

## 相關概念

- [[ReAct_Loop]]
- [[Multi_Agent_Systems]]
- [[LangGraph]]
- [[CrewAI]]
- [[OWASP_LLM_Top_10]]
- [[EU_AI_Act_Compliance]]
- [[Human_In_The_Loop]]

## 更新紀錄

- 2026-07-10：首次收錄。
