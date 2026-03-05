# Agents for Deep Learning Research

This directory contains specialized agents designed for Python-based deep learning research workflows.

## Available Agents

### [analyzer.md](analyzer.md)
**Systematic Analysis Specialist**

Isolates variables and evaluates outcomes like a scientist. Enforces one-variable-at-a-time methodology.

**Auto-trigger when:**
- Analyzing experiment results or benchmark data
- Debugging performance regressions
- Comparing approaches, configurations, or implementations
- Root-cause analysis of failures
- Evaluating trade-offs between options

**Integrated Skills:**
- `brainstorming/scientific-brainstorming` - Hypothesis generation

---

### [planner.md](planner.md)
**Implementation Planning Specialist**

Creates comprehensive, actionable implementation plans for complex features and refactoring.

**Auto-trigger when:**
- Implementing new features (3+ steps)
- Planning complex refactoring across multiple files
- Architectural changes or migrations
- Breaking down tasks with dependencies

**Integrated Skills:**
- `brainstorming/software-brainstorming` - Requirements exploration

---

### [tdd-guide.md](tdd-guide.md)
**Test-Driven Development Specialist**

Enforces test-first methodology with comprehensive coverage (80%+) using pytest.

**Auto-trigger when:**
- Implementing any new feature
- Fixing bugs or defects
- Refactoring existing code

---

## Agent Structure

All agents follow a standardized structure:

```yaml
---
name: agent-name
description: Brief description with usage triggers
tools: ["Read", "Grep", "Glob", "Bash", "Write", "Edit"]
model: opus
skills:
  - skill-name-1
---
```

### Standard Sections

1. **When to Use This Agent** - Clear usage criteria
2. **Your Role** - Agent responsibilities
3. **Core Workflow** - Main process description
4. **Checklists** - Actionable items
5. **Best Practices** - Guidelines and principles

---

## Usage Patterns

### Sequential Workflow
For feature development:
1. **planner** -> Plan the implementation
2. **tdd-guide** -> Write tests first, then implement
3. **analyzer** -> Evaluate results if needed

### Parallel Workflow
For independent analysis tasks:
- **analyzer** (task A) + **analyzer** (task B) -> Compare results

### Dispatch Rules
- If a task matches multiple agents, use them in sequence: planner -> tdd-guide -> analyzer
- For independent subtasks, dispatch multiple agents in parallel
- Agents can be combined with brainstorming skills

---

## Target Audience

These agents are optimized for:
- Python software development
- Deep learning research
- Scientific computing
- Data science workflows
