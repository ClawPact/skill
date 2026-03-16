param(
    [string]$Rpc = "",
    [string]$Pk = ""
)

$ErrorActionPreference = "Stop"

$mcpDir = Join-Path $HOME ".openclaw\mcp-servers\agentpact"
$configFile = Join-Path $HOME ".openclaw\openclaw.json"
$mcpEntry = Join-Path $mcpDir "node_modules\@agentpactai\mcp-server\dist\index.js"

Write-Host "Checking prerequisites..."

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    throw "Node.js is not installed. Install Node.js 18+ first."
}

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    throw "npm is not installed."
}

$nodeMajor = [int]((node -v).TrimStart("v").Split(".")[0])
if ($nodeMajor -lt 18) {
    throw "Node.js 18+ is required. Current version: $(node -v)"
}

Write-Host "Installing @agentpactai/mcp-server..."

New-Item -ItemType Directory -Force -Path $mcpDir | Out-Null
Push-Location $mcpDir

try {
    if (-not (Test-Path "package.json")) {
        npm init -y | Out-Null
    }

    npm install @agentpactai/mcp-server@latest --save | Out-Host

    if (-not (Test-Path $mcpEntry)) {
        throw "MCP server entry point not found at $mcpEntry"
    }
}
finally {
    Pop-Location
}

Write-Host "Configuring OpenClaw..."

New-Item -ItemType Directory -Force -Path (Split-Path $configFile -Parent) | Out-Null

$cfg = @{}
if (Test-Path $configFile) {
    try {
        $raw = Get-Content $configFile -Raw
        $raw = [regex]::Replace($raw, '//.*$', '', 'Multiline')
        $raw = [regex]::Replace($raw, '/\*[\s\S]*?\*/', '')
        if ($raw.Trim()) {
            $cfg = $raw | ConvertFrom-Json -AsHashtable
        }
    }
    catch {
        $cfg = @{}
    }
}

if (-not $cfg.ContainsKey("mcpServers")) {
    $cfg["mcpServers"] = @{}
}

$cfg["mcpServers"]["agentpact"] = @{
    command = "node"
    args = @($mcpEntry)
    env = @{
        AGENT_PK = $(if ($Pk) { $Pk } else { "REPLACE_WITH_YOUR_PRIVATE_KEY" })
    }
}

if ($Rpc) {
    $cfg["mcpServers"]["agentpact"]["env"]["AGENTPACT_RPC_URL"] = $Rpc
}

$cfg | ConvertTo-Json -Depth 10 | Set-Content -Path $configFile

Write-Host ""
Write-Host "AgentPact MCP setup complete."
Write-Host "Config file: $configFile"
if ($Rpc) {
    Write-Host "RPC URL:     $Rpc"
} else {
    Write-Host "RPC URL:     default SDK RPC"
}

if (-not $Pk) {
    Write-Host ""
    Write-Host "Set AGENT_PK in the OpenClaw config before starting the agent."
}

Write-Host "Restart OpenClaw to load the AgentPact MCP server."
