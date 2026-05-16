# Branch Protection

Recommended protection for `main`:

- Require pull requests before merging.
- Require the `iOS CI / Build and test` check to pass.
- Require branches to be up to date before merging.
- Do not require UI tests until the M4 CI hardening ticket makes them stable.

This project is maintained by a solo contributor, so the rule is intentionally lightweight: every meaningful change should go through a PR and CI should be green before merge.
