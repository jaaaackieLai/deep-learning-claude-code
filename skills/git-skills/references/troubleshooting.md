# Git 疑難排解

本文檔提供常見 Git 問題的解決方案。

## 撤銷與恢復

### 撤銷已推送的 Commit

**場景**：誤推送了錯誤的 commit。

**方法 1：Revert（推薦，安全）**
```bash
git revert <commit>
git push
```

**方法 2：Reset + Force Push（危險）**
```bash
git reset --hard HEAD~1
git push --force-with-lease

# 警告：只用於個人分支或確定無人拉取的情況
```

### 找回已刪除的 Commit

**場景**：誤用 `git reset --hard` 刪除了 commit。

```bash
# 1. 查看 reflog 找到 commit
git reflog

# 2. 恢復到該 commit
git reset --hard <commit-hash>

# 或創建分支保留該狀態
git branch recovery-branch <commit-hash>
```

### 找回已刪除的檔案

**場景**：誤刪除了檔案並已提交。

```bash
# 1. 查找刪除檔案的 commit
git log --all --full-history -- path/to/file

# 2. 從刪除前的 commit 恢復
git checkout <commit>^ -- path/to/file
```

### 恢復已刪除的分支

**場景**：誤刪除了分支。

```bash
# 1. 查看 reflog 找到分支的最後 commit
git reflog

# 2. 從該 commit 重建分支
git branch <branch-name> <commit-hash>
```

---

## 合併衝突

### 解決合併衝突

**場景**：`git merge` 或 `git pull` 時發生衝突。

```bash
# 1. 查看衝突檔案
git status

# 2. 編輯衝突檔案
# 尋找並解決衝突標記：
# <<<<<<< HEAD
# 你的變更
# =======
# 對方的變更
# >>>>>>> branch-name

# 3. 標記為已解決
git add <resolved-files>

# 4. 完成合併
git commit

# 或取消合併
git merge --abort
```

### 選擇一方的版本

```bash
# 使用當前分支的版本（ours）
git checkout --ours <file>

# 使用要合併分支的版本（theirs）
git checkout --theirs <file>

# 標記為已解決
git add <file>
```

### Rebase 衝突

```bash
# 解決衝突後
git add <resolved-files>
git rebase --continue

# 或取消 rebase
git rebase --abort

# 或跳過當前 commit
git rebase --skip
```

---

## 遠端問題

### 推送被拒絕

**場景**：`git push` 時顯示 `[rejected]`。

**原因**：遠端有新的 commit。

```bash
# 1. 先拉取遠端變更
git pull

# 2. 解決衝突（如果有）

# 3. 再次推送
git push
```

### 遠端 URL 錯誤

**場景**：clone 或 push 時 URL 不正確。

```bash
# 查看當前 URL
git remote -v

# 更改 URL
git remote set-url origin <new-url>

# 驗證
git remote -v
```

### 清理已刪除的遠端分支

**場景**：遠端分支已刪除，但本地仍顯示。

```bash
git fetch --prune                  # 清理遠端已刪除的分支引用
git remote prune origin            # 同上
```

### 推送新分支

**場景**：首次推送本地分支到遠端。

```bash
# 推送並設定上游
git push -u origin <branch-name>

# 之後只需
git push
```

---

## 分支問題

### 切換分支時有未提交的變更

**場景**：切換分支時 Git 提示有未提交的變更。

**方法 1：暫存變更**
```bash
git stash
git switch <branch>
# 做其他工作...
git switch -
git stash pop
```

**方法 2：提交變更**
```bash
git add .
git commit -m "WIP: temporary commit"
git switch <branch>
```

**方法 3：攜帶變更切換**
```bash
# 如果沒有衝突，Git 會自動攜帶變更
git switch <branch>
```

### 誤刪分支

見上方「恢復已刪除的分支」。

### 分支追蹤錯誤

**場景**：分支沒有追蹤遠端分支。

```bash
# 設定上游分支
git branch --set-upstream-to=origin/<branch>

# 或使用簡寫
git branch -u origin/<branch>
```

---

## Commit 問題

### 修改最後一次 Commit

**場景**：最後一次 commit 有錯誤（訊息或內容）。

```bash
# 修改訊息
git commit --amend -m "new message"

# 加入忘記的檔案
git add forgotten-file
git commit --amend --no-edit
```

**注意**：如果已推送，需要強制推送（`--force-with-lease`）。

### Commit 到錯誤的分支

**場景**：在 main 上做了應該在功能分支的 commit。

```bash
# 1. 創建新分支（包含當前 commit）
git branch feature-branch

# 2. 重置 main 到之前的狀態
git reset --hard HEAD~1

# 3. 切換到功能分支
git switch feature-branch
```

### 合併多個 Commit

**場景**：想要合併多個小 commit。

```bash
# 使用互動式 rebase
git rebase -i HEAD~3

# 在編輯器中，將 pick 改為 squash（或 s）
# pick abc1234 First commit
# squash def5678 Second commit
# squash ghi9012 Third commit
```

---

## 子模組問題

### 子模組未初始化

**場景**：克隆專案後子模組目錄是空的。

