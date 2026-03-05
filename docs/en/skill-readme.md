# Skill Explanations

This document explains the purpose and use cases of each skill in the marketplace.

---

## Overview

The Claude Code Marketplace provides a curated collection of skills organized by category. Skills extend Claude's capabilities with specialized knowledge, workflows, and tool integrations tailored for deep learning researchers and Python developers.

---

## Brainstorming

### scientific-brainstorming

**Purpose**: Structured brainstorming for scientific research

**Use Cases**:
- Research question formulation
- Hypothesis generation
- Experimental design brainstorming
- Methodology exploration
- Literature gap identification
- Interdisciplinary connection discovery

**How It Works**:
- Guides collaborative idea exploration through structured dialogue
- One question at a time, multiple approaches
- Incremental validation of ideas
- References established brainstorming methods

**Structure**:
- `SKILL.md` - Main skill definition and workflow
- `references/brainstorming_methods.md` - Brainstorming methodology reference

**Target Users**: Deep learning researchers, scientists

### software-brainstorming

**Purpose**: Structured brainstorming for software development projects

**Use Cases**:
- Feature ideation and planning
- Architecture design exploration
- Problem-solving for technical challenges
- API design discussions
- Technology stack selection

**How It Works**:
- Explores software design requirements, architecture, and technical constraints
- Structured dialogue before implementation begins
- Multiple approach evaluation

**Structure**:
- `SKILL.md` - Main skill definition and workflow

**Target Users**: Software developers, engineering teams

---

## paper

**Purpose**: Transform research papers and their code repositories into high-quality reusable skills through multi-agent council deliberation

**Use Cases**:
- Package a research paper with its implementation code into a structured skill
- Create a quick-reference guide for understanding and applying a specific paper
- Build a reusable skill that captures a paper's problem, solution, and contributions
- Analyze paper-code alignment (what the paper claims vs. what the code implements)

**How It Works**:

The skill uses a 5-phase council deliberation process:

1. **Phase 0 - Information Gathering**: Reads the paper PDF (via `/pdf`), clones the GitHub repo, and prepares shared context
2. **Phase 1 - Independent Specialist Analysis**: 3 analysts run in parallel:
   - **Analyst A** (Theory & Method): Research methodology, mathematical formulations, experimental design
   - **Analyst B** (Literature & Concepts): Terminology, related work, field positioning, novelty assessment
   - **Analyst C** (Code & Practice): Repository structure, setup guide, usage patterns, reproducibility
3. **Phase 2 - Anonymized Peer Review**: Each analyst reviews the other two analyses without knowing who produced them. Scores on accuracy, completeness, clarity, and usefulness (1-5 scale).
4. **Phase 3 - Chairman Synthesis**: A chairman agent receives all analyses, peer reviews, and quality scores, then synthesizes the best content weighted by aggregate scores.
5. **Phase 4 - Write Skill Files**: Outputs 4 structured files to `skills/<paper-name>/`:
   - `SKILL.md` - Entry point with summary, key concepts, quick start
   - `references/paper_summary.md` - Comprehensive paper analysis
   - `references/key_concepts.md` - Concept reference with math formulations
   - `references/code_guide.md` - Practical code usage guide

**Modes**:
- **Claude-only** (default): All agents run as Claude Task subagents. No external dependencies.
- **Multi-model** (user-requested): Uses Claude, GPT, and Gemini via MCP servers for true model diversity.

**Inputs Required**:
- Path to the paper PDF file
- GitHub URL of the implementation repository

**Structure**:
- `SKILL.md` - Main workflow definition
- `references/analyst-roles.md` - Specialist role definitions and prompt templates
- `references/peer-review-protocol.md` - Anonymized review process and scoring
- `references/synthesis-guide.md` - Chairman instructions for final synthesis
- `references/skill-output-templates.md` - Templates for the 4 generated skill files

**Target Users**: Deep learning researchers who want to quickly understand and apply new papers

---

## continuous-learning

**Purpose**: Real-time misunderstanding detection and communication optimization system

**Core Features**:
- **Real-time Misunderstanding Detection**: Automatically captures corrections as they happen
- **Lightweight Analysis**: Analyzes only last 5 turns (not entire session)
- **High Token Efficiency**: Saves 80-90% token cost compared to traditional approaches
- **Automatic Background Execution**: Uses Haiku model for background analysis (no manual trigger needed)
- **Generates Clarification Hints**: Concise 50-100 word communication guidelines

**Detection Patterns**:
1. **Rapid Re-edit**: Same file edited multiple times in short period
2. **Error Recovery**: Error followed by successful fix pattern
3. **Repeated Tool**: Same tool used 3+ times consecutively
4. **Iterative Correction**: Rapid back-and-forth on tasks

**Architecture**:
- Observation hooks (PreToolUse/PostToolUse) capture tool usage
- Heuristic detection identifies correction patterns
- Background trigger for lightweight analysis (Haiku)
- Generates and stores clarification hints

**Token Efficiency Comparison**:
| Approach | Cost per Analysis | Trigger | Efficiency |
|----------|------------------|---------|------------|
| Traditional | 6-23K tokens | Manual | Baseline |
| **This system** | **1-2.5K tokens** | **Automatic** | **5-10x** |

**Usage**:
1. Configure hooks (see `skills/continuous-learning/USAGE_GUIDE.md`)
2. System runs automatically, no manual action needed
3. View generated hints: `~/.claude/homunculus/clarifications/`
4. Test functionality: `python3 skills/continuous-learning/scripts/test-clarification.py`

**Structure**:
- `SKILL.md` - Skill description and entry point
- `USAGE_GUIDE.md` - Complete setup and usage guide
- `agents/observer.md` - Background observer agent
- `hooks/observe.sh` - Observation hook script
- `scripts/` - Analysis and testing scripts
- `config.json` - Configuration

**Target Users**: All users who want to reduce communication overhead

---

## Summary Table

| Skill Category | Skills | Status | Target Audience |
|----------------|--------|--------|-----------------|
| **Brainstorming** | scientific-brainstorming, software-brainstorming | Available | Developers, researchers |
| **Research** | paper | Available | Deep learning researchers |
| **Learning** | continuous-learning | Available | All users |

---

## Getting Started

### For Deep Learning Researchers

**Recommended Skills**:
1. **paper** - Transform papers and code repos into reusable skill references
2. **scientific-brainstorming** - For generating research hypotheses and experimental ideas
3. **continuous-learning** - Reduce communication misunderstandings, improve collaboration efficiency

### For Software Developers

**Recommended Skills**:
1. **software-brainstorming** - For feature planning and architecture exploration
2. **continuous-learning** - Automatically learns your communication patterns, reduces overhead

---

## Documentation

Each skill includes:
- **SKILL.md** - Main documentation and entry point
- **References** - Comprehensive reference materials (where applicable)

For specific skill usage, refer to the individual SKILL.md files in the `skills/` directory.
