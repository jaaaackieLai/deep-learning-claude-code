**語言：** [English](../../README.md) | 繁體中文

# Deep-learning-claude-code
本專案包含我常用的 commands、agents 和 skills。

希望此專案能幫助使用 Python 進行深度學習工作的軟體工程師，以及其他設定能使你的工作流程更加順暢。

請遵循 Anthropic 提供的 [plugin-marketplaces](https://code.claude.com/docs/en/plugin-marketplaces) 和 [skills](https://code.claude.com/docs/en/skills) 說明。

## 安裝方式

您可以透過兩種方式安裝此插件市集：

**在 Claude Code CLI 中：**
```
/plugin add jaaaackieLai/deep-learning-claude-code
```

**在終端機中：**
```bash
claude plugin add jaaaackieLai/deep-learning-claude-code
```

## 包含內容

### 代理程式 (Agents)

改變 Claude 工作方式的專業代理：

| 代理 | 用途 |
|------|------|
| **planner** | 建立含依賴關係和風險評估的分階段實作計畫 |
| **tdd-guide** | 執行測試驅動開發（Red/Green/Refactor），確保 80%+ 覆蓋率 |
| **analyzer** | 使用一次變更一個變數的方法論進行系統性分析 |

詳見[代理程式指南](./agent-readme.md)。

### 命令 (Commands)

常用工作流程的斜線命令：

| 命令 | 用途 |
|------|------|
| `/plan` | 在撰寫程式碼前建立實作計畫 |
| `/tdd` | 以測試優先的方法啟動 TDD 會話 |
| `/test-coverage` | 分析覆蓋率並生成缺失的測試 |
| `/update-codemaps` | 掃描程式碼庫並更新架構文件 |
| `/update-docs` | 從真實來源同步文件 |

詳見[命令指南](./command-readme.md)。

### 技能 (Skills)

以專業知識擴展 Claude 的能力：

| 技能 | 用途 |
|------|------|
| **scientific-brainstorming** | 研究假設和實驗設計的結構化腦力激盪 |
| **software-brainstorming** | 軟體架構和功能規劃的結構化腦力激盪 |
| **paper** | 透過多代理 council 將研究論文和程式碼倉庫轉化為可重用的技能參考 |
| **continuous-learning** | 即時誤解檢測和溝通優化 |

詳見[技能指南](./skill-readme.md)。

## 建議添加 Anthropic 官方技能

本專案專注於為深度學習研究人員提供自訂技能。我們也建議添加 Anthropic 官方技能（如文檔處理、MCP 建構器等），請使用 Claude Code 插件系統添加：

```bash
# 添加所有 Anthropic 官方技能
claude plugin add anthropic/skills

# 或添加特定技能類別
claude plugin add anthropic/skills/document-skills
```

可用的 Anthropic 官方技能類別：
- **document-skills**：PDF、DOCX、PPTX、XLSX 操作和分析
- **example-skills**：skill-creator、mcp-builder 及其他進階工具

更多資訊請訪問 [Anthropic Skills Repository](https://github.com/anthropics/skills)。

## 致謝

本專案受到以下專案的啟發：

- [anthropics/skills](https://github.com/anthropics/skills) - Anthropic 官方技能專案
- [everything-claude-code](https://github.com/affaan-m/everything-claude-code) - Anthropic 黑客松獲獎者的完整 Claude Code 配置集合
- [obra/superpowers](https://github.com/obra/superpowers) - Superpowers 技能集合
- [K-Dense-AI/claude-scientific-skills](https://github.com/K-Dense-AI/claude-scientific-skills/tree/main) - Claude 科學技能
- [muratcankoylan/Agent-Skills-for-Context-Engineering](https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering) - Agent 技能與 Context 工程
