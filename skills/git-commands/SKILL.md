---
name: git-commands
description: Quick reference for Git version control commands. Use when the user asks about Git commands, workflows, branch management, commit operations, or needs help with Git operations like creating branches, merging, resolving conflicts, or managing repositories.
---

# Git Commands Quick Reference

## Overview

This skill provides a comprehensive reference for commonly used Git commands, organized by workflow and use case. When users need Git command syntax or workflow guidance, refer to the detailed command reference in `references/commands.md`.

## Quick Command Categories

For detailed syntax and examples, see `references/commands.md`:

1. **初始化與配置** - `git init`, `git clone`, `git config`
2. **基本操作** - `git add`, `git commit`, `git status`, `git diff`
3. **分支管理** - `git branch`, `git checkout`, `git switch`, `git merge`
4. **遠端操作** - `git remote`, `git push`, `git pull`, `git fetch`
5. **歷史查看** - `git log`, `git show`, `git blame`
6. **撤銷修改** - `git reset`, `git revert`, `git restore`
7. **進階操作** - `git stash`, `git rebase`, `git cherry-pick`, `git tag`

## Common Workflows

### 新專案開始
```bash
git init
git add .
git commit -m "Initial commit"
```

### 功能開發流程（使用分支）
```bash
git checkout -b feature/new-feature
# 開發並測試
git add .
git commit -m "Add new feature"
git checkout main
git merge feature/new-feature
```

### 同步遠端倉庫
```bash
git pull origin main
# 進行修改
git add .
git commit -m "Update description"
git push origin main
```

## When to Refer to Full Reference

Load `references/commands.md` when users need:
- Detailed command syntax and parameters
- Specific examples for complex operations
- Multiple alternative approaches
- Troubleshooting guidance
