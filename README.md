**Language:** English | [繁體中文](docs/zh-TW/README.md)

# Deep-learning-claude-code
This repository includes commands, hooks, agents, and skills, which I commonly use.

I hope that this repo can help software engineers who use Python in deep learning work, and other settings can make your work flow more smoothly.

Follow the [plugin-marketplaces](https://code.claude.com/docs/en/plugin-marketplaces) and [skills](https://code.claude.com/docs/en/skills) instructions provided by Anthropic.

## Skills Guide

This repository includes various skills tailored for deep learning researchers and Python developers. For detailed explanations of each skill category and their usage:

- **English Guide**: [Skills Explanation](docs/en/skill-explain.md)
- **繁體中文指南**: [技能說明](docs/zh-TW/skill-explain.md)

These guides provide comprehensive information about:
- Document processing skills (PDF, DOCX, PPTX, XLSX)
- Context engineering fundamentals
- Superpowers for development workflows
- Code review and project management tools

## Adding Official Anthropic Skills

This repository focuses on custom skills for deep learning researchers. To use official Anthropic skills (like document processing, MCP builders, etc.), add them using the Claude Code plugin system:

```bash
# Add all Anthropic official skills
claude plugin add anthropic/skills

# Or add specific skill categories
claude plugin add anthropic/skills/document-skills
claude plugin add anthropic/skills/anthropic-skills
```

Available official Anthropic skill categories:
- **document-skills**: PDF, DOCX, PPTX, XLSX manipulation and analysis
- **anthropic-skills**: skill-creator, mcp-builder, and other advanced tools

For more information, visit the [Anthropic Skills Repository](https://github.com/anthropics/skills).

## Acknowledgments

This repository was inspired by the following projects:

- [anthropics/skills](https://github.com/anthropics/skills) - Official skills repository from Anthropic
- [everything-claude-code](https://github.com/affaan-m/everything-claude-code)
- [obra/superpowers](https://github.com/obra/superpowers) - Superpowers skills collection
- [K-Dense-AI/claude-scientific-skills](https://github.com/K-Dense-AI/claude-scientific-skills/tree/main) - Scientific skills for Claude
- [muratcankoylan/Agent-Skills-for-Context-Engineering](https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering) - Agent skills for context engineering

