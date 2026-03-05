# OpenClaw 多 Agent 协作环境

> 基于 OpenClaw 的 4 人 AI 团队协作框架，适用于游戏渠道发行、内容运营等业务场景

[![OpenClaw](https://img.shields.io/badge/OpenClaw-2026.3.2+-blue.svg)](https://openclaw.ai/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](./LICENSE)

## 项目简介

这是一套完整的多 Agent 协作配置，由 4 个 AI Agent 组成一个完整的业务团队：

| 角色 | Agent ID | 职责 |
|------|----------|------|
| 👑 CEO | `ceo` | 业务总负责人，战略决策和团队协调 |
| 🤝 商务负责人 | `product-lead` | 面向渠道，拿资源 |
| 📊 运营负责人 | `growth-lead` | 面向游戏，做增长 |
| 🔧 产研负责人 | `engineering-manager` | 赋能商务和运营，提供策略/工程/项管支撑 |

### 特点

- ✅ **开箱即用** — 完整的配置文件和 SOUL 定义
- ✅ **真实协作** — CEO 可通过 `sessions_spawn` 调度其他 Agent
- ✅ **角色专业** — 每个 Agent 有清晰的职责边界和专业知识
- ✅ **可定制** — SOUL 文件可根据实际业务调整
- ✅ **文档齐全** — 附带完整的使用教程和最佳实践

## 快速开始

### 环境要求

- Node.js >= 22.x
- npm >= 10.x
- macOS / Linux / Windows

### 一键安装

```bash
# 克隆项目
git clone https://github.com/YOUR_GITHUB_USERNAME/openclaw-multi-agent.git
cd openclaw-multi-agent

# 执行安装脚本
bash install.sh
```

### 手动安装步骤

<details>
<summary>点击展开详细步骤</summary>

#### 1. 安装 OpenClaw

```bash
sudo npm install -g openclaw
```

#### 2. 创建配置目录

```bash
mkdir -p ~/.openclaw
mkdir -p ~/.openclaw/workspace-ceo
mkdir -p ~/.openclaw/workspace-product-lead
mkdir -p ~/.openclaw/workspace-engineering-manager
mkdir -p ~/.openclaw/workspace-growth-lead
```

#### 3. 复制配置文件

```bash
cp openclaw.template.json ~/.openclaw/openclaw.json
cp souls/ceo-SOUL.md ~/.openclaw/workspace-ceo/SOUL.md
cp souls/product-lead-SOUL.md ~/.openclaw/workspace-product-lead/SOUL.md
cp souls/engineering-manager-SOUL.md ~/.openclaw/workspace-engineering-manager/SOUL.md
cp souls/growth-lead-SOUL.md ~/.openclaw/workspace-growth-lead/SOUL.md
```

#### 4. 编辑配置文件

```bash
open ~/.openclaw/openclaw.json
```

需要替换以下占位符：

- `YOUR_MOONSHOT_API_KEY_HERE` → 你的 Moonshot API Key
- `YOUR_CEO_BOT_TOKEN` → CEO Bot 的 Telegram Token
- `YOUR_PRODUCT_LEAD_BOT_TOKEN` → 商务负责人 Bot Token
- `YOUR_ENGINEERING_MANAGER_BOT_TOKEN` → 产研负责人 Bot Token
- `YOUR_GROWTH_LEAD_BOT_TOKEN` → 运营负责人 Bot Token
- `YOUR_GATEWAY_TOKEN_HERE` → 随机生成的网关令牌

</details>

### 获取必要的 Token

#### 1. Moonshot API Key

访问 [Moonshot AI 开放平台](https://platform.moonshot.cn/)，注册并获取 API Key。

#### 2. Telegram Bot Token

1. 在 Telegram 搜索 `@BotFather`
2. 发送 `/newbot` 创建机器人
3. 按提示输入机器人名称和用户名
4. 重复 4 次，为每个 Agent 创建一个 Bot
5. 复制每个 Bot 的 Token 填入配置文件

**建议命名**：
- CEO Bot: `YourName_CEO_Bot`
- 商务 Bot: `YourName_Product_Bot`
- 运营 Bot: `YourName_Growth_Bot`
- 产研 Bot: `YourName_Engineering_Bot`

#### 3. Gateway Token

```bash
# 生成随机 token
openssl rand -hex 24
```

### 启动服务

```bash
# 启动 OpenClaw 网关
openclaw gateway start

# 验证服务状态
openclaw gateway status
```

### 访问 Dashboard

浏览器打开 http://127.0.0.1:18789

首次访问需要输入 Gateway Token（配置文件中的 `gateway.auth.token`）

### 配对 Telegram Bot

在 Telegram 中找到你创建的 4 个 Bot，分别发送 `/start` 完成配对。配对成功后就可以开始对话了。

## 使用方式

### 与 CEO 对话

直接在 Telegram 找到 CEO Bot，发送消息：

```
帮我制定 Q2 的渠道拓展计划
```

CEO 会分析需求，调用商务、运营、产研三条线协同完成，最后汇总输出。

### 直接与特定负责人对话

也可以直接找商务/运营/产研 Bot 对话，咨询特定领域的问题。

### Agent 间协作

CEO 可以通过 `sessions_spawn` 工具调用其他 Agent：

```
我需要商务负责人制定华为渠道的合作方案
```

CEO 会自动调用商务负责人（`product-lead`），完成后汇总结果。

## 项目结构

```
.
├── README.md                    # 本文档
├── OpenClaw多Agent协作方法论.md  # 完整教程
├── install.sh                   # 一键安装脚本
├── openclaw.template.json       # 配置文件模板
└── souls/                       # Agent SOUL 定义
    ├── ceo-SOUL.md
    ├── product-lead-SOUL.md
    ├── engineering-manager-SOUL.md
    └── growth-lead-SOUL.md
```

## 完整教程

详细的使用教程、架构设计、最佳实践请参考：

📖 [OpenClaw多Agent协作方法论.md](./OpenClaw多Agent协作方法论.md)

内容包括：
- 核心理念
- 架构设计
- 从零搭建指南
- SOUL/MEMORY 编写技巧
- 常见问题排查
- 业务场景迁移指南

## 定制化

### 修改 Agent 角色

编辑 `souls/` 目录下的 `.md` 文件，调整：

- 角色定位
- 职责范围
- 性格特点
- 工作原则
- 协作关系

### 调整团队规模

在 `openclaw.template.json` 中修改 `agents.list`，增加或删除 Agent。

### 更换 AI 模型

支持 OpenAI、Claude、Gemini、国产模型等，修改 `models.providers` 配置即可。

## 常见问题

### 1. 消息太长导致 Telegram 发送失败

在 `openclaw.json` 中调整：

```json
"channels": {
  "telegram": {
    "textChunkLimit": 3000,
    "chunkMode": "newline"
  }
}
```

### 2. Agent 无法相互调用

检查 `tools.agentToAgent` 配置：

```json
"tools": {
  "agentToAgent": {
    "enabled": true,
    "allow": ["ceo", "product-lead", "engineering-manager", "growth-lead"]
  }
}
```

### 3. API 速率限制

调整并发数：

```json
"agents": {
  "defaults": {
    "maxConcurrent": 2,
    "subagents": {
      "maxConcurrent": 3
    }
  }
}
```

## 更新日志

### v1.0.0 (2026-03-05)

- ✨ 初始版本发布
- ✅ 4 人 AI 团队配置
- 📖 完整教程文档
- 🛠️ 一键安装脚本

## 致谢

- [OpenClaw](https://openclaw.ai/) - 强大的多 Agent 协作框架
- [Moonshot AI](https://www.moonshot.cn/) - 提供高质量的 Kimi 模型
- [龙虾营"一人公司"方法论](https://example.com) - 架构设计灵感来源

## 许可证

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request！

## 作者

Allen - 腾讯游戏渠道业务部

---

**如果这个项目对你有帮助，欢迎 Star ⭐️**
