# Git 分支管理

本文檔涵蓋 Git 分支的創建、切換、合併和管理。

## 分支操作

### git branch
管理分支。
```bash
# 查看分支
git branch                  # 列出本地分支
git branch -r               # 列出遠端分支
git branch -a               # 列出所有分支
git branch -v               # 顯示最後一次 commit

# 創建分支
git branch <branch-name>              # 創建新分支
git branch <branch-name> <commit>     # 從指定 commit 創建分支

# 刪除分支
git branch -d <branch-name>           # 刪除已合併的分支
git branch -D <branch-name>           # 強制刪除分支

# 重新命名分支
git branch -m <old-name> <new-name>   # 重新命名分支
git branch -m <new-name>              # 重新命名當前分支
```

### git checkout
切換分支或還原檔案（較舊的指令，建議使用 git switch 和 git restore）。
```bash
git checkout <branch>              # 切換分支
git checkout -b <branch>           # 創建並切換到新分支
git checkout <commit>              # 切換到特定 commit（detached HEAD）
git checkout -- <file>             # 還原檔案到最後一次 commit
```

### git switch
切換分支（Git 2.23+ 推薦使用）。
```bash
git switch <branch>                # 切換分支
git switch -c <branch>             # 創建並切換到新分支
git switch -                       # 切換回上一個分支
```

### git merge
合併分支。
```bash
git merge <branch>                 # 合併指定分支到當前分支
git merge --no-ff <branch>         # 強制創建 merge commit
git merge --squash <branch>        # 壓縮合併（不創建 merge commit）
git merge --abort                  # 取消合併（解決衝突時）
```

---

## 合併衝突處理

當兩個分支修改了同一個檔案的同一部分時，會發生合併衝突。

### 處理步驟

1. **查看衝突檔案**
```bash
git status
```

2. **手動編輯檔案解決衝突**

衝突標記格式：
```
<<<<<<< HEAD
你的變更
=======
對方的變更
>>>>>>> branch-name
```

3. **標記為已解決**
```bash
git add <file>
```

4. **完成合併**
```bash
git commit
```

### 衝突解決工具

```bash
git mergetool                      # 使用配置的合併工具
git checkout --ours <file>         # 使用當前分支的版本
git checkout --theirs <file>       # 使用要合併分支的版本
```

---

## 分支工作流程

### Feature Branch（功能分支）
```bash
# 1. 創建功能分支
git checkout -b feature/new-feature

# 2. 開發並測試
git add .
git commit -m "Add new feature"

# 3. 切回主分支
git checkout main

# 4. 合併功能分支
git merge feature/new-feature

# 5. 刪除功能分支
git branch -d feature/new-feature
```

### 快速切換
```bash
git switch -                       # 切回上一個分支
git stash                          # 暫存當前變更
git switch other-branch            # 切換到其他分支
git switch -                       # 切回來
git stash pop                      # 恢復暫存的變更
```

---

## 分支管理最佳實踐

### 命名規範

```bash
feature/user-authentication        # 新功能
bugfix/login-error                # Bug 修復
hotfix/security-patch             # 緊急修復
release/v1.2.0                    # 發布分支
```

### 分支策略

**Git Flow：**
- `main` - 生產環境
- `develop` - 開發環境
- `feature/*` - 功能分支（從 develop 分出）
- `release/*` - 發布分支
- `hotfix/*` - 緊急修復分支（從 main 分出）

**GitHub Flow（簡化版）：**
- `main` - 主分支（永遠可部署）
- `feature/*` - 功能分支（從 main 分出）
- 完成後通過 Pull Request 合併回 main

### 保持分支整潔

```bash
# 查看已合併的分支
git branch --merged

# 刪除已合併的本地分支
git branch -d <branch-name>

# 刪除遠端已合併的分支
git push origin --delete <branch-name>

# 清理遠端已刪除的分支引用
git fetch --prune
```

---

## 常見問題

### 誤刪分支如何恢復？

```bash
# 1. 查看 reflog 找到分支的最後 commit
git reflog

# 2. 從該 commit 重建分支
git branch <branch-name> <commit-hash>
```

### 如何查看分支間的差異？

```bash
git diff main..feature             # 查看 feature 相對於 main 的變更
git log main..feature              # 查看 feature 獨有的 commit
git log --graph --all --oneline    # 圖形化顯示所有分支
```

### 分支合併 vs. Rebase

**Merge（合併）：**
- 保留完整歷史
- 創建 merge commit
- 適合公開分支

**Rebase（變基）：**
- 線性歷史
- 不創建 merge commit
- 適合個人分支（詳見 [進階操作](advanced.md)）

---

## 相關文檔

- [基礎操作](basics.md) - Git 基本指令
- [遠端操作](remote.md) - 推送和拉取分支
- [進階操作](advanced.md) - Rebase 和 Cherry-pick
- [工作流程](workflows.md) - 完整分支工作流程
