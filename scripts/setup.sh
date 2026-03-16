#!/bin/bash
# Installs the AgentPact MCP server for OpenClaw.
#
# This script installs only @agentpactai/mcp-server. The runtime SDK is pulled
# in automatically as an npm dependency of the MCP package.
#
# Usage:
#   bash setup.sh
#   bash setup.sh --rpc https://your-rpc.example
#   bash setup.sh --rpc https://your-rpc.example --pk abc123...

set -e

MCP_DIR="$HOME/.openclaw/mcp-servers/agentpact"
CONFIG_FILE="$HOME/.openclaw/openclaw.json"
RPC_URL=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --rpc)
      RPC_URL="$2"
      shift 2
      ;;
    --pk)
      AGENT_PK_VALUE="$2"
      shift 2
      ;;
    --help)
      echo "Usage: bash setup.sh [--rpc URL] [--pk PRIVATE_KEY]"
      echo ""
      echo "Options:"
      echo "  --rpc URL         Optional custom RPC URL (default: SDK built-in RPC)"
      echo "  --pk KEY          Agent private key (hex, without 0x prefix)"
      echo ""
      echo "Example:"
      echo "  bash setup.sh --rpc https://sepolia.base.org --pk abc123..."
      exit 0
      ;;
    *)
      echo "Unknown option: $1 (use --help for usage)"
      exit 1
      ;;
  esac
done

echo "Checking prerequisites..."

if ! command -v node >/dev/null 2>&1; then
  echo "Node.js is not installed. Please install Node.js 18+ first."
  echo "https://nodejs.org/"
  exit 1
fi

NODE_VERSION=$(node -v | sed 's/v//' | cut -d. -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
  echo "Node.js version must be >= 18 (current: $(node -v))"
  exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "npm is not installed."
  exit 1
fi

echo "Node.js $(node -v) and npm $(npm -v) found."
echo ""
echo "Installing @agentpactai/mcp-server..."

mkdir -p "$MCP_DIR"
cd "$MCP_DIR"

if [ ! -f "package.json" ]; then
  npm init -y >/dev/null 2>&1
fi

npm install @agentpactai/mcp-server@latest --save 2>&1 | tail -3

MCP_ENTRY="$MCP_DIR/node_modules/@agentpactai/mcp-server/dist/index.js"
if [ ! -f "$MCP_ENTRY" ]; then
  echo "MCP server entry point not found at: $MCP_ENTRY"
  exit 1
fi

echo "MCP server installed at: $MCP_DIR"
echo ""
echo "Configuring OpenClaw..."

mkdir -p "$(dirname "$CONFIG_FILE")"

node -e "
const fs = require('fs');
const path = '$CONFIG_FILE';
const entry = '$MCP_ENTRY';
const rpcUrl = '$RPC_URL';
const pk = '${AGENT_PK_VALUE:-}';

let cfg = {};
try {
  if (fs.existsSync(path)) {
    const raw = fs.readFileSync(path, 'utf8');
    cfg = JSON.parse(raw.replace(/\/\/.*$/gm, '').replace(/\/\*[\s\S]*?\*\//g, ''));
  }
} catch (e) {
  cfg = {};
}

cfg.mcpServers = cfg.mcpServers || {};
cfg.mcpServers.agentpact = {
  command: 'node',
  args: [entry],
  env: Object.assign(
    {
      AGENT_PK: pk || 'REPLACE_WITH_YOUR_PRIVATE_KEY'
    },
    rpcUrl ? { AGENTPACT_RPC_URL: rpcUrl } : {}
  )
};

fs.writeFileSync(path, JSON.stringify(cfg, null, 2));
console.log('MCP server config injected into: ' + path);
"

echo ""
echo "============================================="
echo "  AgentPact MCP setup complete"
echo "============================================="
echo ""
echo "  MCP Server:  $MCP_DIR"
echo "  Config File: $CONFIG_FILE"
if [ -n "$RPC_URL" ]; then
  echo "  RPC URL:     $RPC_URL"
else
  echo "  RPC URL:     default SDK RPC"
fi
echo ""

if [ -z "$AGENT_PK_VALUE" ]; then
  echo "  IMPORTANT: You still need to set your private key."
  echo ""
  echo "  Edit ~/.openclaw/openclaw.json and replace:"
  echo '    "AGENT_PK": "REPLACE_WITH_YOUR_PRIVATE_KEY"'
  echo "  with your actual wallet private key (hex, no 0x prefix)."
  echo ""
else
  echo "  Private key configured."
  echo ""
fi

echo "  Restart OpenClaw to activate the AgentPact tools."
echo "============================================="
