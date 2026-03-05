**Language:** English | [繁體中文](docs/zh-TW/README.md)

# Deep-learning-claude-code
This repository includes commands, agents, and skills, which I commonly use.

I hope that this repo can help software engineers who use Python in deep learning work, and other settings can make your work flow more smoothly.

Follow the [plugin-marketplaces](https://code.claude.com/docs/en/plugin-marketplaces) and [skills](https://code.claude.com/docs/en/skills) instructions provided by Anthropic.

## Installation

You can install this plugin marketplace in two ways:

**In Claude Code CLI:**
```
/plugin add jaaaackieLai/deep-learning-claude-code
```

**In Terminal:**
```bash
claude plugin add jaaaackieLai/deep-learning-claude-code
```

## What's Included

### Agents

Specialized agents that change how Claude works on your tasks:

| Agent | Purpose |
|-------|---------|
| **planner** | Creates phased implementation plans with dependencies and risk assessment |
| **tdd-guide** | Enforces test-driven development (Red/Green/Refactor) with 80%+ coverage |
| **analyzer** | Systematic analysis using one-variable-at-a-time methodology |

See [Agent Guide](docs/en/agent-readme.md) for details.

### Commands

Slash commands for common workflows:

| Command | Purpose |
|---------|---------|
| `/plan` | Create an implementation plan before coding |
| `/tdd` | Start a TDD session with test-first methodology |
| `/test-coverage` | Analyze coverage and generate missing tests |
| `/update-codemaps` | Scan codebase and update architecture docs |
| `/update-docs` | Sync documentation from source-of-truth |

See [Command Guide](docs/en/command-readme.md) for details.

### Skills

Extend Claude's capabilities with specialized knowledge:

| Skill | Purpose |
|-------|---------|
| **scientific-brainstorming** | Structured brainstorming for research hypotheses and experimental design |
| **software-brainstorming** | Structured brainstorming for software architecture and feature planning |
| **paper** | Transform research papers and code repos into reusable skill references via multi-agent council |
| **continuous-learning** | Real-time misunderstanding detection and communication optimization |

See [Skill Guide](docs/en/skill-readme.md) for details.

## Official Anthropic Skills

This repository focuses on custom skills for deep learning researchers. We also recommend adding official Anthropic skills (like document processing, MCP builders, etc.) using the Claude Code plugin system:

```bash
# Add all Anthropic official skills
claude plugin add anthropic/skills

# Or add specific skill categories
claude plugin add anthropic/skills/document-skills
```

Available official Anthropic skill categories:
- **document-skills**: PDF, DOCX, PPTX, XLSX manipulation and analysis
- **example-skills**: skill-creator, mcp-builder, and other advanced tools

For more information, visit the [Anthropic Skills Repository](https://github.com/anthropics/skills).

## Acknowledgments

This repository was inspired by the following projects:

- [anthropics/skills](https://github.com/anthropics/skills) - Official skills repository from Anthropic
- [everything-claude-code](https://github.com/affaan-m/everything-claude-code) - The complete collection of Claude Code configs from an Anthropic hackathon winner
- [obra/superpowers](https://github.com/obra/superpowers) - Superpowers skills collection
- [K-Dense-AI/claude-scientific-skills](https://github.com/K-Dense-AI/claude-scientific-skills/tree/main) - Scientific skills for Claude
- [muratcankoylan/Agent-Skills-for-Context-Engineering](https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering) - Agent skills for context engineering
