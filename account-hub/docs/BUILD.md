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

## Platform notes

- **macOS**: entitlements include `keychain-access-groups` (flutter_secure_storage) and `files.user-selected.read-write` (backup/export dialogs). Touch ID is used when available. Set your team in Xcode → Runner → Signing & Capabilities for a signed build.
- **iOS**: `NSFaceIDUsageDescription` is set in `Info.plist`.
- **Android**: `MainActivity` extends `FlutterFragmentActivity` (required by `local_auth`); permissions `USE_BIOMETRIC`, `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`; core-library desugaring is enabled for `flutter_local_notifications`.
- **Linux**: biometrics are not available, so App Lock uses the passcode. Secrets go to libsecret (GNOME Keyring / KWallet).

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
