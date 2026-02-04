# 技能說明

本文檔說明市集中各項技能的用途與使用情境。

---

## 📚 概述

Claude Code 市集提供精選的技能集合，按類別組織。這些技能透過專業知識、工作流程和工具整合來擴展 Claude 的能力，專為深度學習研究學者和 Python 開發者量身定制。

---

## 🔧 核心技能

### git-skills

**用途**：全面的 Git 版本控制指令參考

**使用情境**：
- 快速查找 Git 指令和語法
- 學習 Git 工作流程（Feature Branch、Git Flow、GitHub Flow）
- 解決 Git 問題和衝突
- 管理分支、遠端倉庫
- 理解 .gitignore 配置

**結構**：
- 按主題組織的模組化參考
- 9 個專注指南（basics、branching、remote、history、undo、advanced、gitignore、troubleshooting、workflows）
- 主 SKILL.md 中的快速指令參考

**目標用戶**：所有使用版本控制的開發者

---

### scientific-critical-thinking

**用途**：評估科學嚴謹性和研究品質的系統性框架

**使用情境**：
- 審查研究論文和方法論
- 評估實驗設計的有效性
- 識別偏差和混淆因素
- 評估統計分析和證據品質
- 檢測科學論證中的邏輯謬誤
- 規劃嚴謹的研究

**核心能力**：
1. **方法論批判** - 評估研究設計和有效性
2. **偏差檢測** - 識別認知、選擇、測量和分析偏差
3. **統計評估** - 評估統計方法和詮釋
4. **證據評估** - 使用 GRADE 和 Cochrane 框架評定證據品質
5. **謬誤識別** - 檢測科學聲明中的邏輯錯誤
6. **研究設計** - 規劃嚴謹研究的指導
7. **聲明評估** - 系統性驗證科學聲明

**結構**：
- 每個能力的模組化指南
- 工作流程模板（論文審查、實驗設計、聲明驗證）
- 全面的參考資料

**目標用戶**：深度學習研究學者、科學家、學術研究人員

---

## 🧠 腦力激盪

### software-brainstorming

**用途**：軟體開發專案的結構化腦力激盪

**使用情境**：
- 功能構思和規劃
- 架構設計探索
- 技術挑戰的問題解決
- API 設計討論
- 技術堆疊選擇

**目標用戶**：軟體開發者、工程團隊

### scientific-brainstorming

**用途**：科學研究的結構化腦力激盪

**使用情境**：
- 研究問題制定
- 實驗設計腦力激盪
- 假設生成
- 方法論探索
- 文獻缺口識別

**目標用戶**：深度學習研究學者、科學家

---

## 📄 文檔技能

**來源**：Anthropic 官方技能（`anthropic/skills`）

全面的文檔創建、編輯和分析套件。

### pdf

**用途**：PDF 操作和分析工具包

**使用情境**：
- 從 PDF 提取文字和表格
- 創建新的 PDF 文檔
- 合併和分割 PDF
- 程式化填寫 PDF 表單
- 大規模 PDF 處理

### docx

**用途**：Microsoft Word 文檔創建和編輯

**使用情境**：
- 創建專業文檔
- 編輯現有 Word 檔案
- 處理追蹤修訂和註解
- 保留格式
- 文字提取和分析

### pptx

**用途**：PowerPoint 簡報創建和編輯

**使用情境**：
- 創建新簡報
- 修改投影片內容和版面配置
- 添加註解和演講者備註
- 提取簡報數據
- 批次簡報處理

### xlsx

**用途**：Excel 試算表創建、編輯和分析

**使用情境**：
- 創建帶有公式和格式的試算表
- 讀取和分析數據
- 修改現有試算表同時保留公式
- 試算表中的數據視覺化
- 重新計算公式

**目標用戶**：需要處理各種文檔格式的研究人員

---

## 🏗️ Anthropic 技能

**來源**：Anthropic 官方技能（`anthropic/skills`）

Anthropic 官方提供的進階 Claude Code 使用技能。

### skill-creator

**用途**：創建有效自訂技能的指南

**使用情境**：
- 設計具有專業知識的新技能
- 實現工作流程自動化
- 整合工具和 API
- 遵循技能開發最佳實踐
- 創建擴展 Claude 能力的技能

### mcp-builder

**用途**：建構高品質的 MCP（Model Context Protocol）伺服器

**使用情境**：
- 為外部服務整合創建 MCP 伺服器
- 設計良好結構的工具介面
- 實現 Python（FastMCP）或 TypeScript（MCP SDK）伺服器
- 使 LLM 能夠與外部服務互動
- 建構生產就緒的整合

