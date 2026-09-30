# Release Workflow

`pubspec.yaml` is the single source of truth for app versioning. For example:

```yaml
version: 2.0.0+2
```

- `2.0.0` is the public version shown by Android and iOS.
- `+2` is the build number. Increase it for every Play Store / App Store upload.
- Keep Android and iOS on the same version and build number.

The version and build numbers in this guide are illustrative. Replace them with the
intended release values; do not reset the build number when changing the public
version.

Publishing a release:

1. Update `version:` in `pubspec.yaml`.
2. Run:

   ```sh
   dart format lib test
   flutter analyze
   flutter test
   ```

3. Review the changes, stage the intended release files, and commit the release
   (replace `2.0.0` with the actual version):

   ```sh
   git commit -m "chore: release 2.0.0"
   ```

4. Confirm the working tree is clean:

   ```sh
   git status --short
   ```

5. Build the store artifacts:

   ```sh
   flutter build appbundle --release
   flutter build ipa
   ```

6. Smoke-test the release on devices, including the main user flows and an
   upgrade from the previous published version with existing data. Upload the
   artifacts and complete the store validation/review process. If fixes are
   needed, repeat the workflow.

7. Once the tested build is approved for publication, tag the release before
   making further commits. Replace `v2.0.0` with the actual version:

   ```sh
   git tag v2.0.0
   ```
