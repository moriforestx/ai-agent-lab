---
type: concept
title: "RepliQA Quantum AI (量子 AI 在生命科學的應用驗證)"
date_updated: "2026-07-10"
tags:
  - concept
  - quantum
  - life-sciences
---

# RepliQA Quantum AI

## 定義

針對量子計算在 AI 加速 (特別是生命科學：分子模擬、蛋白質折疊、藥物發現) 中實際效用的可重現性驗證框架。RepliQA = Reproducibility + Quantum + AI。

## 背景

量子優勢聲稱眾多 (Google Sycamore, IBM Eagle, 中科大祖冲之)，但在實際 AI/生命科學負載上是否真有加速，仍存爭議。需要標準化基準、開源代碼、可重現實驗。

## 驗證維度

1. **速度優勢**：量子 vs 經典 (GPU/TPU) 在同等精度下的壁鐘時間
2. **精度優勢**：量子採樣是否產生更高質量分子結構/蛋白構象
3. **擴展性**：Qubit 數增長對問題規模的邊際收益
4. **錯誤緩解**：NISQ 時代噪聲對結果的影響
5. **端到端管線**：數據編碼 → 量子電路 → 採樣 → 經典後處理 完整延遲

## 代表性負載

| 任務 | 經典基準 | 量子候選 |
|------|----------|----------|
| 分子基態能量 | DFT, CCSD(T), DMRG | VQE, QPE |
| 蛋白質折疊 | AlphaFold2, ESMFold | QAOA, Quantum Annealing |
| 藥物分子生成 | Diffusion, VAE, GAN | QGAN, Born Machine |
| 分子動力學 | MD (AMBER, GROMACS) | Quantum Dynamics Simulation |

## 現狀 (2026)

- **無明確量子優勢**：NISQ 設備噪聲大、Qubit 少、相干時間短
- **混合量子-經典最實用**：Variational Quantum Eigensolver (VQE) + 經典優化器
- **模擬器 > 真機**：對於 <40 qubit，GPU 模擬器比真機快且準
- **投資重心轉移**：從「展示優勢」轉向「錯誤修正」、「邏輯 Qubit」、「容錯量子計算」

## 為什麼重要

避免資源錯配。量子計算在生命科學的真正價值可能在 2030+ 容錯時代。

## 出現在哪些內容

- [[Quantum_AI_Life_Sciences]] (Concepts)
- [[Quantum_Computing]] (Concepts)
- [[AI_for_Science]] (Concepts)

## 相關概念

- [[Quantum_Computing]]
- [[Molecular_Modeling]]
- [[Drug_Discovery_AI]]
- [[Error_Correction]]

## 更新紀錄

- 2026-07-10：首次建立。