```bash
git submodule init
git submodule update

# 或一次完成
git submodule update --init --recursive
```

### 子模組 Detached HEAD

**場景**：子模組處於 detached HEAD 狀態。

```bash
cd submodule-path
git checkout main              # 切換到分支

# 如果需要修改
git checkout -b feature-branch
```

### 子模組 URL 變更

**場景**：子模組的遠端 URL 改變了。

```bash
# 1. 編輯 .gitmodules 檔案更新 URL

# 2. 同步配置
git submodule sync

# 3. 更新子模組
git submodule update --init
```

---

## 效能問題

### 倉庫過大

**問題**：倉庫體積過大，克隆和操作緩慢。

**診斷**：
```bash
# 查看倉庫大小
du -sh .git

# 找出大檔案
git rev-list --objects --all | \
  git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | \
  sed -n 's/^blob //p' | \
  sort --numeric-sort --key=2 | \
  tail -n 10
```

**解決方案**：

1. **使用 shallow clone**：
```bash
git clone --depth 1 <url>         # 只克隆最近的歷史
```

2. **使用 BFG Repo-Cleaner** 移除大檔案：
```bash
# 安裝 BFG
brew install bfg   # macOS

# 移除大於 100M 的檔案
bfg --strip-blobs-bigger-than 100M repo.git

# 清理
cd repo.git
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

3. **使用 Git LFS** 處理大檔案：
```bash
# 安裝 Git LFS
git lfs install

# 追蹤大檔案類型
git lfs track "*.psd"
git lfs track "*.mp4"

# 提交 .gitattributes
git add .gitattributes
git commit -m "Add Git LFS tracking"
```

### 操作緩慢

```bash
# 優化本地倉庫
git gc                             # 垃圾回收
git gc --aggressive                # 更徹底的優化

# 檢查倉庫完整性
git fsck
```

---

## .gitignore 問題

### 已追蹤的檔案未被忽略

**場景**：添加 `.gitignore` 規則後檔案仍被追蹤。

```bash
# 從 Git 移除但保留本地檔案
git rm --cached <file>
git rm --cached -r <directory>

# 提交變更
git commit -m "Stop tracking ignored files"
```

### 檢查為何檔案被忽略

```bash
git check-ignore -v <file>         # 顯示匹配的規則
```

### 強制添加被忽略的檔案

```bash
git add -f <file>                  # 強制添加
```

---

## 憑證與認證問題

### HTTPS 認證失敗

**場景**：推送時要求輸入帳號密碼，但失敗。

**解決方案**：使用 Personal Access Token（PAT）

```bash
# GitHub/GitLab 已不支援密碼認證
# 需要創建 Personal Access Token

# 1. 在 GitHub/GitLab 創建 PAT
# 2. 使用 PAT 代替密碼

# 儲存憑證（避免重複輸入）
git config --global credential.helper store
git push   # 輸入一次 PAT 後會被儲存
```

### SSH 連接問題

```bash
# 測試 SSH 連接
ssh -T git@github.com

# 如果失敗，檢查 SSH key
ls -la ~/.ssh

# 生成新的 SSH key
ssh-keygen -t ed25519 -C "your.email@example.com"

# 將公鑰添加到 GitHub/GitLab
cat ~/.ssh/id_ed25519.pub
```

---

## 使用 Git Bisect 查找 Bug

**場景**：知道某個 bug 存在，但不知道是哪個 commit 引入的。

```bash
# 1. 開始 bisect
git bisect start

# 2. 標記當前版本有問題
git bisect bad

# 3. 標記已知沒問題的版本
git bisect good <commit>

# 4. Git 會自動切換到中間的 commit
# 測試這個版本是否有 bug

# 5. 標記結果
git bisect good   # 這個版本沒問題
# 或
git bisect bad    # 這個版本有問題

# 6. 重複步驟 4-5 直到找到引入 bug 的 commit

# 7. 結束 bisect
git bisect reset
```

---

## 行尾符號問題

**場景**：Windows 和 Unix 系統間的行尾符號不一致。

```bash
# 配置 Git 自動轉換
# Windows
git config --global core.autocrlf true

# macOS/Linux
git config --global core.autocrlf input

# 查看當前設定
git config core.autocrlf
```

---

## 緊急求助

### 完全不知道怎麼辦

1. **不要 panic**，Git 很難真正刪除資料
2. **不要執行破壞性指令**（`--hard`, `--force`, `clean -f`）
3. **使用 reflog**：`git reflog` 是你的時光機
4. **創建備份分支**：`git branch backup-$(date +%Y%m%d)`
5. **尋求幫助**，但先用 `git status` 和 `git log` 了解狀態

### 真的搞砸了

```bash
# 創建完整備份
cp -r .git .git.backup

# 查看 reflog 找回最近的好狀態
git reflog

# 恢復到安全的點
git reset --hard <safe-commit>
```

---

## 相關文檔

- [撤銷修改](undo.md) - 詳細的撤銷操作
- [歷史查看](history.md) - 使用 reflog 和 log
- [遠端操作](remote.md) - 遠端倉庫問題
- [進階操作](advanced.md) - Rebase 和 submodule
