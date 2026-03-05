# 技能說明

本文檔說明市集中各項技能的用途與使用情境。

---

## 概述

Claude Code 市集提供精選的技能集合，按類別組織。這些技能透過專業知識、工作流程和工具整合來擴展 Claude 的能力，專為深度學習研究學者和 Python 開發者量身定制。

---

## 腦力激盪

### scientific-brainstorming

**用途**：科學研究的結構化腦力激盪

**使用情境**：
- 研究問題制定
- 假設生成
- 實驗設計腦力激盪
- 方法論探索
- 文獻缺口識別
- 跨領域連結發現

**運作方式**：
- 透過結構化對話引導協作式想法探索
- 一次一個問題，多種方法
- 漸進式驗證想法
- 引用已建立的腦力激盪方法

**結構**：
- `SKILL.md` - 主要技能定義和工作流程
- `references/brainstorming_methods.md` - 腦力激盪方法論參考

**目標用戶**：深度學習研究學者、科學家

### software-brainstorming

**用途**：軟體開發專案的結構化腦力激盪

**使用情境**：
- 功能構思和規劃
- 架構設計探索
- 技術挑戰的問題解決
- API 設計討論
- 技術堆疊選擇

**運作方式**：
- 探索軟體設計需求、架構和技術限制
- 在實作前進行結構化對話
- 多方案評估

**結構**：
- `SKILL.md` - 主要技能定義和工作流程

**目標用戶**：軟體開發者、工程團隊

---

## paper

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
3. **Phase 2 - 匿名同儕審查**：每位分析師審查另外兩位的分析結果，不知道作者是誰。從準確性、完整性、清晰度、實用性四個維度評分（1-5 分）。
4. **Phase 3 - 主席綜合**：主席代理接收所有分析、同儕審查和品質分數，按加權分數綜合最佳內容。
5. **Phase 4 - 寫入技能檔案**：輸出 4 個結構化檔案至 `skills/<paper-name>/`：
   - `SKILL.md` - 入口點，含摘要、關鍵概念、快速開始
   - `references/paper_summary.md` - 全面的論文分析
   - `references/key_concepts.md` - 概念參考與數學公式
   - `references/code_guide.md` - 實用的程式碼使用指南

**模式**：
- **Claude-only**（預設）：所有代理以 Claude Task 子代理運行。無外部依賴。
- **多模型**（使用者請求）：透過 MCP 伺服器使用 Claude、GPT 和 Gemini，實現真正的模型多樣性。

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

## continuous-learning

**用途**：即時誤解檢測和溝通優化系統

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
| **本系統** | **1-2.5K tokens** | **自動** | **5-10x** |

**使用方式**：
1. 配置 hooks（詳見 `skills/continuous-learning/USAGE_GUIDE.md`）
2. 系統自動運作，無需手動操作
3. 查看生成的 hints：`~/.claude/homunculus/clarifications/`
4. 測試功能：`python3 skills/continuous-learning/scripts/test-clarification.py`

**結構**：
- `SKILL.md` - 技能說明和入口點
- `USAGE_GUIDE.md` - 完整設定和使用指南
- `agents/observer.md` - 背景觀察代理
- `hooks/observe.sh` - 觀察 hook 腳本
- `scripts/` - 分析和測試腳本
- `config.json` - 配置

**目標用戶**：所有希望減少溝通成本的使用者

---

## 總結表

| 技能類別 | 技能 | 狀態 | 目標受眾 |
|---------|------|------|---------|
| **腦力激盪** | scientific-brainstorming, software-brainstorming | 可用 | 開發者、研究人員 |
| **研究** | paper | 可用 | 深度學習研究學者 |
| **學習** | continuous-learning | 可用 | 所有使用者 |

---

## 入門指南

### 深度學習研究學者

**推薦技能**：
1. **paper** - 將論文和程式碼倉庫轉化為可重用的技能參考
2. **scientific-brainstorming** - 用於生成研究假設和實驗構想
3. **continuous-learning** - 減少溝通誤解，提升協作效率

### 軟體開發者

**推薦技能**：
1. **software-brainstorming** - 用於功能規劃和架構探索
2. **continuous-learning** - 自動學習你的溝通模式，降低溝通成本

---

## 文檔

每個技能包含：
- **SKILL.md** - 主要文檔和入口點
- **References** - 全面的參考資料（適用時）

有關特定技能的使用方法，請參閱 `skills/` 目錄中的各個 SKILL.md 檔案。
