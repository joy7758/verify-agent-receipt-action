# Verify Agent Execution Receipt

A GitHub Action for validating signed agent execution receipts against evidence bundles.

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

See [examples/workflow-example.md](/Users/zhangbin/GitHub/verify-agent-receipt-action/examples/workflow-example.md) for the same workflow snippet with a short explanation.

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
