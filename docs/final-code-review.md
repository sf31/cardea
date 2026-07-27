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

5. [x] **Safeguard the current branch** — `completed`
   - Repository backup and pushing are owner-managed and will be handled
     separately from this cleanup plan.

6. [x] **Fix and modernize Android builds** — `completed`
   - Make debug builds independent of private release-signing files.
   - Configure release signing only when all required properties are present.
   - Upgrade Gradle and the Android Gradle Plugin to versions supported by the
     current Flutter stable toolchain.
   - Remove misleading template comments and document the supported debug and
     release build workflows in the README.
   - Validate a debug build from a clean checkout and the intended release
     signing behavior.
   - Implemented conditional release signing with the standard debug-key
     fallback for local builds, Gradle 8.14, and Android Gradle Plugin 8.11.1.
   - Validation: analysis and all 9 tests passed; clean-checkout debug and
     release-mode APKs built; the private release configuration produced a
     signed APK verified with Android's `apksigner`.

7. [x] **Stabilize asynchronous UI and persistence state** — `completed`
   - Add `mounted` guards before UI updates or context use after async gaps.
   - Remove artificial delays that do not serve product behavior.
   - Expose initial loading and load-failure states instead of showing an
     uninitialized list as empty.
   - Prevent export and mutations until their required initial loads complete.
   - Disable save, delete, import, export, and shopping-item submission actions
     while the corresponding operation is running.
   - Confirm loyalty-card deletion and prevent rapid repeated submissions.
   - Replace hardcoded persistence messages with localized UI errors.
   - Implemented explicit loading, ready, and failure states in both list
     viewmodels, with retry UI and readiness-gated mutations and data transfer.
   - Added in-flight action protection, loyalty-card deletion confirmation,
     async lifecycle guards, and localized persistence errors in English and
     Italian; removed the artificial import/export delays.
   - Validation: localization generation and formatting completed; analysis,
     all 9 tests, and whitespace checks passed.

8. [ ] **Add focused tests** — `planned`
   - Keep the existing backup, barcode, rendering, and filtering tests.
   - Add repository and viewmodel success/failure tests.
   - Add backup validation and transactional rollback coverage.
   - Add database creation and v1-to-v2 migration coverage.
   - Add a small app/provider smoke test.
   - Completed in this pass: malformed backup records now produce
     `FormatException`, with coverage for invalid section metadata and data;
     local analysis and test coverage was expanded.
   - Repository/database integration and provider smoke coverage remain for a
     follow-up because they require a platform-backed SQLite test setup.
   - CI pipelines are intentionally out of scope for this repository.

9. [x] **Add shopping-list cleanup** — `completed`
   - Give users a simple way to permanently remove completed items.
   - Prefer one confirmed **Clear completed** action unless individual deletion
     is also needed for the intended workflow.
   - Reuse the existing repository/viewmodel deletion path where practical.
   - Added a localized confirmation dialog and a busy state that prevents
     overlapping clears or item toggles while completed items are removed.
   - Validation: localization generation, formatting, analysis, all 11 tests,
     and whitespace checks passed.

10. [x] **Make loyalty-card text readable on every color** — `completed`
   - Choose light or dark foreground text from the selected background color,
     or constrain the palette to accessible combinations.
   - Check the result in both light and dark themes.
   - Card labels now choose black or white text from the background luminance,
     with coverage for light and dark card colors.
   - Validation: formatting, analysis, all 12 tests, and whitespace checks
     passed.

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
- Clean-checkout Android debug and release-mode APK builds: passed without
  private signing properties.
- Private release-signing APK build and Android signature verification: passed.
- Android tooling upgraded to Gradle 8.14 and Android Gradle Plugin 8.11.1.
- Public GitHub issues: none open.
- Public GitHub pull requests: none open.
