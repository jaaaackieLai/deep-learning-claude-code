# .gitignore 檔案

本文檔說明如何使用 `.gitignore` 來忽略不需要版本控制的檔案。

## 什麼是 .gitignore

`.gitignore` 用於指定 Git 應該忽略的檔案和目錄。這些檔案不會被追蹤、暫存或提交。

**常見用途：**
- 建置產物（編譯檔案、打包檔案）
- 依賴套件（node_modules、venv）
- 臨時檔案（日誌、快取）
- 系統檔案（.DS_Store、Thumbs.db）
- 敏感資料（.env、密鑰檔案）
- IDE 配置（.vscode、.idea）

---

## 基本語法

### 模式規則

```gitignore
# 註解
*.log                  # 忽略所有 .log 檔案
!important.log         # 但不忽略 important.log（例外）

# 目錄相關
/temp                  # 只忽略根目錄的 temp（不含子目錄）
temp/                  # 忽略所有名為 temp 的目錄
doc/*.txt              # 忽略 doc 目錄下的 .txt（不包含子目錄）
doc/**/*.txt           # 忽略 doc 目錄及所有子目錄下的 .txt

# 萬用字元
*.a                    # 忽略所有 .a 檔案
*.[oa]                 # 忽略所有 .o 和 .a 檔案
*.py[cod]              # 忽略 .pyc, .pyo, .pyd 檔案
```

### 規則優先順序

1. 具體規則 > 萬用字元規則
2. 後面的規則 > 前面的規則
3. `!` 例外規則優先

**範例：**
```gitignore
*.log              # 忽略所有 .log
!important.log     # 但保留 important.log

logs/*.log         # 忽略 logs/ 下的所有 .log
!logs/keep.log     # 但保留 logs/keep.log
```

---

## 常見忽略範例

### 作業系統相關

```gitignore
# macOS
.DS_Store
.AppleDouble
.LSOverride
._*

# Windows
Thumbs.db
Thumbs.db:encryptable
ehthumbs.db
ehthumbs_vista.db
Desktop.ini
$RECYCLE.BIN/

# Linux
*~
.directory
.Trash-*
```

### IDE 和編輯器

```gitignore
# Visual Studio Code
.vscode/
*.code-workspace

# JetBrains IDEs (IntelliJ, PyCharm, WebStorm, etc.)
.idea/
*.iml
*.iws

# Vim
*.swp
*.swo
*~
.*.sw[a-z]

# Emacs
*~
\#*\#
.\#*

# Sublime Text
*.sublime-project
*.sublime-workspace
```

### Python

```gitignore
# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*$py.class

# Distribution / packaging
dist/
build/
*.egg-info/
.eggs/

# Virtual environments
venv/
ENV/
env/
.venv

# Pytest
.pytest_cache/
.coverage
htmlcov/

# Jupyter Notebook
.ipynb_checkpoints

# pyenv
.python-version
```

### Node.js / JavaScript

```gitignore
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
package-lock.json   # 可選，團隊決定
yarn.lock          # 可選，團隊決定

# Production
/build
/dist

# Testing
coverage/

# Next.js
.next/
out/

# Nuxt.js
.nuxt/
dist/

# Environment variables
.env
.env.local
.env.*.local
```

### Java / Maven / Gradle

```gitignore
# Compiled class files
*.class

# Package Files
*.jar
*.war
*.ear

# Maven
target/
pom.xml.tag
pom.xml.releaseBackup
pom.xml.versionsBackup

# Gradle
.gradle/
build/

# IntelliJ
*.iml
.idea/
```

### Rust

```gitignore
# Compiled files
target/
Cargo.lock          # 可選，library 通常忽略

# Backup files
**/*.rs.bk
```

### Go

```gitignore
# Binaries
*.exe
*.exe~
*.dll
*.so
*.dylib

# Test binary
*.test

# Output of the go coverage tool
*.out

# Dependency directories
vendor/
```

### C / C++

```gitignore
# Compiled Object files
*.o
*.obj
*.elf

# Compiled Dynamic libraries
*.so
*.dylib
*.dll

# Compiled Static libraries
*.a
*.lib

# Executables
*.exe
*.out
*.app

# Build directories
/build/
/out/
```

### 通用建置產物

```gitignore
# Logs
logs/
*.log
npm-debug.log*

# Build artifacts
dist/
build/
out/
target/

# Compressed files
*.zip
*.tar.gz
*.rar

# Database
*.sql
*.sqlite
*.db
```

