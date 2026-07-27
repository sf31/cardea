# Code Review and Cleanup Plan

Date: 2026-07-06

Last review pass: 2026-07-27

## Goal

Get Cardea into a clean, reliable, and easy-to-change state with the minimum
maintenance work needed before adding new features.

Work through the plan in order. Complete and validate one task before starting
the next. After each task, update its status and prepare a semantic commit
message without creating the commit automatically.

Status values: `planned`, `in progress`, `blocked`, `completed`, `skipped`.

## Completed stabilization work

1. [x] **Preserve barcode payloads and formats** — `completed`
   - Store the scanner's raw payload and detected format.
   - Render saved cards using their persisted format.
   - Keep legacy cards compatible by falling back to Code 128.
   - Added the SQLite v1-to-v2 migration for `barcode_format`.

2. [x] **Define versioned selective backups** — `completed`
   - Treat import/export as a selective local backup and transfer feature.
   - Record the backup format version and explicitly included sections.
   - Replace only the sections selected for import.
   - Keep existing unversioned exports readable.

3. [x] **Make backup restore atomic** — `completed`
   - Parse the complete backup before modifying the database.
   - Restore all selected sections in one SQLite transaction.
   - Reload viewmodels only after the transaction commits.

4. [x] **Keep filtered card results synchronized** — `completed`
   - Derive filtered results from the source card list and current query.
   - Keep search results correct after add, edit, delete, sorting, usage
     updates, and imports.

## Prioritized cleanup plan

5. [ ] **Safeguard the current branch** — `planned`
   - Push or otherwise back up the current local work before further changes.
   - Audit note: on 2026-07-27, local `master` was clean but 21 commits ahead of
     the only branch on `origin`.

6. [ ] **Fix and modernize Android builds** — `planned`
   - Make debug builds independent of private release-signing files.
   - Configure release signing only when all required properties are present.
   - Upgrade Gradle and the Android Gradle Plugin to versions supported by the
     current Flutter stable toolchain.
   - Remove misleading template comments and document the supported debug and
     release build workflows in the README.
   - Validate a debug build from a clean checkout and the intended release
     signing behavior.

7. [ ] **Stabilize asynchronous UI and persistence state** — `planned`
   - Add `mounted` guards before UI updates or context use after async gaps.
   - Remove artificial delays that do not serve product behavior.
   - Expose initial loading and load-failure states instead of showing an
     uninitialized list as empty.
   - Prevent export and mutations until their required initial loads complete.
   - Disable save, delete, import, export, and shopping-item submission actions
     while the corresponding operation is running.
   - Confirm loyalty-card deletion and prevent rapid repeated submissions.
   - Replace hardcoded persistence messages with localized UI errors.

8. [ ] **Add focused tests and basic CI** — `planned`
   - Keep the existing backup, barcode, rendering, and filtering tests.
   - Add repository and viewmodel success/failure tests.
   - Add backup validation and transactional rollback coverage.
   - Add database creation and v1-to-v2 migration coverage.
   - Add a small app/provider smoke test.
   - Add a minimal CI workflow that runs analysis and tests; include a clean
     Android debug build if its runtime is reasonable.

9. [ ] **Add shopping-list cleanup** — `planned`
   - Give users a simple way to permanently remove completed items.
   - Prefer one confirmed **Clear completed** action unless individual deletion
     is also needed for the intended workflow.
   - Reuse the existing repository/viewmodel deletion path where practical.

10. [ ] **Make loyalty-card text readable on every color** — `planned`
    - Choose light or dark foreground text from the selected background color,
      or constrain the palette to accessible combinations.
    - Check the result in both light and dark themes.

11. [ ] **Remove dead code, dependencies, and stale documentation** — `planned`
    - Remove the unused `SettingsViewModel` and its provider registration.
    - Remove unused helpers, commented-out code, and stale review notes.
    - Verify and remove unused direct dependencies such as `camera`, `path`,
      `path_provider`, and `cupertino_icons`.
    - Reassess the iOS microphone usage description after dependency cleanup.
    - Keep the README, database schema, and this plan consistent with the
      implemented behavior.

12. [ ] **Run final release validation** — `planned`
    - Run `flutter analyze` and the complete Flutter test suite.
    - Validate clean-checkout Android debug and release build behavior.
    - Smoke-test physical camera scanning and manual card entry.
    - Smoke-test an on-device SQLite v1-to-v2 upgrade.
    - Smoke-test successful import and transaction rollback on failure.
    - Validate iOS if it remains a supported release target.

## Deferred until there is a product need

- Displaying app version/build information in Settings. It is useful for
  support, but does not justify a new dependency during cleanup.
- Preserving tab-local input, expansion, and scroll state. Revisit only if the
  current behavior causes user friction.
- Larger import/export changes. The current scope remains a selective local
  backup and transfer feature, not a full synchronization product.

## Latest audit results

Audit run on 2026-07-27 with Flutter 3.44.8 and Dart 3.12.2:

- `flutter analyze`: passed with no issues.
- `flutter test`: all 9 tests passed.
- Clean-checkout Android debug build: failed because release-signing
  properties were required during Gradle configuration.
- The same build warned that Gradle 8.10.2 and Android Gradle Plugin 8.7.0
  should be upgraded for continued Flutter support.
- Public GitHub issues: none open.
- Public GitHub pull requests: none open.
