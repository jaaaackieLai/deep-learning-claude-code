# Git 遠端操作

本文檔涵蓋與遠端倉庫的互動：管理遠端、推送、拉取和同步。

## 遠端倉庫管理

### git remote
管理遠端倉庫。
```bash
git remote                         # 列出遠端倉庫
git remote -v                      # 顯示詳細資訊（含 URL）
git remote add <name> <url>        # 新增遠端倉庫
git remote remove <name>           # 移除遠端倉庫
git remote rename <old> <new>      # 重新命名遠端倉庫
git remote show <name>             # 顯示遠端倉庫詳情
git remote set-url <name> <url>    # 更改遠端倉庫 URL
```

**常用遠端名稱：**
- `origin` - 預設的主要遠端（克隆時自動建立）
- `upstream` - 上游倉庫（fork 專案時常用）

---

## 下載更新

### git fetch
下載遠端變更但不合併。
```bash
git fetch                          # 下載所有遠端分支
git fetch <remote>                 # 下載特定遠端倉庫
git fetch <remote> <branch>        # 下載特定分支
git fetch --all                    # 下載所有遠端倉庫
git fetch --prune                  # 清理已刪除的遠端分支
```

**Fetch 後的操作：**
```bash
git fetch origin
git log origin/main                # 查看遠端變更
git diff main origin/main          # 比較本地和遠端差異
git merge origin/main              # 手動合併遠端變更
```

### git pull
下載並合併遠端變更。
```bash
git pull                           # pull 當前分支
git pull <remote> <branch>         # pull 特定分支
git pull --rebase                  # 使用 rebase 而非 merge
git pull --no-rebase               # 強制使用 merge
```

**Pull = Fetch + Merge：**
```bash
# 以下兩組指令等效
git pull

git fetch
git merge origin/main
```

---

## 推送更新

### git push
推送變更到遠端。
```bash
git push                           # 推送當前分支
git push <remote> <branch>         # 推送到特定分支
git push -u origin <branch>        # 推送並設定上游分支（首次推送）
git push --all                     # 推送所有分支
git push --tags                    # 推送所有標籤
git push origin --delete <branch>  # 刪除遠端分支
git push --force                   # 強制推送（危險！）
git push --force-with-lease        # 較安全的強制推送
```

### 首次推送分支

```bash
# 創建本地分支
git checkout -b feature/new-feature

# 進行變更並提交
git add .
git commit -m "Add feature"

# 推送並設定上游
git push -u origin feature/new-feature

# 之後只需
git push
```

### 強制推送注意事項

**危險操作 `--force`：**
- 覆蓋遠端歷史
- 可能導致其他人的工作遺失
- **絕不** 對共享分支使用（如 main/master）

**較安全的 `--force-with-lease`：**
- 檢查遠端是否有新的提交
- 如果有其他人推送了，會拒絕
- 適合個人分支的強制推送

```bash
# 壞習慣
git push --force

# 好習慣
git push --force-with-lease

# 更好的習慣：先確認
git fetch
git log origin/main..main          # 確認要推送的內容
git push --force-with-lease
```

---

## 同步與追蹤

### 設定上游分支

```bash
# 方法 1：推送時設定
git push -u origin <branch>

# 方法 2：手動設定
git branch --set-upstream-to=origin/<branch>

# 方法 3：簡寫
git branch -u origin/<branch>
```

### 查看追蹤關係

```bash
git branch -vv                     # 查看所有分支的追蹤情況
```

---

## 同步 Fork 的專案

當你 fork 了別人的專案，需要定期同步上游更新。

### 設定上游倉庫

```bash
# 1. 添加上游倉庫
git remote add upstream <original-repo-url>

# 2. 驗證
git remote -v
# 應該看到：
# origin    <your-fork-url> (fetch)
# origin    <your-fork-url> (push)
# upstream  <original-repo-url> (fetch)
# upstream  <original-repo-url> (push)
```

### 同步上游變更

```bash
# 1. 獲取上游變更
git fetch upstream

# 2. 切換到主分支
git checkout main

# 3. 合併上游變更
git merge upstream/main

# 4. 推送到你的 fork
git push origin main
```

### 同步後更新功能分支

```bash
# 在功能分支上
git checkout feature/my-feature

# 合併最新的 main
git merge main

# 或者使用 rebase（保持線性歷史）
git rebase main
```

---

## 常見工作流程

### 協作開發流程

```bash
# 1. 開始工作前先拉取最新變更
git pull

# 2. 創建功能分支
git checkout -b feature/new-feature

# 3. 開發並提交
git add .
git commit -m "Add new feature"

# 4. 推送功能分支
git push -u origin feature/new-feature

# 5. 在 GitHub/GitLab 上創建 Pull Request

# 6. 合併後更新本地 main
git checkout main
git pull
git branch -d feature/new-feature
```

### 處理遠端衝突

```bash
# 推送時發生衝突
git push
# ! [rejected] main -> main (fetch first)

# 1. 先拉取遠端變更
git pull

# 2. 解決衝突（如果有）
# 編輯衝突檔案
git add <resolved-files>
git commit

# 3. 再次推送
git push
```

---

## 常見問題

### 遠端分支已刪除，如何清理本地引用？

```bash
git fetch --prune                  # 清理遠端已刪除的分支引用
git remote prune origin            # 同上
```

### 如何查看遠端分支？

```bash
git branch -r                      # 列出遠端分支
git branch -a                      # 列出所有分支（本地+遠端）
git ls-remote --heads origin       # 查看遠端所有分支
```

### 誤推送後如何撤銷？

```bash
# 如果還沒有人拉取
git push --force-with-lease origin <branch>

# 如果已有人拉取，使用 revert
git revert <commit>
git push
```

### 如何更改遠端 URL？

```bash
# 查看當前 URL
git remote -v

# 更改 URL
git remote set-url origin <new-url>

# 驗證
git remote -v
```

---

## 最佳實踐

### 推送前

- ✅ 先拉取最新變更（`git pull`）
- ✅ 確保測試通過
- ✅ 檢查要推送的內容（`git log origin/main..main`）
- ✅ 避免推送大型二進制檔案

### 拉取時

- ✅ 定期拉取避免大量衝突
- ✅ 在推送前先拉取
- ✅ 使用 `git fetch` 先查看變更再決定如何合併

### 遠端分支管理

- ✅ 已合併的功能分支及時刪除
- ✅ 定期清理（`git fetch --prune`）
- ✅ 避免對主分支強制推送
- ✅ 使用 Pull Request 進行代碼審查

---

## 相關文檔

- [基礎操作](basics.md) - Git 基本指令
- [分支管理](branching.md) - 分支操作
- [工作流程](workflows.md) - 完整協作流程
- [疑難排解](troubleshooting.md) - 常見遠端問題解決
