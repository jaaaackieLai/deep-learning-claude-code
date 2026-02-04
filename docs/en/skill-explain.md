# Skill Explanations

This document explains the purpose and use cases of each skill in the marketplace.

---

## 📚 Overview

The Claude Code Marketplace provides a curated collection of skills organized by category. Skills extend Claude's capabilities with specialized knowledge, workflows, and tool integrations tailored for deep learning researchers and Python developers.

---

## 🔧 Core Skills

### git-skills

**Purpose**: Comprehensive Git version control command reference

**Use Cases**:
- Quick lookup for Git commands and syntax
- Learning Git workflows (Feature Branch, Git Flow, GitHub Flow)
- Resolving Git problems and conflicts
- Managing branches, remotes, and repositories
- Understanding .gitignore configuration

**Structure**:
- Modular reference organized by topic
- 9 focused guides (basics, branching, remote, history, undo, advanced, gitignore, troubleshooting, workflows)
- Quick command reference in main SKILL.md

**Target Users**: All developers using version control

---

### scientific-critical-thinking

**Purpose**: Systematic framework for evaluating scientific rigor and research quality

**Use Cases**:
- Reviewing research papers and methodologies
- Assessing experimental design validity
- Identifying biases and confounding factors
- Evaluating statistical analyses and evidence quality
- Detecting logical fallacies in scientific arguments
- Planning rigorous research studies

**Core Capabilities**:
1. **Methodology Critique** - Evaluate study design and validity
2. **Bias Detection** - Identify cognitive, selection, measurement, and analysis biases
3. **Statistical Evaluation** - Assess statistical methods and interpretation
4. **Evidence Assessment** - Grade evidence quality using GRADE and Cochrane frameworks
5. **Fallacy Identification** - Detect logical errors in scientific claims
6. **Research Design** - Guidance for planning rigorous studies
7. **Claim Evaluation** - Systematically verify scientific claims

**Structure**:
- Modular guides for each capability
- Workflow templates (paper review, experiment design, claim verification)
- Comprehensive reference materials

**Target Users**: Deep learning researchers, scientists, academics

---

## 🧠 Brainstorming

### software-brainstorming

**Purpose**: Structured brainstorming for software development projects

**Use Cases**:
- Feature ideation and planning
- Architecture design exploration
- Problem-solving for technical challenges
- API design discussions
- Technology stack selection

**Target Users**: Software developers, engineering teams

### scientific-brainstorming

**Purpose**: Structured brainstorming for scientific research

**Use Cases**:
- Research question formulation
- Experimental design brainstorming
- Hypothesis generation
- Methodology exploration
- Literature gap identification

**Target Users**: Deep learning researchers, scientists

---

## 📄 Document Skills

**Source**: Anthropic Official Skills (`anthropic/skills`)

A comprehensive suite for document creation, editing, and analysis.

### pdf

**Purpose**: PDF manipulation and analysis toolkit

**Use Cases**:
- Extracting text and tables from PDFs
- Creating new PDF documents
- Merging and splitting PDFs
- Filling PDF forms programmatically
- Large-scale PDF processing

### docx

**Purpose**: Microsoft Word document creation and editing

**Use Cases**:
- Creating professional documents
- Editing existing Word files
- Working with tracked changes and comments
- Formatting preservation
- Text extraction and analysis

### pptx

**Purpose**: PowerPoint presentation creation and editing

**Use Cases**:
- Creating new presentations
- Modifying slide content and layouts
- Adding comments and speaker notes
- Extracting presentation data
- Batch presentation processing

### xlsx

**Purpose**: Excel spreadsheet creation, editing, and analysis

**Use Cases**:
- Creating spreadsheets with formulas and formatting
- Reading and analyzing data
- Modifying existing spreadsheets while preserving formulas
- Data visualization in spreadsheets
- Recalculating formulas

**Target Users**: Researchers needing to work with various document formats

---

## 🏗️ Anthropic Skills

**Source**: Anthropic Official Skills (`anthropic/skills`)

Official skills from Anthropic for advanced Claude Code usage.

### skill-creator

**Purpose**: Guide for creating effective custom skills

**Use Cases**:
- Designing new skills with specialized knowledge
- Implementing workflow automation
- Integrating tools and APIs
- Following skill development best practices
- Creating skills that extend Claude's capabilities

### mcp-builder

**Purpose**: Building high-quality MCP (Model Context Protocol) servers

