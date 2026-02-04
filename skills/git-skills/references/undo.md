# Git 撤銷修改

本文檔涵蓋各種撤銷和恢復操作，從簡單的檔案還原到複雜的歷史修改。

## 撤銷工作區變更

### git restore
還原檔案（Git 2.23+ 推薦使用）。
```bash
git restore <file>                 # 還原工作區的檔案
git restore .                      # 還原所有工作區變更
git restore --staged <file>        # 從暫存區移除檔案（取消 add）
git restore --source=<commit> <file>  # 從特定 commit 還原
```

### git checkout（舊方法）
```bash
git checkout -- <file>             # 還原工作區的檔案
git checkout -- .                  # 還原所有工作區變更
```

---

## 撤銷暫存區變更

### 取消 git add

```bash
# 從暫存區移除（保留工作區變更）
git restore --staged <file>        # 新方法（推薦）
git reset <file>                   # 舊方法

# 取消所有暫存
git restore --staged .
git reset
```

---

## 撤銷 Commit

### git reset
重置當前分支。

**三種模式：**

#### 1. Soft Reset（保留變更在暫存區）
```bash
git reset --soft HEAD~1            # 撤銷最後一次 commit，變更留在暫存區
```
- Commit 被撤銷
- 變更留在暫存區（git add 後的狀態）
- 工作區不變
- **用途**：修改最後一次 commit

#### 2. Mixed Reset（預設，保留變更在工作區）
```bash
git reset HEAD~1                   # 撤銷 commit 和 add
git reset --mixed HEAD~1           # 同上（明確指定）
```
- Commit 被撤銷
- 暫存區被清空
- 變更留在工作區
- **用途**：重新組織變更

#### 3. Hard Reset（完全捨棄變更）⚠️
```bash
git reset --hard HEAD~1            # 完全撤銷最後一次 commit
git reset --hard origin/<branch>   # 重置到遠端狀態
```
- Commit 被撤銷
- 暫存區被清空
- 工作區變更被丟棄
- **危險**：無法恢復工作區的變更
- **用途**：完全放棄當前變更

### 撤銷多個 Commit

```bash
git reset --soft HEAD~3            # 撤銷最近 3 個 commit
git reset <commit-hash>            # 重置到特定 commit
```

---

## git revert
創建新 commit 來撤銷變更（安全的撤銷方式）。

```bash
git revert <commit>                # 撤銷特定 commit
git revert HEAD                    # 撤銷最後一次 commit
git revert HEAD~3                  # 撤銷倒數第 4 個 commit
git revert --no-commit <commit>    # 撤銷但不自動 commit
git revert <commit1>..<commit2>    # 撤銷一系列 commit
```

**Revert vs. Reset：**

| 特性 | Reset | Revert |
|------|-------|--------|
| 修改歷史 | 是 | 否 |
| 安全性 | 危險（對已推送的 commit） | 安全 |
| 適用場景 | 本地未推送的 commit | 已推送的 commit |
| 歷史記錄 | 刪除 commit | 新增反向 commit |

**何時使用：**
- **Reset**：本地修改，未推送到遠端
- **Revert**：已推送到遠端，需要保留歷史

---

## 修改最後一次 Commit

### git commit --amend
修改最後一次 commit。

```bash
# 修改 commit 訊息
git commit --amend -m "new message"

# 加入忘記的檔案
git add forgotten-file
git commit --amend --no-edit       # 不修改訊息

# 修改訊息並加入檔案
git add forgotten-file
git commit --amend -m "updated message"
```

**注意**：
- 會改變 commit hash
- 如果已推送，需要強制推送（`--force-with-lease`）
- 不要修改已推送到共享分支的 commit

---

## 清理未追蹤檔案

### git clean
清理未追蹤的檔案和目錄。

```bash
git clean -n                       # 預覽要刪除的檔案（不實際刪除）
git clean -f                       # 刪除未追蹤的檔案
git clean -fd                      # 刪除未追蹤的檔案和目錄
git clean -fx                      # 包含 .gitignore 中的檔案
git clean -fX                      # 只刪除 .gitignore 中的檔案
```

