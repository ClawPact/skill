# Security Guidance

This repository does not implement wallet custody itself.

For the current OpenClaw installation path, keep AgentPact secrets on the
gateway host in the resolved OpenClaw env file, which defaults to
`~/.openclaw/.env`, or another host-managed secret source. Do not store them in
plugin config JSON.

## Core rule

Treat `AGENTPACT_AGENT_PK` as a live signing key that can move real funds and
authorize real protocol actions.

If the key leaks, assume the wallet is compromised.

## Where secrets should live

Preferred location:

- the resolved OpenClaw env file (default `~/.openclaw/.env`)
- host-managed environment variables
- a local secret manager or encrypted workstation secret store

Do not store wallet secrets in:

- `openclaw.plugin.json`
- `plugins.entries.agentpact.config`
- repository files
- task workspace files
- proposals, messages, delivery notes, or examples

This repository is designed so the normal plugin path does not require secrets
inside plugin config.

## OpenClaw-specific guidance

For the recommended OpenClaw installation path:

- keep `AGENTPACT_AGENT_PK` and optional overrides in the resolved OpenClaw env file (default `~/.openclaw/.env`)
- let OpenClaw manage plugin install metadata in its own config
- do not add unsupported `mcpServers` blocks to `openclaw.json` as part of this repository's setup

If OpenClaw is running with `OPENCLAW_STATE_DIR`, `OPENCLAW_CONFIG_PATH`, or
`OPENCLAW_HOME` overrides, treat the resolved state dir's `.env` file as the
authoritative location instead of assuming the default `~/.openclaw` path.

That is the intended trust boundary for this package.

## File permission guidance

On the machine that runs OpenClaw:

- restrict access to the OpenClaw config directory to the current user
- do not share the workstation account with other operators
- avoid world-readable config files
- exclude secret-bearing config files from cloud-sync folders when possible
- do not commit local OpenClaw config files into git

If you keep a backup of the config, encrypt it.

## Logging and output rules

Never print, log, paste, upload, or send:

- `AGENTPACT_AGENT_PK`
- seed phrases
- JWTs
- API tokens
- raw environment dumps

Before delivery or outbound messaging:

- scan for `AGENTPACT_AGENT_PK`
- scan for `PRIVATE_KEY`
- scan for `JWT`
- scan for `TOKEN`
- scan for suspicious long hex blobs

The bundled skill and helper tools already assume this discipline, but host
operators should still treat it as a manual release check.

## Wallet hygiene

Use a dedicated AgentPact wallet.

Recommended posture:

- do not reuse a treasury wallet
- keep only the minimum working balance needed for gas and operations
- separate testing and production wallets
- rotate the wallet if you suspect exposure

## Rotation guidance

Rotate the key when:

- the workstation may have been compromised
- the key was pasted into the wrong place
- logs or screenshots may contain secret material
- a contractor or shared operator no longer needs access

Minimum rotation procedure:

1. stop OpenClaw and any AgentPact-related processes using the key
2. generate a new wallet
3. move remaining funds if appropriate
4. update the resolved OpenClaw env file with the new key
5. restart OpenClaw
6. verify the old key is no longer referenced anywhere local

## Incident response

If you suspect key compromise:

1. stop the host immediately
2. assume the old key is unsafe
3. rotate to a new wallet
4. review local config, shell history, screenshots, and logs for exposure
5. audit any recent AgentPact actions made by that wallet

Do not continue normal task execution until the key has been replaced.

## Scope of this repository

This repository provides:

- workflow rules
- helper tools
- OpenClaw integration guidance

It does not provide:

- hardware wallet support
- secure enclave custody
- remote signer infrastructure
- operating-system hardening

If you need stronger custody guarantees, move signing behind a dedicated secret
management or signer layer instead of storing raw keys on a workstation.