**Use Cases**:
- Creating MCP servers for external service integration
- Designing well-structured tool interfaces
- Implementing Python (FastMCP) or TypeScript (MCP SDK) servers
- Enabling LLMs to interact with external services
- Building production-ready integrations

**Target Users**: Advanced users building custom integrations

---

## 🧮 Context Engineering

Advanced skills for AI agent developers (for future agent development).

### context-fundamentals

**Purpose**: Foundational concepts of context engineering for AI systems

**Concepts Covered**:
- Context anatomy (system prompts, tools, messages, observations)
- Attention mechanics and context windows
- Progressive disclosure principles
- Context quality vs. quantity

### context-compression

**Purpose**: Strategies for compressing context in long-running sessions

**Techniques**:
- Anchored iterative summarization
- Structured summary generation
- Tokens-per-task optimization
- Artifact trail management

### context-degradation

**Purpose**: Understanding and mitigating context failure patterns

**Patterns Covered**:
- Lost-in-middle phenomenon
- Context poisoning
- Context distraction and confusion
- Model-specific degradation thresholds

### context-optimization

**Purpose**: Techniques for extending effective context capacity

**Methods**:
- Compaction strategies
- Observation masking
- KV-cache optimization
- Context partitioning

**Target Users**: Future use when building AI agents

---

## 🐍 python-skills

**Purpose**: Python programming best practices and utilities

**Status**: To be documented (structure pending)

**Expected Use Cases**:
- Python coding conventions
- Library usage patterns
- Testing frameworks
- Debugging techniques
- Data processing workflows

**Target Users**: Deep learning researchers, Python developers

---

## 🔄 continuous-learning

**Purpose**: Instinct-based learning system that observes sessions and evolves behaviors

**Status**: ⚠️ **Not Yet Implemented**

**Planned Features**:
- Automatic pattern detection from Claude Code sessions
- Creation of atomic "instincts" with confidence scoring
- Evolution of instincts into skills/commands/agents
- Hook-based observation (100% reliable)
- Background agent analysis (using Haiku)

**Architecture**:
- Observation hooks (PreToolUse/PostToolUse)
- Pattern detection (user corrections, error resolutions, workflows)
- Confidence-weighted instincts (0.3-0.9)
- Instinct clustering and evolution

**Note**: This is an advanced feature planned for future implementation. The infrastructure exists but requires setup and customization for the target audience.

**Target Users**: Advanced users interested in personalized learning systems

---

## 📋 Summary Table

| Skill Category | Skills | Source | Status | Target Audience |
|----------------|--------|--------|--------|-----------------|
| **Version Control** | git-skills | Custom | ✅ Complete | All developers |
| **Research** | scientific-critical-thinking | Custom | ✅ Complete | Researchers, scientists |
| **Brainstorming** | software-brainstorming, scientific-brainstorming | Custom | ✅ Available | Developers, researchers |
| **Documents** | pdf, docx, pptx, xlsx | **Anthropic** | ✅ Available | All users |
| **Advanced** | skill-creator, mcp-builder | **Anthropic** | ✅ Available | Advanced users |
| **Context Engineering** | fundamentals, compression, degradation, optimization | Custom | ✅ Available | Future agent development |
| **Programming** | python-skills | Custom | 📝 Pending docs | Python developers |
| **Learning** | continuous-learning | Custom | ⚠️ Not implemented | Future feature |

---

## 🎯 Getting Started

### For Deep Learning Researchers

**Recommended Skills**:
1. **scientific-critical-thinking** - For reviewing papers and designing experiments
2. **git-skills** - For version control of code and experiments
3. **python-skills** - For Python development best practices
4. **document-skills** (xlsx, pdf) - For data analysis and documentation

### For Software Developers

**Recommended Skills**:
1. **git-skills** - Essential for version control
2. **software-brainstorming** - For feature planning and architecture
3. **skill-creator** - For creating custom skills

### For Advanced Users

**Recommended Skills**:
1. **mcp-builder** - For building service integrations
2. **context-engineering** - For future agent development
3. **continuous-learning** - Experimental (when implemented)

---

## 📖 Documentation

Each skill includes:
- **SKILL.md** - Main documentation and entry point
- **Guides** - Detailed how-to guides (where applicable)
- **References** - Comprehensive reference materials
- **Workflows** - Step-by-step workflow templates (where applicable)

For specific skill usage, refer to the individual SKILL.md files in the `skills/` directory.
