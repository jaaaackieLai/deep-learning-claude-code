# Git 基礎操作

本文檔涵蓋 Git 的初始化、配置和基本日常操作。

## 初始化與配置

### git init
初始化一個新的 Git 倉庫。
```bash
git init                    # 在當前目錄初始化
git init <directory>        # 在指定目錄初始化
```

### git clone
複製遠端倉庫到本地。
```bash
git clone <url>                          # 複製倉庫
git clone <url> <directory>              # 複製到指定目錄
git clone -b <branch> <url>              # 複製指定分支
git clone --recursive <url>              # 克隆倉庫並包含所有子模組
```

### git config
配置 Git 設定。
```bash
# 設定使用者資訊（全域）
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# 查看配置
git config --list                        # 列出所有配置
git config user.name                     # 查看特定配置

# 其他常用配置
git config --global core.editor vim      # 設定預設編輯器
git config --global alias.st status      # 設定指令別名
git config --global pull.rebase false    # pull 時使用 merge 策略
```

---

## 基本操作

### git status
查看工作區狀態。
```bash
git status                   # 詳細狀態
git status -s               # 簡短狀態
git status -b               # 顯示分支資訊
```

### git add
將檔案加入暫存區。
```bash
git add <file>              # 加入特定檔案
git add .                   # 加入所有變更（當前目錄及子目錄）
git add -A                  # 加入所有變更（整個倉庫）
git add -u                  # 只加入已追蹤的檔案
git add -p                  # 互動式選擇要加入的變更
```

### git commit
提交變更。
```bash
git commit -m "message"           # 提交並附上訊息
git commit -am "message"          # 加入所有已追蹤檔案並提交
git commit --amend                # 修改最後一次提交
git commit --amend --no-edit      # 修改最後一次提交但不改訊息
```

**Commit 訊息最佳實踐：**
- 第一行：簡短摘要（50 字以內）
- 空一行
- 詳細說明（可選）

### git diff
查看差異。
```bash
git diff                    # 工作區 vs 暫存區
git diff --staged           # 暫存區 vs 最後一次 commit
git diff HEAD               # 工作區 vs 最後一次 commit
git diff <branch1> <branch2>  # 比較兩個分支
git diff <commit1> <commit2>  # 比較兩個 commit
```

### git rm
刪除檔案。
```bash
git rm <file>               # 刪除檔案並從 Git 移除
git rm --cached <file>      # 只從 Git 移除，保留本地檔案
git rm -r <directory>       # 遞迴刪除目錄
```

### git mv
移動或重新命名檔案。
```bash
git mv <old> <new>          # 移動/重新命名檔案
```

---

## 快速參考

### 新專案開始
```bash
git init
git add .
git commit -m "Initial commit"
```

### 日常工作流程
```bash
# 1. 檢查狀態
git status

# 2. 查看變更
git diff

# 3. 加入變更
git add <files>

# 4. 提交
git commit -m "描述變更"

# 5. 推送（如果有遠端）
git push
```

### 查看變更細節
```bash
git diff                    # 尚未暫存的變更
git diff --staged           # 已暫存的變更
git status -v               # 狀態 + 變更內容
```

---

## 相關文檔

- [分支管理](branching.md) - 分支操作
- [遠端操作](remote.md) - 與遠端倉庫互動
- [撤銷修改](undo.md) - 撤銷和恢復操作
- [工作流程](workflows.md) - 完整工作流程範例
