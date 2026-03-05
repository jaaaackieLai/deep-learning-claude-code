# CLAUDE.md

此檔案為 Claude Code (claude.ai/code) 在此程式庫中工作時提供指引。

## 專案描述

本專案為 Claude Code 的擴充市集，提供 commands、agents 及 skills 等元件，讓使用者能在自己的專案中擴充 Claude Code 的功能。

**目標受眾**：以 Python 進行軟體開發的深度學習研究學者

**核心目標**：整合現有開源資源，精選並優化深度學習研究工作流程所需的工具與能力


## Directory

```
├── .claude-plugin/     # Claude 插件配置
├── agents/             # 代理程式目錄 (analyzer, planner, tdd-guide)
├── claude-settings/    # Claude 設定檔範本
├── CLAUDE.md           # 專案指引文件
├── commands/           # 命令目錄 (plan, tdd, test-coverage, update-codemaps, update-docs)
├── docs/               # 文件目錄
│   ├── en/            # 英文文件
│   └── zh-TW/         # 繁體中文文件
├── README.md           # 專案說明
└── skills/             # 技能目錄
    ├── brainstorming/  # 腦力激盪技能 (scientific, software)
    ├── continuous-learning/ # 持續學習技能
    └── paper/          # 論文分析技能
```
