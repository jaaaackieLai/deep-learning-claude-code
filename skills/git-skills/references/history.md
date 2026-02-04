# Git 歷史查看

本文檔涵蓋查看提交歷史、檔案變更和追蹤修改的指令。

## 查看提交歷史

### git log
查看提交歷史。
```bash
# 基本用法
git log                            # 顯示完整歷史
git log -n <number>                # 限制顯示數量
git log -5                         # 顯示最近 5 個 commit

# 格式化輸出
git log --oneline                  # 每個 commit 一行
git log --graph                    # 圖形化顯示
git log --all                      # 顯示所有分支
git log --decorate                 # 顯示分支和標籤名稱

# 常用組合
git log --oneline --graph --all --decorate
git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'
```

### 按條件篩選

```bash
# 按時間
git log --since="2 weeks ago"      # 最近兩週
git log --until="2023-12-31"       # 某日期之前
git log --since="2023-01-01" --until="2023-12-31"  # 時間範圍

# 按作者
git log --author="name"            # 特定作者的 commit
git log --author="name" --oneline  # 簡潔顯示

# 按訊息內容
git log --grep="keyword"           # 搜尋 commit 訊息
git log --grep="fix" -i            # 不區分大小寫

# 按檔案
git log <file>                     # 特定檔案的歷史
git log --follow <file>            # 追蹤檔案重新命名

# 按分支
git log main..feature              # feature 有但 main 沒有的 commit
git log feature..main              # main 有但 feature 沒有的 commit
git log main...feature             # 兩個分支的差集
```

### 顯示變更內容

```bash
git log -p                         # 顯示每個 commit 的差異
git log -p <file>                  # 顯示特定檔案的差異
git log --stat                     # 顯示統計資訊（檔案和行數）
git log --shortstat                # 簡短統計
git log --name-only                # 只顯示變更的檔案名
git log --name-status              # 顯示檔案名和變更類型（A/M/D）
```

---

## 查看特定 Commit

### git show
顯示 commit 詳情。
```bash
git show                           # 顯示最後一次 commit
git show <commit>                  # 顯示特定 commit
git show <commit>:<file>           # 顯示特定 commit 中檔案的內容
git show --stat                    # 顯示統計資訊
git show HEAD                      # 顯示當前 HEAD
git show HEAD~3                    # 顯示往前數第 3 個 commit
```

**Commit 引用方式：**
```bash
HEAD                               # 當前 commit
HEAD~1 或 HEAD^                    # 上一個 commit
HEAD~2 或 HEAD^^                   # 上兩個 commit
HEAD~n                             # 往前數第 n 個 commit
<commit-hash>                      # 使用 hash（可簡寫，如前 7 位）
<branch-name>                      # 分支的最新 commit
<tag-name>                         # 標籤指向的 commit
```

---

## 追蹤檔案變更

### git blame
查看每一行的最後修改者。
```bash
git blame <file>                   # 顯示檔案的修改歷史
git blame -L 10,20 <file>          # 只顯示第 10-20 行
git blame -L 10,+5 <file>          # 從第 10 行開始，顯示 5 行
git blame -e <file>                # 顯示 email 而非名稱
git blame -w <file>                # 忽略空白字元變更
```

**輸出格式：**
```
<commit-hash> (<author> <date> <line-number>) <content>
```

### git log 查看檔案歷史

```bash
# 查看檔案的完整歷史
git log --follow <file>

# 查看檔案的變更內容
git log -p <file>

# 查看誰修改了檔案的特定部分
git log -L 10,20:<file>            # 追蹤第 10-20 行的變更歷史
```

---

## 搜尋代碼

### git grep
在倉庫中搜尋文字。
```bash
git grep "pattern"                 # 在工作區搜尋
git grep "pattern" <commit>        # 在特定 commit 搜尋
git grep -n "pattern"              # 顯示行號
git grep -c "pattern"              # 顯示每個檔案的匹配數
git grep -i "pattern"              # 不區分大小寫
git grep --and "pattern1" "pattern2"  # 同時包含兩個模式
```

**搜尋特定類型檔案：**
```bash
git grep "pattern" -- "*.js"       # 只搜尋 .js 檔案
git grep "pattern" -- "*.py"       # 只搜尋 .py 檔案
```

---

## 比較差異

### 比較 Commits

```bash
# 比較兩個 commit
git diff <commit1> <commit2>

# 比較分支
git diff main feature              # main 和 feature 的差異
git diff main...feature            # feature 相對於共同祖先的變更

# 比較特定檔案
git diff <commit1> <commit2> -- <file>
```

### 比較統計

```bash
git diff --stat main feature       # 顯示統計資訊
git diff --numstat main feature    # 數字統計（+行數 -行數）
git diff --shortstat main feature  # 簡短統計
```

---

## 查看引用歷史

### git reflog
查看所有操作歷史（包括已刪除的 commit）。
```bash
git reflog                         # 顯示操作歷史
git reflog show <branch>           # 顯示特定分支的歷史
git reflog show --all              # 顯示所有引用的歷史

# 用於救回誤刪的 commit
git reflog                         # 找到要恢復的 commit hash
git reset --hard <commit-hash>     # 恢復到該 commit
```

**Reflog 保留期限：**
- 預設保留 90 天
- 可用於恢復誤操作

---

## 實用查詢範例

### 查看最近的變更

```bash
# 最近 5 個 commit
git log -5 --oneline

# 昨天的 commit
git log --since="yesterday"

# 本週的 commit
git log --since="1 week ago" --oneline

# 特定時間範圍
git log --since="2023-01-01" --until="2023-01-31"
```

### 查看特定作者的貢獻

```bash
# 作者的所有 commit
git log --author="Alice" --oneline

# 作者的統計資訊
git log --author="Alice" --shortstat

# 作者修改的檔案
git log --author="Alice" --name-only --pretty=format:
```

### 查看未合併的變更

```bash
# feature 分支有但 main 沒有的 commit
git log main..feature --oneline

# 兩個分支的差異摘要
git log --left-right --oneline main...feature
# < 表示左邊（main）
# > 表示右邊（feature）
```

### 查找引入 Bug 的 Commit

```bash
# 查看某行的變更歷史
git log -L 42,42:path/to/file      # 追蹤第 42 行

# 查看特定函數的歷史（適用於 C、Python 等）
git log -L :function_name:path/to/file

# 使用 bisect 二分搜尋（見疑難排解文檔）
git bisect start
git bisect bad                     # 當前版本有問題
git bisect good <commit>           # 某個舊版本沒問題
# Git 會自動二分搜尋
```

---

## 格式化輸出

### 自訂 Log 格式

```bash
# 使用 pretty format
git log --pretty=format:"%h - %an, %ar : %s"
# %h  = 簡短 hash
# %an = 作者名稱
# %ar = 相對時間
# %s  = 提交訊息

# 完整的格式化選項
git log --pretty=format:"%C(yellow)%h%C(reset) %C(blue)%ad%C(reset) %C(green)%an%C(reset) %s" --date=short

# 設定別名
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
# 使用：git lg
```

### 常用格式化選項

| 選項 | 說明 |
|------|------|
| %H | commit hash（完整） |
| %h | commit hash（簡短） |
| %an | 作者名稱 |
| %ae | 作者 email |
| %ad | 作者日期 |
| %ar | 作者相對時間 |
| %s | 提交訊息標題 |
| %b | 提交訊息內容 |
| %d | ref 名稱 |

---

## 相關文檔

- [基礎操作](basics.md) - Git 基本指令
- [分支管理](branching.md) - 分支歷史
- [疑難排解](troubleshooting.md) - 使用 reflog 恢復
