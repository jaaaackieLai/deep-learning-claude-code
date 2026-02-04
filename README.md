**Language:** English | [繁體中文](docs/zh-TW/README.md)

# Deep-learning-claude-code
This repository includes commands, hooks, agents, and skills, which I commonly use.

I hope that this repo can help software engineers who use Python in deep learning work, and other settings can make your work flow more smoothly.

Follow the [plugin-marketplaces](https://code.claude.com/docs/en/plugin-marketplaces) and [skills](https://code.claude.com/docs/en/skills) instructions provided by Anthropic.

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
- [obra/superpowers](https://github.com/obra/superpowers) - Superpowers skills collection
- [muratcankoylan/Agent-Skills-for-Context-Engineering](https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering) - Agent skills for context engineering
- [K-Dense-AI/claude-scientific-skills](https://github.com/K-Dense-AI/claude-scientific-skills/tree/main) - Scientific skills for Claude
- [KentBeck/BPlusTree3](https://github.com/KentBeck/BPlusTree3/tree/main/rust/docs) - Kent Beck's BPlusTree documentation approach
- [everything-claude-code](https://github.com/affaan-m/everything-claude-code)

