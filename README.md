> **Moved:** this repository has been merged into [joy7758/agent-receipt-validator-mcp](https://github.com/joy7758/agent-receipt-validator-mcp/tree/main/verify-agent-receipt-action) with full history. This repo is archived and read-only.

# Verify Agent Execution Receipt

[![GitHub Marketplace](https://img.shields.io/badge/GitHub%20Marketplace-Verify%20Agent%20Execution%20Receipt-blue?logo=github)](https://github.com/marketplace/actions/verify-agent-execution-receipt)
[![GitHub release](https://img.shields.io/github/v/release/joy7758/verify-agent-receipt-action?sort=semver)](https://github.com/joy7758/verify-agent-receipt-action/releases/tag/v0.1.0)
[![Core package](https://img.shields.io/pypi/v/verifiable-tool-invocation-flow?label=core%20package)](https://pypi.org/project/verifiable-tool-invocation-flow/0.1.1/)
[![Tag: security](https://img.shields.io/badge/tag-security-blue)](https://github.com/marketplace?type=actions&category=security)
[![Tag: continuous-integration](https://img.shields.io/badge/tag-continuous--integration-2ea44f)](https://github.com/marketplace?type=actions&category=continuous-integration)

A GitHub Action for validating signed agent execution receipts against evidence bundles.

## Live demo

You can try the receipt validator visually in the Hugging Face Space:

- [Agent Receipt Validator Space](https://huggingface.co/spaces/joy7759/agent-receipt-validator)

The demo is for inspection and experimentation only. Do not upload private keys, production receipts, confidential evidence bundles, API tokens, or sensitive data.

## Related public assets

The receipt validation toolkit is also available through:

- Core CrewAI Flow template: https://github.com/joy7758/verifiable-tool-invocation-flow
- Core PyPI package: https://pypi.org/project/verifiable-tool-invocation-flow/0.1.1/
- Hugging Face validator demo: https://huggingface.co/spaces/joy7759/agent-receipt-validator
- MCP server package: https://pypi.org/project/agent-receipt-validator-mcp/0.1.1/
- MCP server repository: https://github.com/joy7758/agent-receipt-validator-mcp

Use the GitHub Action for CI/CD receipt verification. Use the MCP server when an MCP-compatible client needs to call receipt validation tools locally.

The MCP server and this Action validate signed execution evidence. They do not prove semantic correctness of tool outputs, certify legal compliance, or replace sandboxing, IAM, access control, monitoring, or human approval.

## What this action does

This action installs [`verifiable-tool-invocation-flow`](https://pypi.org/project/verifiable-tool-invocation-flow/0.1.1/) from PyPI and runs its independent validator CLI against:

- an `execution_receipt.json`
- an `evidence_bundle.json`
- a public key PEM

It returns a `verdict` output and writes a verification report JSON file.

## When to use it

Use this action when your CI pipeline needs to:

- validate receipt and evidence artifacts produced by an agent workflow
- fail a pull request or release job when execution evidence is invalid
- keep receipt verification separate from the system that originally produced the artifacts

## Inputs

| Input | Required | Default | Description |
| --- | --- | --- | --- |
| `receipt` | Yes |  | Path to `execution_receipt.json` |
| `evidence` | Yes |  | Path to `evidence_bundle.json` |
| `public-key` | Yes |  | Path to the public key PEM used for verification |
| `audience` | No | `demo-validator` | Expected receipt audience |
| `output` | No | `verification_report.json` | Output path for the generated verification report |
| `package-version` | No | `0.1.1` | `verifiable-tool-invocation-flow` version to install |
| `python-version` | No | `3.13` | Python version used during validation |
| `fail-on-invalid` | No | `true` | Whether the action should fail when verdict is not `valid` |

## Outputs

| Output | Description |
| --- | --- |
| `verdict` | Validation verdict: `valid` or `invalid` |
| `report-path` | Path to the generated verification report JSON |

## Basic usage

```yaml
name: Verify Agent Receipt

on:
  pull_request:
  push:

jobs:
  verify-receipt:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6

      - name: Verify execution receipt
        uses: joy7758/verify-agent-receipt-action@v0.1.0
        with:
          receipt: outputs/execution_receipt.json
          evidence: outputs/evidence_bundle.json
          public-key: outputs/demo_public_key.pem
          audience: demo-validator
          output: outputs/verification_report.ci.json
          fail-on-invalid: "true"
```

## fail-on-invalid behavior

- When `fail-on-invalid` is `true`, the action exits nonzero if the report verdict is not `valid`.
- When `fail-on-invalid` is `false`, the action still emits `verdict=invalid`, but the step exits `0`.
- If the validator crashes and no report is produced, the action exits nonzero regardless of `fail-on-invalid`.

## Example workflow snippet

See [examples/workflow-example.md](examples/workflow-example.md) for the same workflow snippet with a short explanation.

## Security boundaries

This action validates signed execution receipts against evidence bundles.
It does not prove semantic correctness of the tool output.
It does not prove that the policy itself is correct.
It does not protect against a compromised signer.
It does not replace sandboxing, IAM, access control, monitoring, or human approval.

The action is a CI wrapper around the core package:

- PyPI: [verifiable-tool-invocation-flow](https://pypi.org/project/verifiable-tool-invocation-flow/0.1.1/)
- Source: [joy7758/verifiable-tool-invocation-flow](https://github.com/joy7758/verifiable-tool-invocation-flow)

## Repository scope

This repository is intentionally narrow. It contains:

- the root `action.yml`
- small shell and Python helper scripts
- documentation and examples
- local tests for the action wrapper

It does not duplicate the receipt builder, signer, policy engine, or validator implementation from the core package.

## Support and commercial integration

This action is open-source infrastructure for CI-based verification of signed agent execution receipts.

For public technical questions, use GitHub Issues. For private CI integration, custom receipt verification workflows, policy adaptation, or agent workflow evidence gates, see:

- [SUPPORT.md](SUPPORT.md)
- [COMMERCIAL_SUPPORT.md](COMMERCIAL_SUPPORT.md)

GitHub Sponsors is not currently enabled for this account. Funding links may be added later once a sponsorship channel is active.
