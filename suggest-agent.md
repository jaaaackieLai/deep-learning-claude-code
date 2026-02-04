# 深度学习研究者推荐 Agents

本文档列出参考仓库中对深度学习研究工作流程特别有价值的 agents（代理）。

---

## 核心 Agents

### 1. TDD Guide（测试驱动开发指导）
**路径:** `reference_repo/everything-claude-code/agents/tdd-guide.md`

**功能:**
- 强制执行"先写测试"方法论的测试驱动开发专家
- 要求 80% 以上的代码覆盖率
- 遵循 RED-GREEN-REFACTOR 循环
- 包括单元测试、集成测试、端到端测试

**对深度学习研究者的价值:**
- 确保研究代码可测试、可维护、可复现
- 防止训练流程和数据处理中的静默失败
- 在运行昂贵的 GPU 实验前捕获 bug
- 强制良好的代码结构，便于后续复用和发表

---

### 2. Code Reviewer（代码审查专家）
**路径:** `reference_repo/everything-claude-code/agents/code-reviewer.md`

**功能:**
- 专业代码审查，关注质量、安全性、可维护性
- 检查最佳实践、设计模式、性能问题
- 识别潜在 bug 和安全漏洞
- 提供重构建议

**对深度学习研究者的价值:**
- 在早期阶段捕获 bug，避免浪费 GPU 时间
- 确保研究代码质量，特别是可能转为生产模型的代码
- 检测常见的 PyTorch/NumPy 反模式
- 提高代码可读性，便于论文发表和开源

---

### 3. Python Reviewer（Python 专家审查）
**路径:** `reference_repo/everything-claude-code/agents/python-reviewer.md`

**功能:**
- Python 特定的代码审查
- 针对科学计算的模式检查
- NumPy/PyTorch/Pandas 最佳实践
- 性能瓶颈识别

**对深度学习研究者的价值:**
- 捕获 Python 特定问题（内存泄漏、低效循环）
- 优化 NumPy/PyTorch 操作，提升训练速度
- 确保数据处理管道的效率
- 识别向量化机会，减少训练时间

---

### 4. Architect（架构设计专家）
**路径:** `reference_repo/everything-claude-code/agents/architect.md`

**功能:**
- 系统设计专家，用于 ML 架构设计
- 评估架构决策和权衡
- 提供可扩展性和模块化建议
- 设计数据流和训练管道

**对深度学习研究者的价值:**
- 设计可扩展的 ML 系统（从单 GPU 到分布式训练）
- 规划数据管道架构（ETL、预处理、增强）
- 设计模型服务架构（批量推理、在线 API）
- 帮助从实验代码过渡到生产系统

---

### 5. Build Error Resolver（构建错误解决专家）
**路径:** `reference_repo/everything-claude-code/agents/build-error-resolver.md`

**功能:**
- 调试构建失败的专家
- 解决依赖冲突
- 修复编译和安装问题
- 处理环境配置问题

**对深度学习研究者的价值:**
- 快速解决 PyTorch/TensorFlow/CUDA 安装问题
- 处理复杂的依赖冲突（cuDNN 版本、Python 版本）
- 配置多 GPU 环境
- 解决 Docker 容器构建问题

---

### 6. Security Reviewer（安全审查专家）
**路径:** `reference_repo/everything-claude-code/agents/security-reviewer.md`

**功能:**
- 安全漏洞检测
- 依赖项审计
- 识别常见安全问题（注入攻击、权限问题）
- 数据隐私合规检查

**对深度学习研究者的价值:**
- 在模型投入生产前防止安全问题
- 处理敏感数据时尤其重要（医疗、基因组数据）
- 确保模型 API 的安全性
- 检查数据泄漏风险

---

## 推荐使用场景

### 场景 1: 开始新的深度学习项目
```
1. 使用 Architect → 设计系统架构和数据管道
2. 使用 TDD Guide → 编写测试框架
3. 实现模型和训练逻辑
4. 使用 Python Reviewer → 优化性能
5. 使用 Code Reviewer → 最终质量检查
```

### 场景 2: 调试训练失败
```
1. 使用 Build Error Resolver → 排除环境问题
2. 使用 Python Reviewer → 检查代码中的性能和逻辑问题
3. 使用 TDD Guide → 编写回归测试防止再次发生
```

### 场景 3: 准备发布代码/模型
```
1. 使用 Code Reviewer → 全面代码审查
2. 使用 Security Reviewer → 安全检查
3. 使用 TDD Guide → 确保测试覆盖率充足
4. 使用 Python Reviewer → 最终性能优化
```

