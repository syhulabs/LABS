# Build & run

## Requirements

| Target | Needs |
| --- | --- |
| All | Flutter 3.47.x stable (Dart 3.13), `flutter pub get` |
| macOS | macOS 12+ to run; Xcode 15+ with command line tools; CocoaPods or Swift Package Manager (Flutter handles it) |
| iOS | Xcode 15+, iOS 15+ device or simulator |
| Android | Android SDK (platform 36, build-tools 36), JDK 17, minSdk 23 |
| Linux | clang, cmake, ninja, pkg-config, libgtk-3-dev, libsecret-1-dev |

## Commands

```bash
cd account-hub
flutter pub get

# regenerate drift code after changing lib/data/db/tables.dart
dart run build_runner build --delete-conflicting-outputs

# run
flutter run -d macos
flutter run -d ios
flutter run -d android
flutter run -d linux

# release builds
flutter build macos --release      # → build/macos/Build/Products/Release/SYHU Account Hub.app
flutter build ios --release        # then archive/export with Xcode
flutter build apk --release        # → build/app/outputs/flutter-apk/app-release.apk
flutter build linux --release      # → build/linux/x64/release/bundle/

# checks
flutter analyze
flutter test
```

## Continuous builds for macOS and iOS

`.github/workflows/apple-builds.yml` runs on every push that touches `account-hub/` (and on demand from the Actions tab): it installs Flutter 3.47.8 on a macOS 15 runner, runs the analyzer and tests, builds `SYHU Account Hub.app` and an unsigned iOS `Runner.app`, and uploads both as artifacts (kept 90 days). The macOS zip runs directly (Gatekeeper: right-click → Open the first time). The iOS build is unsigned by design: sign it with your team in Xcode or add signing secrets to the workflow before distributing.

## Platform notes

- **macOS**: entitlements include `keychain-access-groups` (flutter_secure_storage) and `files.user-selected.read-write` (backup/export dialogs). Touch ID is used when available. Set your team in Xcode → Runner → Signing & Capabilities for a signed build.
- **iOS**: `NSFaceIDUsageDescription` is set in `Info.plist`.
- **Android**: `MainActivity` extends `FlutterFragmentActivity` (required by `local_auth`); permissions `USE_BIOMETRIC`, `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`; core-library desugaring is enabled for `flutter_local_notifications`.
- **Linux**: biometrics are not available, so App Lock uses the passcode. Secrets go to libsecret (GNOME Keyring / KWallet).

## Adding logos

Drop `<catalog-id>.png` (or `.svg`) into `assets/logos/`, or run the fetch scripts in `tool/`. Flutter's incremental build does not notice new files inside an asset *directory*, so after adding logos run `flutter clean` before the next `flutter build` or the bundle keeps the old file list.

## Regenerating the catalog

```bash
python3 tool/gen_catalog.py        # writes assets/catalog/platforms.json
python3 tool/gen_brand_icons.py    # writes lib/shared/brand/brand_icons.g.dart (needs pub get first)
```

Bump `version` in `tool/gen_catalog.py` output when you add entries so existing installs pick up the update on next launch.

## Importing a catalog update at runtime

Settings → Catalog → Import. The file must be JSON with the same shape as `assets/catalog/platforms.json`:

```json
{ "version": 2, "categories": [{"id":"ai_assistants","label":"AI Assistants"}],
  "platforms": [{"id":"my-tool","name":"My Tool","categories":["ai_assistants"],"website":"https://…","type":"service","icon":null,"description":"…"}] }
```

## Testing notes

- `flutter test` runs unit tests (`test/domain_test.dart`, `test/crypto_test.dart`), data-layer integration tests on real SQLite (`test/data_layer_test.dart`, `test/persistence_test.dart`), app smoke tests and per-feature widget tests (`test/features/`).
- Widget tests use `test/support/pump_app.dart`. Drift queries and file I/O never complete inside the widget-test fake-async zone, so build the container with `tester.runAsync(createTestContainer)` and run repository calls through `data(tester, () => ...)`. Use `settle()` rather than `pumpAndSettle()` (the dashboard clock never settles). UI actions that trigger AES-GCM (saving a vault item) must also run inside `runAsync`.
- `integration_test/app_test.dart` drives the real app (on-disk database, keychain key store) on a device or desktop: `flutter test integration_test -d macos` (or `-d linux` under `xvfb-run` on a headless box).

## TestFlight from CI

The `testflight` job in `.github/workflows/apple-builds.yml` signs the iOS build and uploads it to TestFlight on every push. It stays off until you add these in the repository's **Settings → Secrets and variables → Actions**:

| Kind | Name | Where it comes from |
| --- | --- | --- |
| Variable | `TESTFLIGHT_ENABLED` | `true` to switch the job on |
| Variable | `IOS_BUNDLE_ID` | optional; defaults to `com.syhulabs.syhuAccountHub` |
| Secret | `ASC_ISSUER_ID` | App Store Connect → Users and Access → Integrations → App Store Connect API (Issuer ID) |
| Secret | `ASC_KEY_ID` | Key ID of a key you generate there with the **App Manager** role |
| Secret | `ASC_PRIVATE_KEY` | full contents of the downloaded `AuthKey_XXXX.p8` |
| Secret | `IOS_DIST_P12_BASE64` | your Apple Distribution certificate exported from Keychain Access as `.p12`, then `base64 -i cert.p12 \| pbcopy` |
| Secret | `IOS_DIST_P12_PASSWORD` | the password you set when exporting the `.p12` |

One-time setup in App Store Connect: create the app record (My Apps → + → New App) with the same bundle id and name **SYHU Account Hub**. The job then downloads an App Store provisioning profile for that bundle id through the API, builds the IPA with the run number as the build number, and uploads it. Builds appear under TestFlight → iOS Builds a few minutes later; add yourself as an internal tester once.
