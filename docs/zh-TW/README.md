**語言：** [English](../../README.md) | 繁體中文

# Deep-learning-claude-code
本專案包含我常用的 commands、hooks、agents 和 skills。

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

## 技能指南

本專案包含為深度學習研究人員和 Python 開發者量身打造的各種技能。如需了解每個技能類別的詳細說明及使用方法，請查看[技能說明](./skill-readme.md)。

這些指南提供全面的資訊，包括：
- 文檔處理技能（PDF、DOCX、PPTX、XLSX）
- 上下文工程基礎
- 開發工作流程的超能力
- 程式碼審查和專案管理工具

## 建議添加 Anthropic 官方技能

本專案專注於為深度學習研究人員提供自訂技能。我們也建議添加 Anthropic 官方技能（如文檔處理、MCP 建構器等），請使用 Claude Code 插件系統添加：

```bash
# 添加所有 Anthropic 官方技能
claude plugin add anthropic/skills

# 或添加特定技能類別
claude plugin add anthropic/skills/document-skills
claude plugin add anthropic/skills/example-skills
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
