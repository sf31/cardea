# Final Code Review

Date: 2026-07-06

Scope: final pass over the current Cardea Flutter codebase after stabilization work.

Validation run:

```text
flutter analyze
No issues found!
```

No automated tests are currently present under `test/`.

## Findings

### P1 - Full restore can leave partially replaced data

Files:

- `lib/ui/settings/widgets/import_export_data.dart:158`
- `lib/ui/settings/widgets/import_export_data.dart:159`
- `lib/data/repositories/generic.repository.dart:25`

`importFromJson` restores cards and shopping items through two independent `setAll` calls. `GenericRepository.setAll` clears a table first, then inserts rows one by one. If any insert fails after a clear, that table can be left partially restored. If card restore succeeds and shopping restore fails, the app can also end up with only half of the selected backup applied.

Impact: data loss or mixed restore state when a malformed or partially incompatible JSON file is imported.

Recommendation: if import/export remains user-facing, add an atomic restore path using a single DB transaction. If it remains dev-only, keep this as a known risk but avoid making restore look like a full backup product.

### P2 - `LoyaltyCardHome` owns disposable objects from a `StatelessWidget`

Files:

- `lib/ui/loyalty-card/widgets/loyalty_card_home.dart:13`
- `lib/ui/loyalty-card/widgets/loyalty_card_home.dart:14`
- `lib/ui/loyalty-card/widgets/loyalty_card_home.dart:15`
- `lib/ui/home/home_page.dart:61`

`LoyaltyCardHome` is a `StatelessWidget`, but it creates a `FocusNode` and a `ValueNotifier`. These should be disposed, but a `StatelessWidget` has no `dispose`. Also, `MyHomePage.build` constructs new tab widgets inline, so rebuilds can create fresh instances.

Impact: small resource leaks and possible focus behavior drift over time.

Recommendation: convert `LoyaltyCardHome` to a `StatefulWidget` and dispose `findFocusNode` / `atTop`. Consider using an `IndexedStack` in `MyHomePage` if tab state should be preserved.

### P2 - Import/export async state updates need stronger `mounted` guards

Files:

- `lib/ui/settings/widgets/import_export_data.dart:67`
- `lib/ui/settings/widgets/import_export_data.dart:74`
- `lib/ui/settings/widgets/import_export_data.dart:87`
- `lib/ui/settings/widgets/import_export_data.dart:167`

The import/export sheet performs long async work through file pickers, file IO, artificial delays, and database writes. Some paths call `setState` after those awaits without checking `mounted`, especially export and catch blocks.

Impact: if the bottom sheet is dismissed while the picker/IO is pending, Flutter can throw `setState() called after dispose()`.

Recommendation: add `if (!mounted) return;` before every post-await `setState`, including catch blocks. Optionally remove the artificial `Future.delayed` calls.

### P2 - `SettingsViewModel` is registered but incomplete and effectively unused

Files:

- `lib/main.dart:35`
- `lib/main.dart:36`
- `lib/ui/settings/settings.viewmodel.dart:7`
- `lib/ui/settings/settings.viewmodel.dart:10`

`SettingsViewModel` is provided in `main`, but current settings UI does not consume it. Its `exportJson` method builds exports from empty local lists, so using it later would silently produce empty backups.

Impact: maintenance trap. A future refactor could accidentally use this method and ship broken export behavior.

Recommendation: either delete `SettingsViewModel` and its provider, or move import/export orchestration into it properly. Given current app size, deletion is probably better.

### P3 - Persistence error messages are hardcoded English strings

Files:

- `lib/ui/loyalty-card/loyalty_card.viewmodel.dart:296`
- `lib/ui/shopping-list/shopping_item.viewmodel.dart:50`

The viewmodels expose `errorMessage = 'Unable to save changes.'`. That works, but it bypasses localization and couples user-facing text to non-UI classes.

Impact: untranslated error messages in Italian and harder-to-evolve error handling.

Recommendation: expose a simple error enum/code from viewmodels and map it to localized UI strings in widgets, or inject localized strings at the UI boundary.

### P3 - Test suite is currently absent

Files:

- `test/` currently has no test files.

The stale template test was intentionally removed, but there is no replacement safety net yet.

Impact: regressions in persistence, import/export, and scanner flow will rely on manual testing.

Recommendation: add a small focused suite when ready:

- Model serialization tests for `LoyaltyCard` and `ShoppingItem`.
- Viewmodel tests for DB-success/DB-failure state updates.
- Import JSON parsing/restore behavior tests.
- Widget smoke test for app/provider boot.

## Suggestions

### Clean up dead or misleading code

Files:

- `lib/data/services/database.service.dart:42`
- `lib/data/repositories/generic.repository.dart:19`
- `lib/ui/loyalty-card/widgets/loyalty_card_home.dart:27`
- `lib/data/models/export_data.model.dart:3`
- `lib/utils/result.dart:18`

There are commented migration/example blocks and unused helper files. None are urgent, but removing them would reduce noise.

Recommendation: delete unused files and stale comments once the current release branch is stable.

### Review direct dependencies

Files:

- `pubspec.yaml:37`
- `pubspec.yaml:46`

`camera` and `path_provider` appear as direct dependencies, but I did not find direct imports for them in `lib/`. They may be leftovers from earlier work.

Recommendation: verify whether they are still needed. If not, remove them and run `flutter pub get` plus Android/iOS smoke checks.

### Add version/build information to settings

File:

- `lib/ui/settings/widgets/settings.dart:311`

Adding app version/build to Settings would make support/debugging easier.

Recommendation: add `package_info_plus` and display something like `Version 1.0.0 (9)` in Settings.

### Preserve tab state if that matters

File:

- `lib/ui/home/home_page.dart:61`

The current tab body constructs either `LoyaltyCardHome()` or `ShoppingList()` inline. This is simple, but tab-local state can be recreated on navigation/rebuild.

Recommendation: if preserving scroll/input state matters, use an `IndexedStack` with stable child instances.

### Decide how serious import/export should be

The current implementation is pragmatic and acceptable if import/export is mostly a dev escape hatch. If it becomes a real user backup feature, it should get stricter validation, transactional restore, and compatibility/versioning.

## Open Questions

1. Should import/export remain a dev-oriented escape hatch, or should it be treated as a real user backup/restore feature?
2. Should the next small feature be the Settings version tag?
3. Should tests be rebuilt before the next release, or after the next small feature lands?
