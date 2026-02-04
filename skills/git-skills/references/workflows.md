# Git 工作流程

本文檔提供常見的 Git 工作流程和最佳實踐。

## Feature Branch Workflow（功能分支流程）

### 概述

最簡單和最常用的工作流程，適合小型團隊和專案。

**核心概念：**
- `main` - 主分支（穩定、可部署）
- `feature/*` - 功能分支（從 main 分出，完成後合併回 main）

### 完整流程

```bash
# 1. 確保 main 是最新的
git checkout main
git pull origin main

# 2. 創建功能分支
git checkout -b feature/user-authentication

# 3. 開發功能
# 編輯檔案...
git add .
git commit -m "Add user login form"

# 繼續開發...
git add .
git commit -m "Add password validation"

# 4. 定期同步 main 的更新
git checkout main
git pull origin main
git checkout feature/user-authentication
git merge main
# 或使用 rebase：git rebase main

# 5. 推送功能分支
git push -u origin feature/user-authentication

# 6. 創建 Pull Request（在 GitHub/GitLab）

# 7. Code Review 通過後合併
# （通常在 GitHub/GitLab 上操作）

# 8. 更新本地 main 並刪除功能分支
git checkout main
git pull origin main
git branch -d feature/user-authentication
git push origin --delete feature/user-authentication
```

### 分支命名規範

```
feature/user-authentication     # 新功能
bugfix/login-error             # Bug 修復
hotfix/security-patch          # 緊急修復
refactor/database-layer        # 重構
docs/api-documentation         # 文檔
test/unit-tests                # 測試
```

---

## Git Flow

### 概述

更嚴格的分支模型，適合有明確發布週期的專案。

**分支類型：**
- `main` - 生產環境（正式發布）
- `develop` - 開發環境（整合分支）
- `feature/*` - 功能分支（從 develop 分出）
- `release/*` - 發布分支（準備發布）
- `hotfix/*` - 緊急修復（從 main 分出）

### 功能開發流程

```bash
# 1. 從 develop 創建功能分支
git checkout develop
git pull origin develop
git checkout -b feature/new-feature

# 2. 開發功能
git add .
git commit -m "Implement new feature"

# 3. 完成後合併回 develop
git checkout develop
git merge --no-ff feature/new-feature
git push origin develop
git branch -d feature/new-feature
```

### 發布流程

```bash
# 1. 從 develop 創建發布分支
git checkout develop
git checkout -b release/v1.2.0

# 2. 準備發布（修復小 bug、更新版本號）
git commit -am "Bump version to 1.2.0"

# 3. 合併到 main 並標記
git checkout main
git merge --no-ff release/v1.2.0
git tag -a v1.2.0 -m "Release version 1.2.0"
git push origin main --tags

# 4. 合併回 develop
git checkout develop
git merge --no-ff release/v1.2.0
git push origin develop

# 5. 刪除發布分支
git branch -d release/v1.2.0
```

### 緊急修復流程

```bash
# 1. 從 main 創建 hotfix 分支
git checkout main
git checkout -b hotfix/v1.2.1

# 2. 修復問題
git commit -am "Fix critical security bug"

# 3. 合併到 main 並標記
git checkout main
git merge --no-ff hotfix/v1.2.1
git tag -a v1.2.1 -m "Hotfix version 1.2.1"
git push origin main --tags

# 4. 合併回 develop
git checkout develop
git merge --no-ff hotfix/v1.2.1
git push origin develop

# 5. 刪除 hotfix 分支
git branch -d hotfix/v1.2.1
```

---

## GitHub Flow

### 概述

簡化的流程，適合持續部署的專案。

**核心概念：**
- `main` - 主分支（永遠可部署）
- 功能分支 - 短期分支，頻繁合併

### 流程

```bash
# 1. 創建分支
git checkout -b feature-name

# 2. 提交變更
git add .
git commit -m "Add feature"

# 3. 推送並創建 Pull Request
git push -u origin feature-name
# 在 GitHub 上創建 PR

# 4. 討論和代碼審查

# 5. 部署測試（從分支部署到測試環境）

# 6. 合併到 main
# 在 GitHub 上合併 PR

# 7. 從 main 部署到生產環境
```

**特點：**
- 分支生命週期短
- 頻繁整合到 main
- main 永遠可部署
- 透過 PR 進行代碼審查

---

## Fork Workflow（開源專案）

### 概述

適合開源專案和外部貢獻者。

### 貢獻流程

