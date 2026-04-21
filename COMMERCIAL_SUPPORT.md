# Commercial Support

Commercial support is available for organizations that want to use receipt verification as a CI/CD gate for agent workflows.

## Available support areas

1. GitHub Action integration into existing CI pipelines
2. Custom receipt verification workflows
3. Private validator rule adaptation
4. Evidence bundle structure review
5. Agent workflow audit-gate design
6. Integration with the `verifiable-tool-invocation-flow` package
7. FDO/Data-Space-like evidence mapping
8. Research collaboration and artifact preparation

## Typical integration work

Examples include:

- adding receipt verification to pull requests or releases
- configuring `fail-on-invalid` behavior for different branches
- adapting validation reports for internal audit workflows
- integrating receipt verification into agent deployment pipelines
- designing evidence-gate patterns for sensitive tool calls

## Boundaries

Commercial support does not change the open-source project's security guarantees.

This action validates signed execution evidence. It does not prove semantic correctness of tool outputs. It does not prove that the policy itself is correct. It does not protect against a compromised signer. It does not replace sandboxing, IAM, access control, monitoring, human approval, or legal compliance review.

## Contact

For commercial or research collaboration:

- Email: joy7759@gmail.com

For public technical questions:

- Use GitHub Issues
