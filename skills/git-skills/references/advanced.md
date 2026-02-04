# Git 進階操作

本文檔涵蓋進階的 Git 操作：stash、rebase、cherry-pick、tag 和 submodule。

## git stash

### 暫存工作進度

當需要切換分支但不想提交當前變更時，使用 stash 暫存。

```bash
# 基本用法
git stash                          # 暫存變更（包括暫存區和工作區）
git stash save "message"           # 暫存並加上訊息
git stash push -m "message"        # 新語法（推薦）

# 包含未追蹤的檔案
git stash -u                       # 暫存包括未追蹤檔案
git stash --include-untracked      # 同上（完整寫法）

# 包含忽略的檔案
git stash -a                       # 暫存所有檔案（包括 .gitignore）
git stash --all                    # 同上（完整寫法）
```

### 管理 Stash

```bash
# 查看 stash
git stash list                     # 列出所有 stash
git stash show                     # 顯示最新 stash 的摘要
git stash show -p                  # 顯示最新 stash 的詳細差異
git stash show stash@{0}           # 顯示特定 stash

# 套用 stash
git stash apply                    # 套用最新 stash（保留 stash）
git stash pop                      # 套用並刪除最新 stash
git stash apply stash@{2}          # 套用特定 stash

# 刪除 stash
git stash drop                     # 刪除最新 stash
git stash drop stash@{2}           # 刪除特定 stash
git stash clear                    # 清空所有 stash
```

### 進階 Stash 用法

```bash
# 暫存特定檔案
git stash push -m "message" <file>

# 互動式暫存
git stash -p                       # 選擇要暫存的變更

# 從 stash 創建分支
git stash branch <branch-name>     # 從 stash 創建新分支並套用
```

**常見場景：**
```bash
# 場景：切換分支前暫存
git stash
git switch other-branch
# 做其他工作...
git switch -
git stash pop

# 場景：暫時測試其他想法
git stash
# 嘗試不同方法...
git stash pop                      # 恢復原來的變更
```

---

## git rebase

### 變基（重新整理 commit 歷史）

Rebase 將一系列 commit 重新套用到另一個基底上，創造線性歷史。

```bash
# 基本 rebase
git rebase <branch>                # 將當前分支 rebase 到指定分支
git rebase main                    # 常見用法：更新功能分支

# 解決衝突
git rebase --continue              # 解決衝突後繼續
git rebase --skip                  # 跳過當前 commit
git rebase --abort                 # 取消 rebase

# 在特定 commit 上 rebase
git rebase <upstream> <branch>     # 將 branch rebase 到 upstream
git rebase --onto <newbase> <upstream> <branch>  # 更換基底
```

### 互動式 Rebase

整理、合併、修改 commit 歷史。

```bash
git rebase -i HEAD~3               # 互動式 rebase 最近 3 個 commit
git rebase -i <commit>             # 從某個 commit 開始 rebase
```

**互動式 rebase 命令：**
```
pick   = 保留 commit
reword = 修改 commit 訊息
edit   = 修改 commit 內容
squash = 合併到前一個 commit（保留訊息）
fixup  = 合併到前一個 commit（捨棄訊息）
drop   = 刪除 commit
```

**範例：合併多個 commit**
```bash
# 1. 啟動互動式 rebase
git rebase -i HEAD~4

# 2. 編輯器會顯示：
# pick abc1234 First commit
# pick def5678 Second commit
# pick ghi9012 Third commit
# pick jkl3456 Fourth commit

# 3. 修改為（合併後三個到第一個）：
# pick abc1234 First commit
# squash def5678 Second commit
# squash ghi9012 Third commit
# squash jkl3456 Fourth commit

# 4. 儲存並關閉，Git 會提示編輯合併後的訊息
```

### Rebase vs. Merge

| 特性 | Rebase | Merge |
|------|--------|-------|
| 歷史 | 線性 | 保留分支結構 |
| Commit 數 | 不增加 | 增加 merge commit |
| 衝突處理 | 逐個 commit | 一次解決 |
| 適用場景 | 個人分支 | 公開分支 |

**何時使用：**
- **Rebase**：個人功能分支，保持歷史整潔
- **Merge**：整合公開分支，保留完整歷史

**黃金法則**：**永不** rebase 已推送到公開分支的 commit

---

## git cherry-pick

### 挑選特定 Commit

從其他分支挑選特定 commit 套用到當前分支。

```bash
# 基本用法
git cherry-pick <commit>           # 套用特定 commit
git cherry-pick <commit1> <commit2>  # 套用多個 commit
git cherry-pick <commit1>..<commit2> # 套用範圍（不包含 commit1）
git cherry-pick <commit1>^..<commit2> # 套用範圍（包含 commit1）

# 解決衝突
git cherry-pick --continue         # 解決衝突後繼續
git cherry-pick --skip             # 跳過當前 commit
git cherry-pick --abort            # 取消 cherry-pick
git cherry-pick --quit             # 退出但保留已套用的 commit

# 進階選項
git cherry-pick -n <commit>        # 套用但不自動 commit
git cherry-pick -x <commit>        # 在訊息中記錄原 commit
git cherry-pick -e <commit>        # 套用前編輯訊息
```

