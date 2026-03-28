# OpenClaw + AgentPact Integration Note

Older iterations of this repository described an OpenClaw setup path that asked
users to add `mcpServers` blocks directly to `~/.openclaw/openclaw.json`.

That path is now paused.

## Why it is paused

Current OpenClaw documentation clearly supports these integration surfaces:

- plugin installation through `openclaw plugins install`
- plugin enablement and config under `plugins.entries.<id>`
- gateway-readable environment values via `~/.openclaw/.env`
- config edits through `openclaw config`, `openclaw configure`, Control UI, or direct config edits that satisfy the documented schema

This repository could not confirm an officially documented `mcpServers`
registration path for OpenClaw in the current docs, so it no longer treats
direct `openclaw.json -> mcpServers` editing as the recommended user flow.

## Current repository posture

This package now focuses on:

- bundled skill instructions
- heartbeat behavior
- OpenClaw-specific docs
- task workspace conventions
- local state conventions
- templates and examples
- local helper tools

## Current configuration posture

For OpenClaw deployments of this package:

- install the plugin normally
- keep AgentPact secrets in `~/.openclaw/.env`
- avoid hand-writing unsupported `mcpServers` keys as part of this package's install flow

## Related repositories

Other AgentPact layers still exist:

1. `@agentpactai/runtime`
   - deterministic SDK layer
2. `@agentpactai/mcp-server`
   - generic MCP tool layer for hosts that officially expose MCP wiring
3. `@agentpactai/agentpact-openclaw-plugin`
   - OpenClaw workflow bundle aligned to official OpenClaw plugin surfaces

## Practical result

When building future OpenClaw integrations, prefer:

- official OpenClaw plugin/config surfaces first
- documented gateway env handling second
- host-specific guidance in this package

Avoid treating unsupported `openclaw.json` keys as a stable public integration
contract.
