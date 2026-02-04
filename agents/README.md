# Agents for Deep Learning Research

This directory contains specialized agents designed for Python-based deep learning research workflows.

## Available Agents

### 🏗️ [architect.md](architect.md)
**Software Architecture Specialist**

Design scalable, maintainable system architecture for new features and refactoring.

**Use when:**
- Planning architecture for new features
- Making critical technical decisions
- Evaluating scalability bottlenecks
- Creating Architecture Decision Records (ADRs)

**Integrated Skills:**
- `brainstorming/software-brainstorming` - Creative architecture exploration
- `scientific-critical-thinking` - Systematic trade-off evaluation

---

### 🔍 [code-reviewer.md](code-reviewer.md)
**Python Code Reviewer for Deep Learning**

Expert reviewer ensuring Pythonic code, PEP 8 compliance, security, and ML best practices.

**MANDATORY use when:**
- Any Python code has been written or modified
- Before committing code changes
- Before opening pull requests

**Integrated Skills:**
- `python-skills/testing` - Test code quality review
- `python-skills/patterns` - Design pattern validation
- `python-skills/pytorch` - PyTorch-specific best practices
- `scientific-critical-thinking` - Systematic quality evaluation

---

### 📋 [planner.md](planner.md)
**Implementation Planning Specialist**

Create comprehensive, actionable implementation plans for complex features and refactoring.

**Use when:**
- Implementing new features
- Planning complex refactoring
- Breaking down architectural changes
- Analyzing task dependencies

**Integrated Skills:**
- `brainstorming/software-brainstorming` - Requirements exploration
- `git-skills` - Git workflow integration

---

### ✅ [tdd-guide.md](tdd-guide.md)
**Test-Driven Development Specialist**

Enforce test-first methodology with comprehensive coverage (80%+) using pytest.

**MANDATORY use when:**
- Implementing any new feature
- Fixing bugs or defects
- Refactoring existing code

**Integrated Skills:**
- `python-skills/testing` - pytest best practices
- `python-skills/patterns` - Testable design patterns

---

### 📚 [doc-updater.md](doc-updater.md)
**Documentation & Codemap Specialist**

Keep codemaps and documentation current with the codebase state.

**Use when:**
- Major features have been added
- Architecture has changed
- Before releasing new versions
- Weekly documentation maintenance

**Integrated Skills:**
- `git-skills` - Understanding recent changes

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
  - skill-name-2
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
1. **planner** → Plan the implementation
2. **tdd-guide** → Write tests first
3. **architect** → Design system integration (if needed)
4. **code-reviewer** → Review implementation
5. **doc-updater** → Update documentation

### Parallel Workflow
For code review:
- **code-reviewer** + **tdd-guide** → Review code and test quality simultaneously

### Iterative Workflow
For refactoring:
1. **architect** → Design refactoring strategy
2. **planner** → Break down into steps
3. **tdd-guide** → Ensure test coverage
4. **code-reviewer** → Validate quality

---

## Integration with Skills

Each agent recommends specific skills for enhanced capability:

| Agent | Recommended Skills | Purpose |
|-------|-------------------|---------|
| architect | brainstorming, critical-thinking | Design exploration & evaluation |
| code-reviewer | testing, patterns, pytorch, critical-thinking | Comprehensive quality review |
| planner | brainstorming, git-skills | Requirements & workflow integration |
| tdd-guide | testing, patterns | Test-first development |
| doc-updater | git-skills | Change tracking |

---

## Best Practices

### 1. Use Agents Proactively
Don't wait for problems - use agents during planning and development.

### 2. Combine Agents for Complex Tasks
Multiple agents can work together for comprehensive coverage.

### 3. Integrate with Skills
Leverage recommended skills for deeper domain expertise.

### 4. Follow TDD Workflow
Always use `tdd-guide` before writing implementation code.

### 5. Review Before Commit
Always use `code-reviewer` before committing Python code.

---

## Target Audience

These agents are optimized for:
- 🐍 Python software development
- 🧠 Deep learning research
- 🔬 Scientific computing
- 📊 Data science workflows

---

## Maintenance

Agents should be updated when:
- Python ecosystem evolves (new frameworks, tools)
- Best practices change
- Team workflow patterns emerge
- Deep learning methodologies advance

**Last Updated:** 2026-02-04
