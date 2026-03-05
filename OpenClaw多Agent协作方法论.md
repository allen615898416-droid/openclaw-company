# OpenClaw 多 Agent 协作方法论

> **"一人公司 + N 个数字员工"** — 用 AI Agent 团队替代传统人力，实现一个人管理一家公司
>
> 作者：Allen | 基于 OpenClaw 框架 + 龙虾营（ClawCamp）实战经验

---

## 目录

1. [这是什么](#1-这是什么)
2. [核心理念](#2-核心理念)
3. [架构设计](#3-架构设计)
4. [环境准备](#4-环境准备)
5. [从零搭建：以"4 人精简团队"为例](#5-从零搭建以4-人精简团队为例)
6. [进阶：17 人完整 Squad 架构](#6-进阶17-人完整-squad-架构)
7. [三个核心配置文件详解](#7-三个核心配置文件详解)
8. [实战踩坑与最佳实践](#8-实战踩坑与最佳实践)
9. [如何迁移到你自己的业务](#9-如何迁移到你自己的业务)
10. [FAQ](#10-faq)

---

## 1. 这是什么

OpenClaw 是一个开源的 AI Agent 框架。你可以在上面创建多个 AI Agent，每个 Agent 有独立的：
- **身份（SOUL.md）**：它是谁，擅长什么，怎么思考
- **记忆（MEMORY.md）**：它知道哪些背景信息
- **用户认知（USER.md）**：它怎么理解你这个老板

这些 Agent 之间可以互相对话、分派任务、汇总结果。你通过 Telegram / 飞书 跟它们沟通，就像管理一个真实团队。

### 实际效果

```
你（Telegram）→ CEO Bot："帮我做洛克手游的首发方案"

CEO Bot 自动：
  ├── spawn 商务负责人 → 输出渠道资源锁定方案
  ├── spawn 运营负责人 → 输出运营活动策划
  └── spawn 产研负责人 → 输出技术排期和风险评估

CEO Bot 汇总三条线结果 → 返回给你一份完整的首发方案
```

**你只需要跟 CEO 说一句话，整个团队就开始协作。**

---

## 2. 核心理念

### 2.1 不是"一个 AI 干所有事"

常见误区：把所有需求丢给一个 ChatGPT 对话框。

问题：
- 上下文越来越长，AI 容易"忘记"之前说的
- 没有专业化分工，回答停留在通用层面
- 无法并行处理多个任务

**正确做法**：像真实公司一样，把不同职能拆给不同的 Agent。

### 2.2 SOUL 决定 Agent 的"灵魂"

**SOUL.md 是最关键的配置文件**。它决定了：

| 维度 | 作用 | 举例 |
|------|------|------|
| 身份定位 | Agent 认为自己是谁 | "你是渠道商务线负责人" |
| 专业能力 | 擅长什么领域 | "精通 CPS 分成策略、渠道谈判" |
| 知识边界 | 什么不该做 | "不编造数据，不知道就说不知道" |
| 协作关系 | 跟谁配合 | "向 CEO 汇报，横向协调运营线" |
| 思考方式 | 怎么分析问题 | "数据驱动，先给数据再给结论" |

**SOUL 越具体，Agent 越专业。但也意味着它只适合特定领域。**

### 2.3 CEO 是调度中心

```
        你（创始人）
            │
         CEO Agent
        ╱    │    ╲
   商务线  运营线  产研线
```

- 你只跟 CEO 交流
- CEO 理解你的意图，拆解成子任务
- CEO spawn 对应的 Agent 去执行
- 各线完成后，CEO 汇总结果返回给你

**你不需要分别跟每个 Agent 说话**（当然你也可以直接找某个 Agent 聊）。

---

## 3. 架构设计

### 3.1 精简版（4 人团队）— 推荐入门

适合：已有明确业务方向，团队分工清晰

```
CEO（总负责人）
 ├── 商务负责人（对外合作、渠道关系）
 ├── 运营负责人（用户增长、活动策划）
 └── 产研负责人（技术方案、工程管理）
```

- 4 个 Agent，4 个 Telegram Bot
- 配置简单，API 消耗低
- 实际验证过，稳定运行

### 3.2 完整版（17 人 Squad 架构）— 进阶

适合：想模拟一家完整公司的运作

```
CEO（创始人）
 │
 ├── 产品增长队（Product Squad）
 │   ├── 产品负责人（Squad Lead）
 │   ├── 用户研究员
 │   ├── 全栈工程师
 │   ├── UX 设计师
 │   └── 文档专家
 │
 ├── 技术平台队（Platform Squad）
 │   ├── 工程经理（Squad Lead）
 │   ├── 后端专家
 │   ├── DevOps 工程师
 │   ├── QA 工程师
 │   └── 安全工程师
 │
 └── 营销增长队（Growth Squad）
     ├── 增长负责人（Squad Lead）
     ├── 内容策划
     ├── 获客专家
     ├── 客户成功
     └── 数据分析师
```

- 16 个 Agent + 1 个默认 main Agent
- 采用 Spotify Squad 模式
- 每个 Squad 有独立的 Lead 负责协调
- 支持每日自动生成工作计划（21 个文档）

### 3.3 如何选择？

| 场景 | 推荐 | 理由 |
|------|------|------|
| 第一次用 OpenClaw | 精简版 | 配置少，容易理解和调试 |
| 个人项目/小业务 | 精简版 | 4 人够用，API 成本低 |
| 想做完整的公司模拟 | 完整版 | 分工细致，每个角色专业化 |
| 给团队演示/分享 | 先精简版跑通，再演示完整版理念 | 降低理解门槛 |

---

## 4. 环境准备

### 4.1 必须准备的

| 项目 | 说明 | 获取方式 |
|------|------|----------|
| **Node.js** | v18+ | `brew install node` |
| **OpenClaw** | 核心框架 | `npm install -g openclaw` |
| **AI 模型 API Key** | 大脑 | Moonshot / OpenAI / Anthropic 等 |
| **消息通道** | 跟 Agent 沟通的入口 | Telegram Bot Token 或 飞书应用 |

### 4.2 安装 OpenClaw

```bash
# 安装
npm install -g openclaw

# 验证
openclaw --version

# 初始化（会创建 ~/.openclaw/ 目录）
openclaw init
```

### 4.3 配置 AI 模型

```bash
# 以 Moonshot 为例
openclaw auth add moonshot
# 输入你的 API Key
```

### 4.4 配置消息通道

**Telegram 方案**（推荐个人使用）：
1. 在 Telegram 找 @BotFather
2. `/newbot` 创建 Bot，获取 Token
3. 每个 Agent 需要一个独立的 Bot

**飞书方案**（推荐企业使用）：
1. 在飞书开放平台创建应用
2. 每个 Agent 对应一个飞书应用
3. 参考 `OpenClaw飞书多机器人配置指南.pdf`

---

## 5. 从零搭建：以"4 人精简团队"为例

这是实际验证过的配置，以**腾讯游戏渠道业务**为场景。你需要根据自己的业务替换。

### 5.1 创建 Agent

```bash
# 创建 CEO
openclaw agents add ceo --workspace ~/.openclaw/workspace-ceo

# 创建三条业务线
openclaw agents add product-lead --workspace ~/.openclaw/workspace-product-lead
openclaw agents add engineering-manager --workspace ~/.openclaw/workspace-engineering-manager
openclaw agents add growth-lead --workspace ~/.openclaw/workspace-growth-lead
```

### 5.2 设置身份

```bash
openclaw agents set-identity --agent ceo --name "业务总负责人" --emoji "👑"
openclaw agents set-identity --agent product-lead --name "商务负责人" --emoji "🎯"
openclaw agents set-identity --agent engineering-manager --name "产研负责人" --emoji "🔧"
openclaw agents set-identity --agent growth-lead --name "运营负责人" --emoji "📈"
```

### 5.3 编写 SOUL.md（最核心的步骤）

在每个 Agent 的 workspace 下创建 `SOUL.md`。以下是编写原则：

#### SOUL.md 编写公式

```markdown
# [角色名]

## 身份定位
你是 [公司名] 的 [职位]。你的核心职责是 [一句话描述]。

## 核心能力
- [能力1]：[具体说明]
- [能力2]：[具体说明]
- [能力3]：[具体说明]

## 团队关系
- 汇报给：[上级]
- 协作方：[平级]
- 管理：[下级，如有]

## 工作原则
- [原则1]
- [原则2]

## 沟通风格
- [风格1]
- [风格2]

## 知识边界
- 不编造数据，不确定的信息如实说明
- 超出专业范围的问题，建议转给对应角色
```

#### 关键Tips

1. **身份定位要具体**：不要写"你是一个助手"，要写"你是XX公司渠道商务线负责人，专注CPS联运和渠道关系维护"
2. **一定要声明知识边界**：防止 AI 在不懂的领域编造答案
3. **写清楚协作关系**：Agent 才知道遇到跨领域问题该找谁
4. **用你的业务术语**：让 Agent 说"行话"，而不是通用表达

### 5.4 编写 MEMORY.md

```markdown
# [角色名] 记忆库

## 公司信息
- 公司：[公司名]
- 部门：[部门名]
- 业务：[一句话描述核心业务]

## 团队成员
- CEO：[姓名]，总负责人
- 商务：[姓名]，商务线
- 运营：[姓名]，运营线
- 产研：[姓名]，产研线

## 核心业务知识
- [业务知识1]
- [业务知识2]

## 沟通渠道
- CEO: agentId = ceo
- 商务: agentId = product-lead
- ...
```

### 5.5 编写 USER.md

```markdown
# 关于 Allen

## 基本信息
- 姓名：Allen
- 职位：[你的职位]
- 时区：UTC+8

## 沟通偏好
- 喜欢简洁直接，不要废话
- 重视数据驱动
- 习惯结构化的输出格式（表格、列表）

## 工作时间
- 工作日 09:00-19:00
```

### 5.6 配置 openclaw.json

核心配置项：

```jsonc
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "moonshot/kimi-k2.5"     // 选你的模型
      },
      "maxConcurrent": 2,                    // 同时处理的对话数
      "subagents": {
        "maxConcurrent": 3                   // CEO 同时 spawn 的子 Agent 数
      }
    },
    "list": [
      {
        "id": "ceo",
        "name": "业务总负责人",
        "workspace": "~/.openclaw/workspace-ceo",
        "identity": { "name": "CEO", "emoji": "👑" }
      }
      // ... 其他 Agent
    ]
  },
  "tools": {
    "agentToAgent": {
      "enabled": true,                       // 开启 Agent 间通信
      "allow": ["ceo", "product-lead", "engineering-manager", "growth-lead"]
    }
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "streaming": "partial",                // 流式输出
      "chunkMode": "newline",                // 长消息自动按段落分段
      "textChunkLimit": 4000,                // 单段最大字符数
      "accounts": {
        "ceo": {
          "botToken": "你的Bot Token",
          "streaming": "partial"
        }
        // ... 其他 Bot
      }
    }
  }
}
```

### 5.7 绑定路由

让 Telegram 消息路由到正确的 Agent：

```jsonc
{
  "bindings": [
    {
      "agentId": "ceo",
      "match": { "channel": "telegram", "accountId": "ceo" }
    },
    {
      "agentId": "product-lead",
      "match": { "channel": "telegram", "accountId": "product-lead" }
    }
    // ...
  ]
}
```

### 5.8 启动

```bash
# 启动网关
openclaw gateway

# 或者注册为系统服务（开机自启）
openclaw gateway install
```

---

## 6. 进阶：17 人完整 Squad 架构

### 6.1 一键创建

使用模板包里的脚本：

```bash
# 批量创建 16 个 Agent（+ 1 个默认 main）
bash 01-create-17-agents.sh

# 生成每日工作计划（21 个文档）
bash 02-generate-daily-plans.sh
```

### 6.2 Squad 模式说明

每个 Agent 有一个 `squad` 字段，标注它属于哪个小队：

```json
{
  "id": "fullstack-dev",
  "name": "全栈工程师",
  "squad": "product"    // 属于产品增长队
}
```

Squad Lead（产品负责人、工程经理、增长负责人）负责协调本队工作，CEO 只需要跟 3 个 Lead 沟通。

### 6.3 每日计划体系

```
~/OPC/daily-plans/2026-03-04/
├── 00-CEO总览.md                    # CEO 的全局视角
├── squad-product/
│   ├── Squad总览.md                 # 产品队当日重点
│   ├── product-lead.md              # 产品负责人任务卡
│   ├── user-researcher.md
│   ├── fullstack-dev.md
│   ├── ux-designer.md
│   └── technical-writer.md
├── squad-platform/
│   ├── Squad总览.md
│   └── ...
└── squad-growth/
    ├── Squad总览.md
    └── ...
```

每天早上自动生成，各 Agent 根据任务卡执行当天的工作。

---

## 7. 三个核心配置文件详解

### 7.1 SOUL.md — Agent 的灵魂

**作用**：定义 Agent 是谁、怎么思考、怎么行动

**关键原则**：
- 越具体越好，但要跟实际业务匹配
- 一定要声明知识边界（防幻觉）
- 写清楚协作关系（Agent 才知道该找谁）
- CEO 的 SOUL 要包含"如何调度其他 Agent"的说明

**反面教材**：
```markdown
# 错误示范
你是一个有用的助手，帮用户回答问题。
```

**正确示范**：
```markdown
# 正确示范
你是 XX 公司渠道商务线负责人。你的核心职责是维护渠道合作关系、
谈判 CPS 分成策略、分析商务数据。你向 CEO 汇报，横向协调
运营线和产研线。遇到不确定的数据，如实说明，不编造。
```

### 7.2 MEMORY.md — Agent 的记忆

**作用**：提供 Agent 需要随时调取的背景知识

**什么该放 MEMORY**：
- 公司/团队基本信息
- 核心业务知识（不会频繁变化的）
- 关键联系人和沟通渠道
- 工作原则和流程

**什么不该放 MEMORY**：
- 临时性的任务安排（放每日计划）
- 大段的数据报告（通过对话传递）
- 频繁变化的信息（维护成本高）

### 7.3 USER.md — 老板画像

**作用**：让 Agent 理解你的偏好，调整沟通方式

**所有 Agent 共用同一份 USER.md 即可**，因为老板只有一个。

---

## 8. 实战踩坑与最佳实践

### 8.1 踩过的坑

| 问题 | 原因 | 解决方案 |
|------|------|----------|
| Agent 不回复 | Telegram 消息超 4096 字符，发送失败 | 开启 `streaming: "partial"` + `chunkMode: "newline"` |
| API rate limit | 模型 API 调用频率超限 | 降低 `maxConcurrent`，或升级 API 配额 |
| CEO 读不到子 Agent 结果 | session 可见性限制 | 配置 `tools.sessions.visibility: "all"` |
| Agent 在不擅长的领域编造答案 | SOUL 没有声明知识边界 | 在 SOUL.md 加"不编造数据"的明确声明 |
| 切换业务场景后 Agent 乱来 | SOUL 高度特化，无法迁移 | 新场景 = 新建一套 Agent 配置 |

### 8.2 最佳实践

1. **先跑通精简版，再扩展**：4 个 Agent 调试好了，再考虑加人
2. **SOUL 先写简单，逐步迭代**：不要一开始就写 200 行的 SOUL，跑几轮对话后再补充
3. **每个 SOUL 必须有知识边界声明**：这是防幻觉的最关键措施
4. **CEO 的 SOUL 要写"汇总原则"**：比如"汇总各线结果时，保留原始要点，不自行加工"
5. **streaming 建议开启 partial**：体验更好，且能自动处理长消息
6. **并发数要匹配你的 API 配额**：Moonshot 免费版 QPM 低，`maxConcurrent` 不要设太高

### 8.3 调试技巧

```bash
# 查看网关日志
tail -f ~/.openclaw/logs/gateway.log

# 查看某个 Agent 的对话历史
ls ~/.openclaw/agents/ceo/sessions/

# 在 Dashboard 里直接测试对话
# 打开浏览器访问 http://localhost:18789
```

---

## 9. 如何迁移到你自己的业务

### 9.1 三步迁移法

#### 第一步：定义你的团队结构

问自己：
- 我的业务需要哪几条线？（比如：销售、研发、市场）
- 每条线的核心职能是什么？
- 谁向谁汇报？

画出来：
```
你
 └── CEO
      ├── [线1] - [职能]
      ├── [线2] - [职能]
      └── [线3] - [职能]
```

#### 第二步：为每个角色写 SOUL

用这个模板：
```markdown
# [角色名]

## 身份定位
你是 [公司名] 的 [职位]。
核心职责：[一句话]。

## 核心能力（3-5 项）
## 团队关系
## 工作原则
## 沟通风格
## 知识边界（必须有！）
```

#### 第三步：配置 + 启动 + 迭代

1. 创建 Agent、写好 SOUL/MEMORY/USER
2. 启动，跟 CEO 对话测试
3. 根据实际对话效果，**迭代 SOUL**

**SOUL 的迭代是持续的**，不是写一次就完事。每次发现 Agent 回答不好，就回去改 SOUL。

### 9.2 业务场景示例

#### 示例 A：电商团队
```
CEO
 ├── 选品负责人（SOUL: 精通供应链、市场趋势、竞品分析）
 ├── 运营负责人（SOUL: 精通平台规则、活动策划、数据分析）
 └── 客服负责人（SOUL: 精通售后处理、用户沟通、评价管理）
```

#### 示例 B：内容创业
```
CEO
 ├── 内容主编（SOUL: 选题策划、内容审核、风格把控）
 ├── 增长负责人（SOUL: 全平台分发、粉丝运营、数据分析）
 └── 商业化负责人（SOUL: 广告合作、知识付费、品牌变现）
```

#### 示例 C：技术团队
```
CEO
 ├── 产品经理（SOUL: 需求分析、优先级排序、用户故事）
 ├── 技术负责人（SOUL: 架构设计、代码审查、技术选型）
 └── 测试负责人（SOUL: 测试策略、质量把控、自动化测试）
```

---

## 10. FAQ

### Q: 需要编程基础吗？
不需要写代码，但需要会用命令行（Terminal）。主要工作是**写 Markdown 文件**和**编辑 JSON 配置**。

### Q: 用什么模型好？
- **国内**：Moonshot (kimi-k2.5)、DeepSeek、通义千问
- **海外**：Claude、GPT-4o
- 建议选你手上有 API Key 的，模型能力差异不大，**SOUL 写得好比模型选得好更重要**

### Q: API 费用大概多少？
精简版（4 Agent）日常使用，大约每天 ¥5-15（Moonshot）。完整版（17 Agent）会更高，取决于使用频率。

### Q: 可以用飞书代替 Telegram 吗？
可以。参考模板包里的 `OpenClaw飞书多机器人配置指南.pdf`，每个 Agent 对应一个飞书应用。

### Q: 新业务场景是改现有 Agent 还是新建？
**新建**。每套 SOUL 高度特化，强行复用会导致 AI 用错误的框架分析问题（产生幻觉）。底层共用同一个模型，只是角色定义不同。

### Q: Agent 之间的调用层级有限制吗？
有。`maxRecursion` 控制最大调用深度，默认 3 层（CEO → Lead → 成员）。不建议超过 3 层，链条太长会导致延迟高、容易超时。

### Q: 如何让 Agent "记住"之前的对话？
OpenClaw 自带 session 机制，同一个对话线程内的上下文会保留。跨 session 的长期记忆靠 MEMORY.md。如果需要自动化的记忆管理，可以考虑集成 [SwarmMemory](https://github.com/rebootmindful/SwarmMemory)。

---

## 附录：文件清单

```
模板包/
├── openclaw.json                    # 主配置文件（需替换 API Key 和 Bot Token）
├── 01-create-17-agents.sh           # 一键创建 17 个 Agent
├── 02-generate-daily-plans.sh       # 每日计划自动生成
├── agents-config/                   # 所有 Agent 的 SOUL + MEMORY 配置
│   ├── 01-ceo-SOUL.md ~ 01-ceo-MEMORY.md
│   ├── 02-product-lead-SOUL.md ~ 02-product-lead-MEMORY.md
│   ├── ... (共 25 个文件)
│   └── USER.md                      # 通用用户画像
├── daily-plan-templates/            # 每日计划模板
│   ├── 00-CEO总览.md
│   ├── Squad总览.md
│   └── 个人任务卡.md
├── templates/                       # 通用模板（带占位符）
│   ├── SOUL.md
│   ├── MEMORY.md
│   └── USER.md
└── *.pdf                            # 参考文档
```

---

> **记住**：Agent 的质量 = SOUL 的质量。花 80% 的时间打磨 SOUL.md，比折腾技术配置更有价值。
