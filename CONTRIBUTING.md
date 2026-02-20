# Contributing

Thanks for helping improve this repository.

## Goal

Every change should make the repo more useful for learning and for real-world implementation.

## Before Opening a PR

1. Pick an existing example to improve or add a new one from `examples/_template`.
2. Ensure the example includes the required files and README sections from `docs/quality-bar.md`.
3. Run local checks:

```bash
scripts/validate_examples.sh
```

## Design Principles

- Prefer practical patterns over generic tutorials.
- Explain tradeoffs (cost, security, operations), not only resource syntax.
- Include at least one operational safeguard.
- Add or update the corresponding incident runbook in `docs/incidents/`.
- Keep examples composable and easy to adapt.

## Pull Request Expectations

PR description should include:
- what problem this solves
- why this approach was chosen
- cost and risk implications
- validation evidence (commands run, what worked)

Use the PR template in `.github/pull_request_template.md`.
