# Workflow Example

Use this action in CI after your workflow has produced:

- `execution_receipt.json`
- `evidence_bundle.json`
- a public key PEM file

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

When `fail-on-invalid` is `true`, the step fails the job on any non-`valid` verdict.
