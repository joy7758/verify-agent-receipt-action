# Support

This GitHub Action is maintained as an open-source CI wrapper for verifying signed agent execution receipts against evidence bundles.

## Community support

Use GitHub Issues for:

- reproducible bugs
- GitHub Action configuration problems
- validator CLI failures inside CI
- documentation problems
- minimal workflow examples that do not work as documented

For design discussions, use GitHub Issues unless GitHub Discussions are enabled later.

## Before opening an issue

Please include:

- workflow YAML snippet
- runner operating system
- action version
- package version input if customized
- exact error message
- whether `fail-on-invalid` is enabled

Do not post secrets, private keys, API tokens, confidential evidence bundles, or production receipts in public issues.

## Scope of unpaid support

There is no guaranteed response time for unpaid support.

This action validates signed execution evidence. It does not certify legal compliance, prove semantic correctness of tool outputs, or replace sandboxing, IAM, access control, monitoring, or human approval.

## Commercial integration

For private CI integration, custom receipt validation workflows, policy adaptation, or agent workflow evidence gates, see:

- COMMERCIAL_SUPPORT.md

Contact:

- Public technical questions: GitHub Issues
- Commercial or research collaboration: joy7759@gmail.com