**警告**：`git clean` 是不可逆的，刪除的檔案無法恢復！

---

## 恢復誤刪的內容

### 使用 Reflog 恢復

```bash
# 1. 查看操作歷史
git reflog

# 2. 找到要恢復的 commit hash
# 3. 恢復到該 commit
git reset --hard <commit-hash>

# 或創建新分支保留該狀態
git branch recovery-branch <commit-hash>
```

### 恢復已刪除的分支

```bash
# 1. 查看 reflog 找到分支的最後 commit
git reflog

# 2. 從該 commit 重建分支
git branch <branch-name> <commit-hash>
```

### 恢復已刪除的檔案

```bash
# 查找刪除檔案的 commit
git log --all --full-history -- path/to/file

# 從刪除前的 commit 恢復
git checkout <commit>^ -- path/to/file
```

---

## 撤銷已推送的 Commit

### 方法 1：Revert（推薦）

```bash
# 撤銷最後一次 commit
git revert HEAD
git push

# 撤銷特定 commit
git revert <commit-hash>
git push
```

**優點**：
- 保留歷史
- 安全，不影響其他協作者
- 可追蹤撤銷操作

### 方法 2：Reset + Force Push（危險）⚠️

```bash
# 重置到之前的 commit
git reset --hard HEAD~1

# 強制推送
git push --force-with-lease
```

**警告**：
- 會改變遠端歷史
- 可能導致其他人的工作遺失
- **絕不** 對 main/master 等共享分支使用
- 僅適用於個人分支或確定無人拉取的情況

---

## 撤銷場景速查

### 場景 1：修改工作區，未 add
```bash
# 撤銷特定檔案
git restore <file>

# 撤銷所有變更
git restore .
```

### 場景 2：已 add，未 commit
```bash
# 取消暫存
git restore --staged <file>

# 取消暫存 + 撤銷變更
git restore --staged <file>
git restore <file>
```

### 場景 3：已 commit，未 push
```bash
# 撤銷 commit，保留變更
git reset --soft HEAD~1

# 撤銷 commit，丟棄變更
git reset --hard HEAD~1

# 修改最後一次 commit
git commit --amend
```

### 場景 4：已 push
```bash
# 安全方法：revert
git revert HEAD
git push

# 危險方法：force push（僅個人分支）
git reset --hard HEAD~1
git push --force-with-lease
```

### 場景 5：誤刪分支或 commit
```bash
# 使用 reflog 恢復
git reflog
git branch <branch-name> <commit-hash>
```

### 場景 6：合併後想撤銷
```bash
# 如果是最後一次操作
git reset --hard ORIG_HEAD

# 或使用 reflog
git reflog
git reset --hard HEAD@{1}

# 如果已推送，使用 revert
git revert -m 1 <merge-commit-hash>
```

---

## 最佳實踐

### 撤銷前

1. **檢查狀態**
```bash
git status
git log --oneline -5
```

2. **備份（如果不確定）**
```bash
git branch backup-branch           # 創建備份分支
```

3. **確認範圍**
```bash
git diff HEAD~1                    # 查看要撤銷的變更
```

### 選擇正確的方法

- **工作區/暫存區**：`git restore`
- **本地 commit**：`git reset`
- **已推送 commit**：`git revert`
- **誤操作恢復**：`git reflog`
- **修改訊息/加檔案**：`git commit --amend`

### 避免的操作

- ❌ 對已推送的共享分支使用 `git reset --hard`
- ❌ 對 main/master 使用 `git push --force`
- ❌ 在不確定的情況下使用 `git clean -f`
- ❌ 修改已推送的 commit（除非確定無人拉取）

---

## 相關文檔

- [基礎操作](basics.md) - Git 基本指令
- [歷史查看](history.md) - 使用 reflog 和 log
- [疑難排解](troubleshooting.md) - 恢復誤操作
- [進階操作](advanced.md) - Rebase 等複雜操作