**目標用戶**：建構自訂整合的進階用戶

---

## 🧮 Context 工程

AI agent 開發者的進階技能（供未來 agent 開發使用）。

### context-fundamentals

**用途**：AI 系統 context 工程的基礎概念

**涵蓋概念**：
- Context 結構（系統提示、工具、訊息、觀察）
- 注意力機制和 context 視窗
- 漸進式揭露原則
- Context 品質 vs. 數量

### context-compression

**用途**：長時間運行會話中的 context 壓縮策略

**技術**：
- 錨定迭代摘要
- 結構化摘要生成
- 每任務 token 優化
- Artifact 追蹤管理

### context-degradation

**用途**：理解和緩解 context 失效模式

**涵蓋模式**：
- 中間遺失現象
- Context 污染
- Context 分心和混淆
- 模型特定的降級閾值

### context-optimization

**用途**：擴展有效 context 容量的技術

**方法**：
- 壓縮策略
- 觀察遮罩
- KV-cache 優化
- Context 分區

**目標用戶**：未來建構 AI agent 時使用

---

## 🐍 python-skills

**用途**：Python 編程最佳實踐和實用工具

**狀態**：待完善文檔（結構待定）

**預期使用情境**：
- Python 編碼慣例
- 函式庫使用模式
- 測試框架
- 除錯技術
- 數據處理工作流程

**目標用戶**：深度學習研究學者、Python 開發者

---

## 🔄 continuous-learning

**用途**：基於本能的學習系統，觀察會話並演化行為

**狀態**：⚠️ **尚未實作**

**計劃功能**：
- 從 Claude Code 會話自動檢測模式
- 創建帶有信心評分的原子「本能」
- 將本能演化為 skills/commands/agents
- 基於 hook 的觀察（100% 可靠）
- 後台 agent 分析（使用 Haiku）

**架構**：
- 觀察 hooks（PreToolUse/PostToolUse）
- 模式檢測（用戶糾正、錯誤解決、工作流程）
- 信心加權本能（0.3-0.9）
- 本能聚類和演化

**注意**：這是計劃未來實現的進階功能。基礎架構已存在，但需要針對目標受眾進行設置和定制。

**目標用戶**：對個人化學習系統感興趣的進階用戶

---

## 📋 總結表

| 技能類別 | 技能 | 來源 | 狀態 | 目標受眾 |
|---------|------|------|------|---------|
| **版本控制** | git-skills | 自訂 | ✅ 完成 | 所有開發者 |
| **研究** | scientific-critical-thinking | 自訂 | ✅ 完成 | 研究人員、科學家 |
| **腦力激盪** | software-brainstorming, scientific-brainstorming | 自訂 | ✅ 可用 | 開發者、研究人員 |
| **文檔** | pdf, docx, pptx, xlsx | **Anthropic** | ✅ 可用 | 所有用戶 |
| **進階** | skill-creator, mcp-builder | **Anthropic** | ✅ 可用 | 進階用戶 |
| **Context 工程** | fundamentals, compression, degradation, optimization | 自訂 | ✅ 可用 | 未來 agent 開發 |
| **編程** | python-skills | 自訂 | 📝 待完善文檔 | Python 開發者 |
| **學習** | continuous-learning | 自訂 | ⚠️ 未實作 | 未來功能 |

---

## 🎯 入門指南

### 深度學習研究學者

**推薦技能**：
1. **scientific-critical-thinking** - 用於審查論文和設計實驗
2. **git-skills** - 用於程式碼和實驗的版本控制
3. **python-skills** - 用於 Python 開發最佳實踐
4. **document-skills**（xlsx、pdf）- 用於數據分析和文檔編製

### 軟體開發者

**推薦技能**：
1. **git-skills** - 版本控制必備
2. **software-brainstorming** - 用於功能規劃和架構
3. **skill-creator** - 用於創建自訂技能

### 進階用戶

**推薦技能**：
1. **mcp-builder** - 用於建構服務整合
2. **context-engineering** - 用於未來 agent 開發
3. **continuous-learning** - 實驗性（實作後）

---

## 📖 文檔

每個技能包含：
- **SKILL.md** - 主要文檔和入口點
- **Guides** - 詳細的操作指南（適用時）
- **References** - 全面的參考資料
- **Workflows** - 逐步工作流程模板（適用時）

有關特定技能的使用方法，請參閱 `skills/` 目錄中的各個 SKILL.md 檔案。
