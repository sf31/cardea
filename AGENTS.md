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
- Do not modify `pubspec.yaml` or `pubspec.lock` without explicit user
  approval, including when removing, upgrading, or resolving dependencies.
- Use Flutter/Dart built-ins or packages already present in the project first.
- If a new package would provide a meaningful benefit, stop before changing
  dependencies and explain why it is worthwhile and what benefit it provides.

## Git

- Read-only Git inspection is allowed, such as `git status`, `git diff`, `git
  log`, and `git show`.
- Do not run Git commands that write or alter repository state. The user alone
  performs commits, merges, rebases, resets, reverts, branch or tag changes,
  staging, pushes, pulls, remote changes, and any other destructive or
  state-changing Git operation.

## Delivery Tooling

- Do not assume a Git provider, CI/CD service, or other third-party delivery
  tool is available.
- Keep the codebase and its documentation agnostic to hosting, CI/CD, pipeline,
  testing, and release providers. The user owns the choice and operation of
  those tools and final release processes.

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

- Before each implementation task, explain the proposed scope, approach, and
  validation, then wait for the user's explicit agreement.
- Do not modify application code for that task before agreement is given.
- Do not create commits. At the end of each completed task, suggest one semantic
  commit message.