```bash
# 1. Fork 專案到你的帳號（在 GitHub 上操作）

# 2. 克隆你的 fork
git clone https://github.com/YOUR-USERNAME/project.git
cd project

# 3. 添加上游倉庫
git remote add upstream https://github.com/ORIGINAL-OWNER/project.git

# 4. 創建功能分支
git checkout -b feature/new-feature

# 5. 開發功能
git add .
git commit -m "Add new feature"

# 6. 同步上游更新
git fetch upstream
git checkout main
git merge upstream/main
git push origin main

# 7. Rebase 功能分支（可選）
git checkout feature/new-feature
git rebase main

# 8. 推送到你的 fork
git push origin feature/new-feature

# 9. 創建 Pull Request
# 在 GitHub 上從你的 fork 向原專案提交 PR

# 10. 回應代碼審查意見
git add .
git commit -m "Address review comments"
git push origin feature/new-feature

# 11. PR 合併後更新本地
git checkout main
git pull upstream main
git push origin main
git branch -d feature/new-feature
```

---

## 日常協作流程

### 開始一天的工作

```bash
# 1. 拉取最新變更
git checkout main
git pull origin main

# 2. 創建或切換到功能分支
git checkout -b feature/today-task
# 或
git checkout feature/existing-task
git merge main  # 同步 main 的更新
```

### 提交變更

```bash
# 1. 查看變更
git status
git diff

# 2. 暫存變更
git add <files>
# 或全部
git add .

# 3. 提交
git commit -m "Clear and descriptive message"

# 4. 推送
git push
# 或首次推送
git push -u origin feature/task-name
```

### 結束一天的工作

```bash
# 1. 確保所有變更已提交
git status

# 2. 推送到遠端
git push

# 或者暫存未完成的工作
git stash save "WIP: work in progress"
```

---

## Commit 訊息最佳實踐

### 格式

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type

- `feat`: 新功能
- `fix`: Bug 修復
- `docs`: 文檔更新
- `style`: 格式化（不影響代碼邏輯）
- `refactor`: 重構
- `test`: 測試相關
- `chore`: 維護任務

### 範例

```
feat(auth): add password reset functionality

Implement password reset via email with:
- Email sending service
- Secure token generation
- 24-hour token expiration

Closes #123
```

```
fix(api): resolve race condition in user creation

Handle concurrent user registration by:
- Adding database constraint
- Implementing optimistic locking

Fixes #456
```

---

## 代碼審查流程

### 提交 PR 前

```bash
# 1. 確保通過測試
npm test
# 或
pytest

# 2. 確保代碼格式正確
npm run lint
# 或
black .

# 3. Rebase 到最新的 main（可選）
git fetch origin main
git rebase origin/main

# 4. 推送
git push -f origin feature-branch  # 如果 rebased
```

### 回應審查意見

```bash
# 1. 修改代碼
# 編輯檔案...

# 2. 提交修改
git add .
git commit -m "Address review comments: improve error handling"

# 3. 推送
git push origin feature-branch

# PR 會自動更新
```

---

## 發布版本流程

### 語義化版本（Semantic Versioning）

格式：`MAJOR.MINOR.PATCH`（例如：`1.2.3`）

- **MAJOR**: 不相容的 API 變更
- **MINOR**: 向後相容的新功能
- **PATCH**: 向後相容的 Bug 修復

### 發布步驟

```bash
# 1. 確保在正確的分支
git checkout main
git pull origin main

# 2. 更新版本號
# 編輯 package.json / setup.py / Cargo.toml 等
vim package.json

# 3. 更新 CHANGELOG
vim CHANGELOG.md

# 4. 提交版本更新
git add .
git commit -m "chore: bump version to 1.2.0"

# 5. 創建標籤
git tag -a v1.2.0 -m "Release version 1.2.0"

# 6. 推送
git push origin main
git push origin v1.2.0

# 7. 創建 GitHub Release（在 GitHub 上操作）
```

---

## 最佳實踐總結

### Commit

- ✅ 頻繁提交，每個 commit 代表一個邏輯單元
- ✅ 寫清晰的 commit 訊息
- ✅ 提交前運行測試
- ❌ 不要提交未完成的功能
- ❌ 不要提交敏感資料

### 分支

- ✅ 使用描述性的分支名稱
- ✅ 保持分支生命週期短
- ✅ 定期同步主分支
- ✅ 完成後刪除分支
- ❌ 不要在 main 上直接開發

### 協作

- ✅ 在推送前先拉取
- ✅ 使用 Pull Request 進行代碼審查
- ✅ 回應審查意見
- ✅ 保持溝通
- ❌ 不要強制推送到共享分支

### 整合

- ✅ 使用 CI/CD 自動化測試
- ✅ 合併前確保測試通過
- ✅ 使用 pre-commit hooks
- ✅ 定期整合
- ❌ 不要長時間不整合

---

## 相關文檔

- [分支管理](branching.md) - 分支操作詳解
- [遠端操作](remote.md) - 推送和拉取
- [進階操作](advanced.md) - Rebase 和 Tag
- [疑難排解](troubleshooting.md) - 解決常見問題