### 敏感資料

```gitignore
# Environment variables
.env
.env.local
.env.*.local

# Credentials
*.pem
*.key
credentials.json
secrets.yaml

# Configuration with secrets
config/secrets.yml
config/database.yml
```

---

## .gitignore 位置

### 全域 .gitignore

對所有倉庫生效：
```bash
# 創建全域 .gitignore
touch ~/.gitignore_global

# 配置 Git 使用
git config --global core.excludesfile ~/.gitignore_global

# 編輯全域忽略規則
vim ~/.gitignore_global
```

**全域 .gitignore 範例：**
```gitignore
# 作業系統
.DS_Store
Thumbs.db

# 編輯器
*.swp
*.swo
*~

# IDE
.vscode/
.idea/
```

### 專案 .gitignore

在專案根目錄的 `.gitignore` 對該倉庫生效。

### 子目錄 .gitignore

可在子目錄放置 `.gitignore` 來補充根目錄的規則。

---

## 常見操作

### 忽略已追蹤的檔案

如果檔案已被 Git 追蹤，只加入 `.gitignore` 不會忽略它。需要：

```bash
# 從 Git 移除但保留本地檔案
git rm --cached <file>
git rm --cached -r <directory>

# 提交變更
git commit -m "Stop tracking <file>"
```

**範例：**
```bash
# 忽略已追蹤的 .env 檔案
echo ".env" >> .gitignore
git rm --cached .env
git commit -m "Stop tracking .env"
```

### 檢查為何檔案被忽略

```bash
git check-ignore -v <file>         # 顯示匹配的規則
git check-ignore -v *              # 檢查所有檔案
```

### 強制添加被忽略的檔案

```bash
git add -f <file>                  # 強制添加
git add --force <file>             # 同上
```

### 查看忽略的檔案

```bash
git status --ignored               # 顯示被忽略的檔案
git clean -ndX                     # 預覽要清理的忽略檔案
git clean -fdX                     # 刪除所有忽略的檔案
```

---

## 最佳實踐

### 應該忽略

- ✅ 建置產物和編譯檔案
- ✅ 依賴套件目錄（node_modules、vendor）
- ✅ 日誌檔案和臨時檔案
- ✅ 作業系統生成的檔案
- ✅ IDE 配置（個人化設定）
- ✅ 環境變數和敏感資料
- ✅ 測試覆蓋率報告

### 不應忽略

- ❌ 專案必需的配置範本（如 .env.example）
- ❌ 鎖定檔案（package-lock.json，適用於應用程式）
- ❌ 專案特定的 IDE 配置（如果團隊共享）
- ❌ 文檔和 README

### 團隊協作

1. **提早建立** `.gitignore`，專案初始化時就設定好
2. **保持更新**，隨著專案發展補充規則
3. **團隊討論**，確保團隊成員同意忽略規則
4. **註解說明**，對不明顯的規則加上註解
5. **使用範本**，參考 [gitignore.io](https://www.toptal.com/developers/gitignore) 或 GitHub 範本

### 敏感資料處理

```gitignore
# 永不提交敏感資料
.env
*.key
*.pem
credentials.json
secrets.yaml

# 提供範本檔案
# .env.example 應該被追蹤
```

**提供範本範例：**
```bash
# .env.example（被追蹤）
DB_HOST=localhost
DB_PORT=5432
DB_USER=your_username
DB_PASSWORD=your_password
API_KEY=your_api_key

# .env（被忽略）
DB_HOST=localhost
DB_PORT=5432
DB_USER=actual_username
DB_PASSWORD=actual_password
API_KEY=actual_api_key_here
```

---

## 範本資源

### 線上產生器

- **gitignore.io**: https://www.toptal.com/developers/gitignore
  - 輸入語言/框架/IDE，自動生成 .gitignore

### GitHub 官方範本

- https://github.com/github/gitignore
  - 各種語言和框架的官方範本

### 常用組合範本

```bash
# Python + VS Code
curl https://www.toptal.com/developers/gitignore/api/python,visualstudiocode > .gitignore

# Node.js + IntelliJ
curl https://www.toptal.com/developers/gitignore/api/node,intellij > .gitignore
```

---

## 相關文檔

- [基礎操作](basics.md) - Git 基本指令
- [疑難排解](troubleshooting.md) - 處理忽略問題
