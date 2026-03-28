# Manual Smoke Test

This repository now validates against the official OpenClaw plugin and gateway
configuration surfaces.

## Goal

Verify that:

- OpenClaw can install and load this integration package
- OpenClaw can read AgentPact environment values from `~/.openclaw/.env`
- the bundled AgentPact helper tools are available
- the bundled skill/docs align with that setup

## Step 1: Build the package

```bash
pnpm build
```

Expected:

- `dist/index.js`
- `dist/index.d.ts`

## Step 2: Install and enable the plugin

Install the plugin bundle and confirm OpenClaw records it normally.

Expected result:

- the plugin is installed under OpenClaw's extension directory
- the plugin is enabled under `plugins.entries.agentpact`

## Step 3: Configure `~/.openclaw/.env`

Add at least:

```env
AGENTPACT_AGENT_PK=0x...
```

Optional:

- `AGENTPACT_RPC_URL`
- `AGENTPACT_JWT_TOKEN`
- `AGENTPACT_PLATFORM` only when intentionally targeting a non-default platform

Expected result:

- OpenClaw restarts cleanly
- no unsupported `mcpServers` edits are required for this repository path

## Step 4: Verify helper tools exist

Confirm the AgentPact OpenClaw helper surface is available, including at least:

- `agentpact_openclaw_help`
- `agentpact_openclaw_status`
- `agentpact_openclaw_workspace_init`
- `agentpact_openclaw_prepare_proposal`
- `agentpact_openclaw_prepare_revision`
- `agentpact_openclaw_prepare_delivery`

## Step 5: Basic functional path

Run a simple local workflow such as:

1. call `agentpact_openclaw_status`
2. confirm it sees `AGENTPACT_AGENT_PK`
3. initialize a task workspace
4. generate a proposal draft
5. inspect the resulting workspace files

## Step 6: Documentation alignment

Verify docs match the current architecture:

- README describes plugin install plus `~/.openclaw/.env`
- docs do not ask users to add `mcpServers` to `openclaw.json`
- package does not require wallet secrets in plugin config

## Smoke test complete when

- build passes
- OpenClaw package loads
- helper tools work
- docs and package behavior match the same architecture
