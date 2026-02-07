---
name: git-skills
description: Quick reference for Git version control commands. Use when the user asks about Git commands, workflows, branch management, commit operations, or needs help with Git operations like creating branches, merging, resolving conflicts, or managing repositories.
---

# Git Commands Quick Reference

## Overview

This skill provides a comprehensive reference for commonly used Git commands, organized by topic and use case. All commands are documented in detail in the references directory.

## Quick Command Reference

### [基礎操作](references/basics.md)
初始化、配置和日常基本操作
- `git init`, `git clone` - 初始化倉庫
- `git config` - 配置設定
- `git add`, `git commit` - 暫存和提交
- `git status`, `git diff` - 查看狀態和差異

### [分支管理](references/branching.md)
創建、切換、合併和管理分支
- `git branch` - 管理分支
- `git checkout`, `git switch` - 切換分支
- `git merge` - 合併分支
- 合併衝突處理

### [遠端操作](references/remote.md)
與遠端倉庫互動
- `git remote` - 管理遠端倉庫
- `git fetch`, `git pull` - 下載更新
- `git push` - 推送變更
- 同步 Fork 的專案

### [歷史查看](references/history.md)
查看提交歷史和檔案變更
- `git log` - 查看提交歷史
- `git show` - 查看 commit 詳情
- `git blame` - 追蹤檔案變更
- `git reflog` - 查看操作歷史

### [撤銷修改](references/undo.md)
撤銷和恢復操作
- `git restore` - 還原檔案
- `git reset` - 重置 commit
- `git revert` - 安全的撤銷
- 恢復誤刪的內容

### [進階操作](references/advanced.md)
進階功能和技巧
- `git stash` - 暫存工作進度
- `git worktree` - 平行工作目錄
- `git rebase` - 變基
- `git cherry-pick` - 挑選 commit
- `git tag` - 標籤管理
- `git submodule` - 子模組管理

### [.gitignore](references/gitignore.md)
忽略檔案配置
- 語法規則
- 常見範例
- 最佳實踐

### [疑難排解](references/troubleshooting.md)
常見問題解決方案
- 撤銷與恢復
- 合併衝突
- 遠端問題
- 效能優化

### [工作流程](references/workflows.md)
完整的工作流程範例
- Feature Branch Workflow
- Git Flow
- GitHub Flow
- 日常協作流程

## Common Workflows

### 新專案開始
```bash
git init
git add .
git commit -m "Initial commit"
```

### 功能開發流程
```bash
# 創建功能分支
git checkout -b feature/new-feature

# 開發並測試
git add .
git commit -m "Add new feature"

# 合併回主分支
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

### 解決合併衝突
```bash
# 1. 查看衝突檔案
git status

# 2. 手動編輯解決衝突
# 3. 標記為已解決
git add <resolved-files>

# 4. 完成合併
git commit
```

## Quick Tips

### 查看狀態和歷史
```bash
git status                      # 工作區狀態
git log --oneline --graph       # 簡潔的歷史圖
git diff                        # 查看變更
```

### 撤銷操作
```bash
git restore <file>              # 還原工作區檔案
git restore --staged <file>     # 取消暫存
git reset --soft HEAD~1         # 撤銷 commit，保留變更
```

### 分支操作
```bash
git branch                      # 列出分支
git switch -c <branch>          # 創建並切換分支
git switch -                    # 切換回上一個分支
```

### 遠端操作
```bash
git fetch --prune               # 同步並清理遠端分支
git push -u origin <branch>     # 推送並設定上游
git pull --rebase               # 使用 rebase 拉取
```

## When to Use Each Reference

- **Quick lookup** → Use the quick reference above
- **Detailed syntax** → See specific reference documents
- **Solving problems** → Check [疑難排解](references/troubleshooting.md)
- **Learning workflows** → Read [工作流程](references/workflows.md)
- **Setting up .gitignore** → Refer to [.gitignore](references/gitignore.md)

## Navigation

All reference materials are organized in the `references/` directory:

```
references/
├── basics.md           # 基礎操作
├── branching.md        # 分支管理
├── remote.md           # 遠端操作
├── history.md          # 歷史查看
├── undo.md             # 撤銷修改
├── advanced.md         # 進階操作
├── gitignore.md        # .gitignore 配置
├── troubleshooting.md  # 疑難排解
└── workflows.md        # 工作流程
```

## Additional Resources

- [Pro Git Book](https://git-scm.com/book/zh-tw/v2) - 官方繁體中文書籍
- [GitHub Docs](https://docs.github.com) - GitHub 文檔
- [Atlassian Git Tutorials](https://www.atlassian.com/git/tutorials) - 詳細教學

---

**Note**: For specific command syntax and detailed examples, refer to the individual reference documents linked above.
