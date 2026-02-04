# Continuous Learning v2 - 使用指南

## 快速開始

### 1. 安裝和配置

#### 啟用 Observation Hooks

編輯 `~/.claude/settings.json`：

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "~/.claude/skills/continuous-learning/hooks/observe.sh pre"
      }]
    }],
    "PostToolUse": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "~/.claude/skills/continuous-learning/hooks/observe.sh post"
      }]
    }]
  }
}
```

#### 初始化目錄結構

```bash
mkdir -p ~/.claude/homunculus/{clarifications,instincts/{personal,inherited},evolved/{agents,skills,commands}}
touch ~/.claude/homunculus/observations.jsonl
```

#### 安裝依賴（選用）

如果要使用 AI 分析（Haiku），需要安裝：

```bash
pip install anthropic
export ANTHROPIC_API_KEY="your-api-key"
```

**注意**：如果沒有 API key，系統會使用 fallback 規則生成 hints（仍然有效）。

### 2. 驗證安裝

運行測試腳本：

```bash
cd skills/continuous-learning
python3 scripts/test-clarification.py
```

預期輸出：
```
✓ Created 8 observation events
Pattern detected: iterative_correction (confidence: 60%)
✅ Clarification hint saved to: ...
```

### 3. 實際使用

#### 自動模式（推薦）

只要配置好 hooks，系統就會自動：
1. 監測所有工具使用
2. 識別 correction patterns
3. 生成 clarification hints

**無需手動操作**。

#### 查看生成的 Clarifications

```bash
# 列出所有 clarifications
ls ~/.claude/homunculus/clarifications/

# 查看最新的 clarification
cat ~/.claude/homunculus/clarifications/clarification-*.yaml | tail -20
```

#### 手動觸發分析

如果想手動分析最近的活動：

```bash
cd skills/continuous-learning
python3 scripts/analyze-correction.py --last-turns 10
```

## 檢測的 Pattern 類型

### 1. Rapid Re-edit（快速重複編輯）
**觸發條件**：同一檔案短時間內多次編輯

**範例場景**：
```
User: "Refactor the login function"
Claude: [重寫整個認證模組]
User: "不是這樣，我只要重新命名變數"
Claude: [再次編輯]
```

**生成的 Hint**：
> "When user says 'refactor', clarify: structural change or rename only?"

### 2. Error Recovery（錯誤恢復）
**觸發條件**：工具報錯後成功修復

**範例場景**：
```
Claude: [運行測試]
Output: "Error: API not mocked"
User: "You need to mock the API first"
Claude: [添加 mock]
Output: "All tests passed"
```

**生成的 Hint**：
> "When encountering test errors, clarify whether mocks/fixtures are expected."

### 3. Repeated Tool（工具重複使用）
**觸發條件**：同一工具連續使用 3 次以上

**範例場景**：
```
Claude: [Write config.json]
User: "Add database settings"
Claude: [Write config.json again]
User: "Also add API keys"
Claude: [Write config.json again]
```

**生成的 Hint**：
> "When writing config files, gather all requirements upfront before editing."

## Token 效率

### 傳統方法（方案 1/2）
```
每次分析：6,000 - 23,000 tokens
觸發：手動（使用者記得的話）
頻率：每個 session 0-2 次
```

### 新方法（方案 3）✨
```
每次分析：1,000 - 2,500 tokens  (降低 80-90%)
觸發：自動（無需記得）
頻率：每次誤解發生時
模型：Haiku（成本是 Sonnet 的 1/5）
```

**實際節省**：
- 單次分析：節省 ~5-20K tokens
- 每天 5 次誤解：節省 ~25-100K tokens
- 每月：節省 ~750K-3M tokens

## 進階配置

### 調整 Confidence 閾值

編輯 `config.json`：

```json
{
  "clarifications": {
    "enabled": true,
    "min_confidence": 0.5,  // 降低以捕獲更多 hints
    "max_clarifications": 50  // 限制儲存的 hint 數量
  }
}
```

### 自定義檢測 Patterns

編輯 `config.json`：

```json
{
  "clarifications": {
    "detection_patterns": [
      "rapid_re_edit",
      "error_then_success",
      "repeated_tool",
      "iterative_correction"
    ]
  }
}
```

### 禁用 Clarification Detection

如果暫時不需要：

```json
{
  "clarifications": {
    "enabled": false
  }
}
```

或者：

```bash
touch ~/.claude/homunculus/disabled
```

## 故障排除

### Clarifications 沒有生成？

1. 檢查 hooks 是否正確配置：
   ```bash
   grep -A 10 "PreToolUse" ~/.claude/settings.json
   ```

2. 檢查 observations 是否被記錄：
   ```bash
   tail ~/.claude/homunculus/observations.jsonl
   ```

3. 手動運行分析看是否有錯誤：
   ```bash
   python3 scripts/analyze-correction.py --last-turns 5
   ```

### API 錯誤

如果看到 "Warning: anthropic package not installed"：
- 這是正常的，系統會使用 fallback 規則
- 如果想使用 AI 分析，安裝：`pip install anthropic`

### Permissions 錯誤

確保腳本有執行權限：

```bash
chmod +x hooks/observe.sh
chmod +x scripts/analyze-correction.py
```

## 下一步

1. **使用一段時間**：讓系統累積 clarifications
2. **定期查看**：`cat ~/.claude/homunculus/clarifications/*.yaml`
3. **手動整合**：將常見的 clarifications 轉為正式 skills
4. **分享經驗**：導出有用的 clarifications 給團隊

## 相關命令

```bash
# 查看 instincts 狀態
python3 scripts/instinct-cli.py status

# 導出 instincts
python3 scripts/instinct-cli.py export --output my-instincts.yaml

# 演化 instincts 為 skills
python3 scripts/instinct-cli.py evolve --generate

# 測試 clarification detection
python3 scripts/test-clarification.py
```
