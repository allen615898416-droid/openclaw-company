#!/bin/bash
# OpenClaw 多 Agent 协作环境安装脚本

set -e

echo "🦞 OpenClaw 多 Agent 协作环境安装"
echo "=================================="

# 检查 Node.js 版本
echo "✓ 检查 Node.js..."
if ! command -v node &> /dev/null; then
    echo "❌ 未检测到 Node.js，请先安装 Node.js 22.x 或更高版本"
    echo "   访问: https://nodejs.org/"
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 22 ]; then
    echo "❌ Node.js 版本过低 (当前: $(node -v))，需要 v22.x 或更高版本"
    exit 1
fi

echo "✓ Node.js 版本: $(node -v)"

# 安装 OpenClaw
echo ""
echo "✓ 安装 OpenClaw..."
if command -v openclaw &> /dev/null; then
    echo "  OpenClaw 已安装，更新到最新版本..."
    sudo npm update -g openclaw
else
    echo "  首次安装 OpenClaw..."
    sudo npm install -g openclaw
fi

echo "✓ OpenClaw 版本: $(openclaw --version)"

# 创建配置目录
echo ""
echo "✓ 创建配置目录..."
mkdir -p ~/.openclaw
mkdir -p ~/.openclaw/workspace-ceo
mkdir -p ~/.openclaw/workspace-product-lead
mkdir -p ~/.openclaw/workspace-engineering-manager
mkdir -p ~/.openclaw/workspace-growth-lead

# 复制配置文件
echo ""
echo "✓ 复制配置文件..."
if [ -f "openclaw.template.json" ]; then
    cp openclaw.template.json ~/.openclaw/openclaw.json
    echo "  已复制 openclaw.json"
else
    echo "❌ 找不到 openclaw.template.json，请确保在项目根目录执行此脚本"
    exit 1
fi

# 复制 SOUL 文件
if [ -d "souls" ]; then
    cp souls/ceo-SOUL.md ~/.openclaw/workspace-ceo/SOUL.md
    cp souls/product-lead-SOUL.md ~/.openclaw/workspace-product-lead/SOUL.md
    cp souls/engineering-manager-SOUL.md ~/.openclaw/workspace-engineering-manager/SOUL.md
    cp souls/growth-lead-SOUL.md ~/.openclaw/workspace-growth-lead/SOUL.md
    echo "  已复制所有 SOUL 文件"
else
    echo "❌ 找不到 souls 目录"
    exit 1
fi

echo ""
echo "=================================="
echo "✅ 安装完成！"
echo ""
echo "📝 接下来的步骤："
echo ""
echo "1. 编辑配置文件:"
echo "   open ~/.openclaw/openclaw.json"
echo ""
echo "   需要替换以下内容:"
echo "   - YOUR_MOONSHOT_API_KEY_HERE → 你的 Moonshot API Key"
echo "   - YOUR_*_BOT_TOKEN → 四个 Telegram Bot Token"
echo "   - YOUR_GATEWAY_TOKEN_HERE → 随机生成的网关令牌"
echo ""
echo "2. 获取 Telegram Bot Token:"
echo "   - 在 Telegram 搜索 @BotFather"
echo "   - 发送 /newbot 创建 4 个 bot (CEO、商务、运营、产研)"
echo "   - 复制每个 bot 的 token 填入配置文件"
echo ""
echo "3. 启动 OpenClaw 网关:"
echo "   openclaw gateway start"
echo ""
echo "4. 打开 Dashboard:"
echo "   浏览器访问 http://127.0.0.1:18789"
echo ""
echo "5. 配对 Telegram Bot:"
echo "   - 在 Telegram 分别找到你创建的 4 个 bot"
echo "   - 发送 /start 完成配对"
echo ""
echo "详细教程请参考: OpenClaw多Agent协作方法论.md"
echo ""
