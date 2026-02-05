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

### paper

**用途**：透過多代理 council 審議，將研究論文及其程式碼倉庫轉化為高品質的可重用技能

**使用情境**：
- 將研究論文與實作程式碼打包為結構化技能
- 建立論文的快速參考指南，方便理解與應用
- 建構可重用的技能，捕捉論文的問題、解決方案和貢獻
- 分析論文與程式碼的一致性（論文描述 vs. 程式碼實作）

**運作原理**：

技能使用 5 階段的 council 審議流程：

1. **Phase 0 - 資訊收集**：透過 `/pdf` 讀取論文 PDF，clone GitHub 倉庫，準備共享上下文
2. **Phase 1 - 獨立專家分析**：3 位分析師平行運行：
   - **分析師 A**（理論與方法）：研究方法論、數學公式、實驗設計
   - **分析師 B**（文獻與概念）：術語定義、相關工作、領域定位、新穎性評估
   - **分析師 C**（程式碼與實踐）：倉庫結構、環境設定、使用模式、可重現性
3. **Phase 2 - 匿名同儕審查**：每位分析師審查另外兩位的分析結果，不知道作者是誰（改編自 llm-council 的匿名排名機制）。從準確性、完整性、清晰度、實用性四個維度評分（1-5 分）。
4. **Phase 3 - 主席綜合**：主席代理接收所有分析、同儕審查和品質分數，按加權分數綜合最佳內容。
5. **Phase 4 - 寫入技能檔案**：輸出 4 個結構化檔案至 `skills/<paper-name>/`：
   - `SKILL.md` - 入口點，含摘要、關鍵概念、快速開始
   - `references/paper_summary.md` - 全面的論文分析
   - `references/key_concepts.md` - 概念參考與數學公式
   - `references/code_guide.md` - 實用的程式碼使用指南

**模式**：
- **Claude-only**（預設）：所有代理以 Claude Task 子代理運行。無外部依賴。
- **多模型**（使用者請求）：透過 MCP 伺服器使用 Claude、GPT 和 Gemini，實現真正的模型多樣性，提升盲點檢測能力。

**所需輸入**：
- 論文 PDF 檔案路徑
- 實作倉庫的 GitHub URL

**結構**：
- `SKILL.md` - 主要工作流程定義
- `references/analyst-roles.md` - 專家角色定義和提示模板
- `references/peer-review-protocol.md` - 匿名審查流程和評分機制
- `references/synthesis-guide.md` - 主席綜合指引
- `references/skill-output-templates.md` - 4 個生成檔案的模板

**目標用戶**：希望快速理解和應用新論文的深度學習研究學者

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

**用途**：即時誤解檢測和溝通優化系統

**狀態**：✅ **已實作（方案 3：增量式即時捕獲）**

**核心功能**：
- **即時誤解檢測**：在 correction 發生的瞬間自動捕獲
- **輕量級分析**：只分析最近 5 turns（不是整個 session）
- **高 Token 效率**：相比傳統方案節省 80-90% token 成本
- **自動背景運行**：使用 Haiku 模型背景分析（無需手動觸發）
- **生成 Clarification Hints**：50-100 字的簡潔溝通指南

**檢測模式**：
1. **快速重複編輯**（Rapid Re-edit）：同一檔案短時間內多次編輯
2. **錯誤恢復**（Error Recovery）：錯誤後成功修復的模式
3. **工具重複使用**（Repeated Tool）：同一工具連續使用 3 次以上
4. **迭代修正**（Iterative Correction）：快速來回調整任務

**架構**：
- 觀察 hooks（PreToolUse/PostToolUse）捕獲工具使用
- 啟發式檢測識別 correction patterns
- 背景觸發輕量級分析（Haiku）
- 生成並儲存 clarification hints

**Token 效率對比**：
| 方案 | 每次分析成本 | 觸發方式 | 效率 |
|------|-------------|---------|------|
| 傳統方案 | 6-23K tokens | 手動 | 基準 |
| **方案 3** | **1-2.5K tokens** | **自動** | **5-10x** |

**使用方式**：
1. 配置 hooks（詳見 `skills/continuous-learning/USAGE_GUIDE.md`）
2. 系統自動運作，無需手動操作
3. 查看生成的 hints：`~/.claude/homunculus/clarifications/`
4. 測試功能：`python3 skills/continuous-learning/scripts/test-clarification.py`

**範例輸出**：
```yaml
---
id: rapid_re_edit-20250204
trigger: "when editing files multiple times"
confidence: 0.70
type: disambiguation
---

When user says "refactor", clarify: "Structural change or rename only?"

Evidence:
- Rapid tool iteration: Edit → Edit → Edit
```

**目標用戶**：所有希望減少溝通成本的使用者

**文檔**：
- 完整指南：`skills/continuous-learning/USAGE_GUIDE.md`
- 技能說明：`skills/continuous-learning/SKILL.md`
- 測試腳本：`skills/continuous-learning/scripts/test-clarification.py`

---

## 📋 總結表

| 技能類別 | 技能 | 來源 | 狀態 | 目標受眾 |
|---------|------|------|------|---------|
| **版本控制** | git-skills | 自訂 | ✅ 完成 | 所有開發者 |
| **研究** | scientific-critical-thinking, paper | 自訂 | ✅ 完成 | 研究人員、科學家 |
| **腦力激盪** | software-brainstorming, scientific-brainstorming | 自訂 | ✅ 可用 | 開發者、研究人員 |
| **Context 工程** | fundamentals, compression, degradation, optimization | 自訂 | ✅ 可用 | 未來 agent 開發 |
| **編程** | python-skills | 自訂 | 📝 待完善文檔 | Python 開發者 |
| **學習** | continuous-learning | 自訂 | ✅ 已實作 | 所有使用者 |

---

## 🎯 入門指南

### 深度學習研究學者

**推薦技能**：
1. **scientific-critical-thinking** - 用於審查論文和設計實驗
2. **paper** - 將論文和程式碼倉庫轉化為可重用的技能參考
3. **git-skills** - 用於程式碼和實驗的版本控制
4. **continuous-learning** - 減少溝通誤解，提升協作效率

### 軟體開發者

**推薦技能**：
1. **git-skills** - 版本控制必備
2. **software-brainstorming** - 用於功能規劃和架構
3. **continuous-learning** - 自動學習你的溝通模式，降低溝通成本

### 進階用戶

**推薦技能**：
1. **context-engineering** - 用於未來 agent 開發
2. **continuous-learning** - 自動化誤解檢測和溝通優化

---

## 📖 文檔

每個技能包含：
- **SKILL.md** - 主要文檔和入口點
- **Guides** - 詳細的操作指南（適用時）
- **References** - 全面的參考資料
- **Workflows** - 逐步工作流程模板（適用時）

有關特定技能的使用方法，請參閱 `skills/` 目錄中的各個 SKILL.md 檔案。
