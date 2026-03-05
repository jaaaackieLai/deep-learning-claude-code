# Agent Explanations

This document explains the purpose and use cases of each agent in the marketplace.

---

## Overview

Agents are behavior-shaping tools that change HOW Claude works, not what it knows. They are automatically dispatched when trigger conditions are met -- no manual invocation needed.

---

## planner

**Purpose**: Expert planning specialist for complex features and refactoring

**Auto-trigger when**:
- User requests new feature implementation
- Planning complex refactoring across multiple files
- Architectural changes or migrations
- Any task requiring 3+ steps

**What it does**:
- Restates requirements in clear terms
- Breaks down into phased implementation steps
- Identifies dependencies between components
- Assesses risks and potential blockers
- Estimates complexity (High/Medium/Low)
- **Waits for user confirmation before proceeding**

**Output format**: Structured plan with phases, steps, dependencies, risks, and testing strategy

**Integrated Skills**: `brainstorming/software-brainstorming` for requirements exploration

**Eval Result**: 100% vs 50% baseline (plans without this agent lack phases, dependencies, and test plans)

---

## tdd-guide

**Purpose**: Test-Driven Development specialist enforcing write-tests-first methodology

**Auto-trigger when**:
- Implementing any new feature
- Fixing bugs or defects
- Refactoring existing code
- Any task that produces code

**What it does**:
- Scaffolds interfaces and type definitions first
- Writes failing tests (RED phase)
- Implements minimal code to pass (GREEN phase)
- Refactors while keeping tests green (REFACTOR phase)
- Verifies 80%+ test coverage

**TDD Cycle**:
```
RED -> GREEN -> REFACTOR -> REPEAT
```

**Coverage Requirements**:
- 80% minimum for all code
- 100% for critical business logic

**Eval Result**: 100% vs 0% baseline (without this agent, Claude defaults to implementation-first with no tests)

---

## analyzer

**Purpose**: Systematic analysis specialist that isolates variables and evaluates outcomes like a scientist

**Auto-trigger when**:
- Analyzing experiment results or benchmark data
- Debugging performance regressions or unexpected behavior
- Comparing two or more approaches, configurations, or implementations
- Understanding why a model, system, or process behaves a certain way
- Evaluating trade-offs between options

**Core Principle**: One variable at a time
1. Identify all variables that could affect the outcome
2. Hold all variables constant except the one under investigation
3. Measure the outcome with that single change
4. Record the result before moving to the next variable

**Output format**:
```markdown
# Analysis: [Question]
## Setup (baseline, metric, variables)
## Results (table with deltas)
## Key Findings
## Confounds & Limitations
## Recommendation
```

**Analysis types**:
- Performance analysis
- Debugging / Root cause analysis
- Comparison analysis
- Experiment result analysis

**Integrated Skills**: `brainstorming/scientific-brainstorming` for hypothesis generation

**Eval Result**: 100% vs 75% baseline (ensures rigorous experimental thinking, avoids premature conclusions)

---

## Dispatch Rules

- If a task matches multiple agents, use them in sequence: **planner** (plan) -> **tdd-guide** (implement) -> **analyzer** (evaluate)
- For independent subtasks, dispatch multiple agents in parallel
- Agents can be combined with brainstorming skills: planner uses software-brainstorming, analyzer uses scientific-brainstorming

---

## Agent Structure

All agents are defined as Markdown files in `agents/` with YAML frontmatter:

```yaml
---
name: agent-name
description: Brief description with auto-trigger conditions
tools: ["Read", "Grep", "Glob", "Bash", "Write", "Edit"]
model: opus
skills:
  - skill-name
---
```
