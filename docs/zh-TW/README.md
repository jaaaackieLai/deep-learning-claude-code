**語言：** [English](../../README.md) | 繁體中文

# Deep-learning-claude-code
本專案包含我常用的 commands、hooks、agents 和 skills。

希望此專案能幫助使用 Python 進行深度學習工作的軟體工程師，以及其他設定能使你的工作流程更加順暢。

請遵循 Anthropic 提供的 [plugin-marketplaces](https://code.claude.com/docs/en/plugin-marketplaces) 和 [skills](https://code.claude.com/docs/en/skills) 說明。

## 新增 Anthropic 官方技能

本專案專注於為深度學習研究人員提供自訂技能。若要使用 Anthropic 官方技能（如文檔處理、MCP 建構器等），請使用 Claude Code 插件系統添加：

```bash
# 添加所有 Anthropic 官方技能
claude plugin add anthropic/skills

# 或添加特定技能類別
claude plugin add anthropic/skills/document-skills
claude plugin add anthropic/skills/anthropic-skills
```

可用的 Anthropic 官方技能類別：
- **document-skills**：PDF、DOCX、PPTX、XLSX 操作和分析
- **anthropic-skills**：skill-creator、mcp-builder 及其他進階工具

更多資訊請訪問 [Anthropic Skills Repository](https://github.com/anthropics/skills)。

## 致謝

本專案受到以下專案的啟發：

- [anthropics/skills](https://github.com/anthropics/skills) - Anthropic 官方技能專案
- [obra/superpowers](https://github.com/obra/superpowers) - Superpowers 技能集合
- [muratcankoylan/Agent-Skills-for-Context-Engineering](https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering) - Agent 技能與 Context 工程
- [K-Dense-AI/claude-scientific-skills](https://github.com/K-Dense-AI/claude-scientific-skills/tree/main) - Claude 科學技能
- [KentBeck/BPlusTree3](https://github.com/KentBeck/BPlusTree3/tree/main/rust/docs) - Kent Beck 的 BPlusTree 文檔方法
- [everything-claude-code](https://github.com/affaan-m/everything-claude-code)
