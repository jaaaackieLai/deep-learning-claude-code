# Agent Colloquium Skills

## 目標

對論文進行深入理解。目前讀論文的方式是直接丟給模型，容易繞過論文的盲點與未提及的事物。透過多 agent 模擬學術研討會（Paper Colloquium），以不同專業視角交叉質詢，挖出單一模型容易忽略的問題。

## 設計決策

| 項目 | 決策 |
|------|------|
| Agent 角色 | 學術審稿風格：Reviewer 1/2/3 各有明確分工 |
| 使用者角色 | 主持人（可插入問題、引導方向） |
| 終止條件 | 固定 6 輪（每位 Reviewer 各提問 2 次） |
| 產出格式 | 結構化報告 |
| 論文輸入 | 整合現有 paper skill 讀取 PDF |

## 兩種模式

### Claude-only 模式
3 個獨立 Claude agent 互相傳遞訊息：
```
使用者（主持人）
    │
    ▼
Orchestrator（SKILL.md 指引 Claude 主進程）
    │
    ├── Task(subagent) → Reviewer 1 (方法論)
    ├── Task(subagent) → Reviewer 2 (文獻脈絡)
    ├── Task(subagent) → Reviewer 3 (實驗可重現)
    │
    └── Task(subagent) → Meeting Secretary（最終統整）
```

### 多模型模式
3 巨頭模型（Claude, OpenAI, Gemini）都納入，已建立 MCP 機制：
```
使用者（主持人）
    │
    ▼
Orchestrator（Claude 主進程）
    │
    ├── Task(subagent)      → Reviewer 1 (Claude, 方法論)
    ├── gpt_messages MCP    → Reviewer 2 (GPT, 文獻脈絡)
    ├── gemini_messages MCP  → Reviewer 3 (Gemini, 實驗可重現)
    │
    └── Task(subagent)      → Meeting Secretary (Claude)
```

## 三位 Reviewer 角色定義

### Reviewer 1 — 方法論審查者 (Methodology Critic)
- 審視研究方法的嚴謹性、假設的合理性
- 檢查統計方法是否恰當、是否有邏輯漏洞
- 質疑因果推論的有效性

### Reviewer 2 — 文獻脈絡審查者 (Literature & Context Reviewer)
- 檢視相關工作的完整性與引用是否充分
- 探索論文未提及但相關的研究方向
- 評估論文在該領域的定位與貢獻度

### Reviewer 3 — 實驗與可重現性審查者 (Experiment & Reproducibility Reviewer)
- 評估實驗設計的完整性（baseline、ablation）
- 檢查可重現性（資料集、超參數、程式碼）
- 評估實際應用的可行性與限制

### 會議助理 (Meeting Secretary)
- 記錄每輪討論的關鍵問題與回應
- 追蹤已達成共識與仍有爭議的議題
- 最終產出結構化報告

## 討論流程

```
[Phase 0] 論文讀取
  └─ 使用 paper skill 讀取 PDF → 產生論文摘要與關鍵內容

[Phase 1] 獨立審閱
  └─ 三位 Reviewer 各自基於角色撰寫初步審閱意見

[Phase 2] 交叉討論（6 輪）
  Round 1: R1 提問 → R2, R3 回答
  Round 2: R2 提問 → R1, R3 回答
  Round 3: R3 提問 → R1, R2 回答
  --- 使用者（主持人）可在此處插入問題或引導方向 ---
  Round 4: R1 提問（基於前3輪深化）→ R2, R3 回答
  Round 5: R2 提問 → R1, R3 回答
  Round 6: R3 提問 → R1, R2 回答

[Phase 3] 總結
  └─ 會議助理統整所有討論 → 產出結構化報告
```

### 主持人互動方式
每輪之間，使用者（主持人）可以：
- 插入自己的問題讓 Reviewer 們回答
- 要求某位 Reviewer 深入特定面向
- 跳過某輪或提前結束

## 檔案結構

```
skills/agent-colloquium-skills/
├── SKILL.md                              # 技能主定義（觸發條件 + 完整流程指引）
├── plan.md                               # 構想文件
└── references/
    ├── reviewer-roles.md                 # 三位 Reviewer 的詳細角色定義與 prompt
    ├── orchestration-guide.md            # 討論流程編排指引（含兩種模式）
    ├── meeting-secretary-guide.md        # 會議助理的記錄與統整指引
    └── report-template.md               # 結構化報告的模板
```

## 結構化報告模板（產出）

```markdown
# 論文研討會報告
## 論文資訊
## 各 Reviewer 初步審閱意見
## 交叉討論紀錄（按輪次）
## 關鍵發現
  ### 已達成共識
  ### 仍有爭議
  ### 論文盲點與未提及事項
## 綜合評估
  ### 方法論評價
  ### 文獻定位
  ### 實驗完整性
  ### 整體貢獻度
## 延伸建議（後續研究方向）
```

## 實作步驟

1. 建立 `references/` 目錄與角色定義（`reviewer-roles.md`）
2. 建立報告模板（`report-template.md`）
3. 建立流程指引（`orchestration-guide.md`、`meeting-secretary-guide.md`）
4. 建立 `SKILL.md` 技能主定義
5. 註冊到 `.claude-plugin/marketplace.json`
6. 測試驗證

## 關鍵依賴

| 依賴 | 路徑 | 用途 |
|------|------|------|
| Paper skill | `skills/paper/` | PDF 論文讀取與摘要 |
| GPT MCP server | `mcps/gpt-server/` | 多模型模式的 GPT 呼叫 |
| Gemini MCP server | `mcps/gemini-server/` | 多模型模式的 Gemini 呼叫 |