### 场景 4: 重构实验代码为生产代码
```
1. 使用 Architect → 重新设计架构
2. 使用 TDD Guide → 添加全面的测试
3. 使用 Code Reviewer → 确保代码质量
4. 使用 Security Reviewer → 生产环境安全检查
```

---

## 工作流程集成

### 完整的研究生命周期

```
设计阶段
└─ Architect (系统设计)

实现阶段
└─ TDD Guide (先写测试) → Python Reviewer (代码优化)

调试阶段
└─ Build Error Resolver (环境问题) → Python Reviewer (代码问题)

审查阶段
└─ Code Reviewer (质量检查) → Security Reviewer (安全检查)

发布阶段
└─ 所有审查 agents 再次运行
```

---

## 核心价值

### 1. **可复现性**
- TDD Guide 确保实验可复现
- Code Reviewer 捕获可能导致不一致结果的 bugt
- 全面的测试覆盖防止静默失败

### 2. **效率**
- Build Error Resolver 快速解决环境问题
- Python Reviewer 识别性能瓶颈，节省训练时间
- 早期 bug 检测节省 GPU 时间

### 3. **质量**
- Code Reviewer 在昂贵的训练运行前捕获 bug
- 多层审查确保代码质量
- 防止技术债务积累

### 4. **安全性**
- Security Reviewer 在部署前发现漏洞
- 处理敏感数据时保护隐私
- 确保模型 API 安全

### 5. **生产就绪**
- Architect 确保可扩展的设计
- 多个 reviewers 确保生产级质量
- 从实验到生产的平滑过渡

---

## 优先级实施路线图

### 第一阶段：核心基础（第 1 周）
1. **TDD Guide** - 建立测试驱动开发习惯
2. **Build Error Resolver** - 解决环境配置问题

### 第二阶段：质量保证（第 2-3 周）
3. **Python Reviewer** - 优化代码性能
4. **Code Reviewer** - 建立代码审查流程

### 第三阶段：架构与安全（第 4 周+）
5. **Architect** - 设计可扩展系统
6. **Security Reviewer** - 生产环境准备

---

## 安装建议

```bash
# 安装 Everything Claude Code（包含所有上述 agents）
/plugin marketplace add affaan-m/everything-claude-code
/plugin install everything-claude-code@everything-claude-code
```

---

## 使用示例

### 示例 1: 审查训练代码
```bash
# 在终端中
claude code

# 在对话中
User: 请使用 Python Reviewer agent 审查我的训练代码 train.py

Agent: [读取代码，提供优化建议]
- 建议使用 DataLoader 的 num_workers 参数提升数据加载速度
- 识别出内存泄漏：梯度未清零
- 建议使用混合精度训练加速
```

### 示例 2: 设计新模型架构
```bash
User: 我想构建一个蛋白质功能预测模型，请使用 Architect agent 帮我设计架构

Agent: [分析需求，提供架构建议]
- 数据管道：HDF5 存储 → DataLoader → GPU
- 模型架构：Graph Neural Network (推荐 PyTorch Geometric)
- 训练：PyTorch Lightning + DDP 多 GPU
- 评估：分层交叉验证
- 部署：FastAPI + 批量推理
```

### 示例 3: 准备发布开源代码
```bash
User: 我要开源我的模型，请帮我准备

Step 1: TDD Guide 检查测试覆盖率
→ 当前覆盖率 45%，建议添加数据加载和模型推理测试

Step 2: Code Reviewer 全面审查
→ 发现 3 个 bug，10 个代码质量问题

Step 3: Security Reviewer 安全检查
→ 发现硬编码的 API key，建议使用环境变量

Step 4: Python Reviewer 性能优化
→ 优化数据预处理，速度提升 3x
```

---

## 总结

这 6 个核心 agents 提供深度学习研究的完整支持：

| Agent | 阶段 | 关键价值 |
|-------|------|---------|
| Architect | 设计 | 可扩展架构 |
| TDD Guide | 实现 | 可测试代码 |
| Build Error Resolver | 配置 | 快速环境设置 |
| Python Reviewer | 优化 | 性能提升 |
| Code Reviewer | 质量 | Bug 预防 |
| Security Reviewer | 部署 | 安全保障 |

**推荐起点：** 从 TDD Guide 和 Build Error Resolver 开始。这两个 agents 为所有后续工作奠定基础。

**关键洞察：** 这些不仅是编码工具，而是研究方法论工具，帮助产出严谨、可复现、生产就绪的深度学习研究。
