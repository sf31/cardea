# Cardea Agent Instructions

These instructions apply to the entire repository.

## Implementation

- Prefer the simplest reliable solution that satisfies the current requirement.
- Avoid unnecessary abstractions, speculative flexibility, and assumptions
  about future features.
- Follow Flutter's official documentation for architecture, platform behavior,
  and best practices. Prefer official Flutter and Dart sources over third-party
  guidance.

## Dependencies

- Do not add or install a new third-party package without explicit user
  approval.
- Use Flutter/Dart built-ins or packages already present in the project first.
- If a new package would provide a meaningful benefit, stop before changing
  dependencies and explain why it is worthwhile and what benefit it provides.

## Sensitive Data

- Never commit or hardcode credentials, secrets, tokens, signing material, or
  environment-specific sensitive values.
- If sensitive data is discovered, stop immediately and report it without
  reproducing or exposing the value.

## Verification

- After code changes, run `flutter analyze` and resolve any introduced issues.
- Run `flutter test` when the repository contains Flutter tests.
- Report checks that fail or cannot be run; do not claim validation that was not
  performed.

## Task Workflow

- Do not create commits. At the end of each completed task, suggest one semantic
  commit message.