**常見場景：**
```bash
# 場景 1：從 develop 挑選修復到 main
git checkout main
git cherry-pick abc1234            # 挑選修復 commit

# 場景 2：挑選多個 commit
git cherry-pick abc1234 def5678 ghi9012

# 場景 3：從另一個分支挑選功能
git checkout feature-a
git log --oneline                  # 找到要挑選的 commit
git checkout feature-b
git cherry-pick <commit-hash>
```

---

## git tag

### 標籤管理

標籤用於標記重要的提交點（如版本發布）。

### 創建標籤

```bash
# 輕量標籤（只是 commit 的引用）
git tag <tagname>                  # 在當前 commit 創建
git tag v1.0.0

# 附註標籤（包含更多資訊，推薦用於發布）
git tag -a <tagname> -m "message"  # 創建附註標籤
git tag -a v1.0.0 -m "Release version 1.0.0"

# 在特定 commit 創建標籤
git tag <tagname> <commit>
git tag v1.0.0 abc1234

# 創建帶簽名的標籤（GPG）
git tag -s <tagname> -m "message"
```

### 查看標籤

```bash
git tag                            # 列出所有標籤
git tag -l "v1.*"                  # 列出匹配的標籤
git show <tagname>                 # 顯示標籤詳情
git describe                       # 顯示最近的標籤和距離
```

### 推送標籤

```bash
# 推送特定標籤
git push origin <tagname>
git push origin v1.0.0

# 推送所有標籤
git push origin --tags

# 推送所有（包含 commit 和標籤）
git push origin --follow-tags      # 只推送附註標籤
```

### 刪除標籤

```bash
# 刪除本地標籤
git tag -d <tagname>
git tag -d v1.0.0

# 刪除遠端標籤
git push origin --delete <tagname>
git push origin :refs/tags/<tagname>  # 舊語法
```

### 檢出標籤

```bash
# 查看標籤對應的代碼（detached HEAD）
git checkout <tagname>
git checkout v1.0.0

# 從標籤創建分支
git checkout -b <branch> <tagname>
git checkout -b hotfix-1.0.1 v1.0.0
```

**標籤命名規範（語義化版本）：**
```
v1.0.0         # 主版本.次版本.修訂號
v1.0.0-alpha   # 預發布版本
v1.0.0-beta.1  # Beta 測試版本
v1.0.0-rc.1    # Release Candidate
```

---

## git submodule

### 子模組管理

將其他 Git 倉庫作為子目錄嵌入到當前倉庫。

### 添加子模組

```bash
git submodule add <url> <path>              # 添加子模組到指定路徑
git submodule add https://github.com/user/repo.git libs/repo

git submodule add -b <branch> <url> <path>  # 追蹤特定分支
```

### 初始化和更新

```bash
# 克隆包含子模組的倉庫
git clone --recursive <url>                 # 自動初始化子模組
# 或
git clone <url>
git submodule init
git submodule update

# 簡化寫法
git submodule update --init                 # 初始化並更新
git submodule update --init --recursive     # 包含嵌套子模組

# 更新子模組到遠端最新版本
git submodule update --remote               # 更新所有子模組
git submodule update --remote <path>        # 更新特定子模組
```

### 查看和操作子模組

```bash
# 查看狀態
git submodule status                        # 查看所有子模組狀態
git submodule status --recursive            # 包含嵌套子模組

# 對所有子模組執行指令
git submodule foreach <command>             # 對每個子模組執行指令
git submodule foreach git pull origin main  # 更新所有子模組
git submodule foreach --recursive <command> # 包含嵌套子模組
```

### 更新子模組

```bash
# 方法 1：進入子模組目錄
cd libs/repo
git pull origin main
cd ../..
git add libs/repo
git commit -m "Update submodule"

# 方法 2：使用 update --remote
git submodule update --remote libs/repo
git commit -am "Update submodule to remote latest"
```

### 刪除子模組

```bash
# 1. 取消註冊子模組
git submodule deinit <path>

# 2. 刪除子模組目錄
git rm <path>

# 3. 刪除 Git 模組目錄
rm -rf .git/modules/<path>

# 4. 提交變更
git commit -m "Remove submodule"
```

### 子模組同步

```bash
# 當 .gitmodules 的 URL 更新後
git submodule sync                          # 同步 URL 到 .git/config
git submodule sync --recursive              # 包含嵌套子模組
git submodule update --init --recursive     # 更新子模組
```

**重要提醒：**
- 子模組預設處於 detached HEAD 狀態
- 修改前需先 `git checkout <branch>`
- 更新子模組後要在主倉庫 commit 新的指標
- 使用 `.gitmodules` 檔案追蹤子模組配置

---

## 相關文檔

- [撤銷修改](undo.md) - Reset 和 Revert
- [分支管理](branching.md) - 分支操作
- [歷史查看](history.md) - Reflog 使用
- [遠端操作](remote.md) - 推送標籤和分支
