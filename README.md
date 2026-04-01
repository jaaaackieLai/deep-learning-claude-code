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
| `/commit` | Analyze uncommitted changes and create small, focused commits grouped by functionality |
| `/merge-worktree` | Merge the current worktree branch into main and clean up |

See [Command Guide](docs/en/command-readme.md) for details.

### Skills

Extend Claude's capabilities with specialized knowledge:

| Skill | Purpose |
|-------|---------|
| **scientific-brainstorming** | Structured brainstorming for research hypotheses and experimental design |
| **software-brainstorming** | Structured brainstorming for software architecture and feature planning |
| **paper** | Transform research papers and code repos into reusable skill references via multi-agent council |
| **continuous-learning** | Real-time misunderstanding detection and communication optimization |
| **autoresearch** | Autonomous experiment loop: modify code, train, evaluate, keep/discard, repeat indefinitely |

See [Skill Guide](docs/en/skill-readme.md) for details.

### Rules

Reusable rule files for consistent code style. Copy them to your project's `rules/` directory or `~/.claude/rules/` for global use.

| Rule | Purpose |
|------|---------|
| **coding-style** | Python coding conventions for deep learning projects: GPU setup, type hints, `match` statements, `tqdm` progress bars, Ray Tune subprocess pattern, etc. |
| **comment-style** | Comment guidelines based on "comment why, not what": function docs, design comments, why comments, teacher comments, and anti-patterns to avoid |

**Setup:**

```bash
# Project-level (applies to one project)
cp rules/*.md /path/to/your-project/rules/

# User-level (applies to all projects)
cp rules/*.md ~/.claude/rules/
```

### Claude Settings

Template CLAUDE.md files and a status line script. Copy and customize for your own setup.

| File | Purpose |
|------|---------|
| **user-CLAUDE.md** | User-level `~/.claude/CLAUDE.md` template: TDD cycle, Tidy First, commit rules, agent auto-dispatch, code quality standards |
| **project-CLAUDE.md** | Project-level `CLAUDE.md` template: project structure, code style, testing, security, git workflow |
| **statusline.sh** | Custom status line showing model, context usage, and rate limit bars |

**CLAUDE.md setup:**

```bash
# User-level (global instructions for all projects)
cp claude-settings/user-CLAUDE.md ~/.claude/CLAUDE.md

# Project-level (edit to fit your project)
cp claude-settings/project-CLAUDE.md /path/to/your-project/CLAUDE.md
```

**Status line setup:**

1. Copy the script:
   ```bash
   cp claude-settings/statusline.sh ~/.claude/statusline.sh
   chmod +x ~/.claude/statusline.sh
   ```

2. Add to `~/.claude/settings.json`:
   ```json
   {
     "statusLine": {
       "type": "command",
       "command": "bash ~/.claude/statusline.sh"
     }
   }
   ```

**Requirements:** `bash`, `jq`

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
