---
type: tool
name: "Skyvern"
score: "5"
date_collected: "2026-07-11"
source_url: "https://github.com/Skyvern-AI/skyvern"
tags:
  - ai/tool
  - web-automation
  - ai-agents
  - browser
  - computer-use
---

# Skyvern

## 這是什麼

基於視覺 + LLM 的瀏覽器自動化 Agent。無需腳本適應網站變化，支援複雜工作流。

## 主要功能

- 視覺感知：截圖 + LLM 理解頁面狀態
- 無腳本：適應 DOM 變化、A/B 測試、動態內容
- 複雜工作流：登錄、表單填寫、數據提取、多步導航
- API 模式：REST API 提交任務、獲取結果
- 並行執行：多瀏覽器實例併發
- 開源：MIT 許可，可自建

## 為什麼重要

Web Agent 落地關鍵工具。傳統 RPA 易斷、維護成本高；Skyvern 以視覺+推理替代選擇器，魯棒性質變。OpenClaw 可集成作為瀏覽器技能。

## 可能影響我

- OpenClaw 技能擴展：新增 browser_automation skill
- 自動化測試、數據收集管線
- 替代脆弱的 Playwright/Puppeteer 腳本

## 相關概念

- [[AI_Agent_Architecture]]
- [[Model_Context_Protocol_MCP]]
- [[Computer_Use_Agent]]
- [[Web_Automation]]

## 更新紀錄

- 2026-07-11：首次收錄。
