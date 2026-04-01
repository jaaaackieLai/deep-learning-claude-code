# Command Explanations

This document explains the purpose and use cases of each command in the marketplace.

---

## Overview

Commands are slash-invoked workflows that trigger specific agents or processes. Use them as shortcuts for common development tasks.

---

## /plan

**Purpose**: Create an implementation plan before writing any code

**Invokes**: `planner` agent

**When to use**:
- Starting a new feature
- Making significant architectural changes
- Working on complex refactoring
- Multiple files/components will be affected
- Requirements are unclear or ambiguous

**What happens**:
1. Restates requirements in clear terms
2. Breaks down into phases with specific steps
3. Identifies dependencies between components
4. Assesses risks and blockers
5. **Waits for your confirmation before proceeding**

**Example**:
```
/plan I need to add real-time notifications when markets resolve
```

---

## /tdd

**Purpose**: Enforce test-driven development workflow

**Invokes**: `tdd-guide` agent

**When to use**:
- Implementing new features
- Adding new functions/components
- Fixing bugs (write test that reproduces bug first)
- Refactoring existing code

**What happens**:
1. Scaffolds interfaces for inputs/outputs
2. Writes failing tests (RED)
3. Verifies tests fail for the right reason
4. Implements minimal code to pass (GREEN)
5. Refactors while keeping tests green
6. Checks coverage (target: 80%+)

**Example**:
```
/plan I need a function to calculate market liquidity score
```

---

## /test-coverage

**Purpose**: Analyze test coverage and generate missing tests

**When to use**:
- After implementing a feature
- Before releasing or merging
- When coverage falls below 80%

**What happens**:
1. Runs tests with coverage reporting
2. Identifies files below 80% threshold
3. Analyzes untested code paths
4. Generates unit, integration, and E2E tests
5. Verifies new tests pass
6. Shows before/after coverage metrics

---

## /update-codemaps

**Purpose**: Scan codebase structure and update architecture documentation

**When to use**:
- After major features have been added
- When architecture has changed
- Before releasing new versions
- Periodic documentation maintenance

**What happens**:
1. Scans all source files for imports, exports, and dependencies
2. Generates token-lean codemaps (architecture, backend, frontend, data)
3. Calculates diff percentage from previous version
4. Requests approval if changes > 30%
5. Adds freshness timestamps

---

## /update-docs

**Purpose**: Sync documentation from source-of-truth files

**When to use**:
- After changing project configuration
- When environment variables change
- Before onboarding new contributors

**What happens**:
1. Reads package.json scripts and generates reference table
2. Reads .env.example and documents environment variables
3. Generates CONTRIB.md (development workflow, scripts, setup)
4. Generates RUNBOOK.md (deployment, monitoring, rollback)
5. Identifies obsolete documentation (90+ days without update)

---

## /commit

**Purpose**: Analyze all uncommitted changes and create small, focused commits grouped by functionality

**When to use**:
- After completing work that touches multiple files
- When you want clean, well-organized commit history
- Instead of a single large "WIP" commit

**What happens**:
1. Surveys all changes (staged, unstaged, untracked)
2. Classifies changes into commit groups by type (docs, feat, fix, refactor, test, chore, style)
3. Presents a numbered plan table
4. Executes commits in order with conventional commit messages
5. Shows final git log

**Notes**:
- Follows Tidy First: notes mixed structural/behavioral changes but does not split a single file's diff
- Never uses `git add -A` -- adds specific files only
- Warns about files that may contain secrets

---

## /merge-worktree

**Purpose**: Merge the current worktree branch into main and clean up

**When to use**:
- After finishing work in a git worktree
- When ready to integrate a worktree branch back into main

**What happens**:
1. Verifies you are in a worktree (not main working tree)
2. Commits any uncommitted changes (invokes `/commit` if needed)
3. Shows commits to be merged, asks for confirmation
4. Merges into main with `--no-ff`
5. Removes the worktree and deletes the branch
6. Reports final status

**Notes**:
- Stops and reports if merge conflicts occur (does not force-resolve)
- Asks before force-removing worktrees with untracked files

---

## Recommended Workflow

For feature development, combine commands in this order:

1. `/plan` - Understand what to build, get confirmation
2. `/tdd` - Implement with test-first methodology
3. `/test-coverage` - Verify coverage meets threshold
4. `/update-docs` - Keep documentation current
5. `/commit` - Create clean, focused commits
