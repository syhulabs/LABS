# Progress & verification record

_Updated 24 Oct 2026. Branch `claude/wizardly-pasteur-kmnhrm`._

## Phase checklist

| Phase | Scope | Status |
| --- | --- | --- |
| 1 Foundation | Flutter project (macOS, iOS, Android, Linux), drift schema (22 tables), Riverpod composition root, dark/light theme, grouped collapsible sidebar, go_router, shared widgets | ✅ |
| 2 Functional core | Offline catalog (1,192 platforms, 37 categories) + import, Explore, My World (explicit add only, reorder, favorites), reusable email identities with reverse lookup, multiple accounts per platform, ⌘K global search | ✅ |
| 3 Specialized managers | YouTube (owner identity + multiple managers with roles), AI/Social/Gaming/Game Engines/Developer/Cloud hubs, Google/Apple/Microsoft ecosystem hubs, Personal/Business hubs, artists, labels, studios, projects with cross-entity links, documents | ✅ |
| 4 Financial | Bank metadata (last-4 only; optional encrypted full number), cards (last-4 + expiry only), payment methods, subscriptions with statuses/cycles/history/renewal marking, per-currency monthly & annual totals, charts, grouping/filtering | ✅ |
| 5 Security | AES-256-GCM vault keyed from the OS keychain, credential references, App Lock (biometrics / passcode, auto-lock, lock on background), clipboard auto-clear, no secrets in search/notifications/audit/exports | ✅ |
| 6 Completion | Plain + encrypted backup, validated restore with typed confirmation, CSV/JSON exports, settings, renewal notifications, dashboard customisation, tests, docs, builds | ✅ (see verification) |

## Feature checklist (from the brief)

- [x] Launches, persists across restarts (`test/persistence_test.dart` reopens the on-disk file)
- [x] Create / edit / archive / restore / delete for every record type
- [x] Multiple accounts per platform; duplicate (platform + label + email) rejected
- [x] Multiple YouTube channels per Google identity; several managers per channel
- [x] One email identity linked to many services; reverse lookup screen
- [x] Catalog entries vs user-owned records kept distinct; browsing never adds
- [x] Subscription totals accurate and currency-aware (never summed across currencies)
- [x] Sensitive data protected: vault ciphertext only, bank/card metadata only, nothing secret in search, toasts, notifications, audit log or plain exports
- [x] Missing logos handled: original file → Simple Icons glyph → monogram (no look-alike substitutes)
- [x] Recovers from bad input (validation, friendly error toasts, FK-checked restore that rolls back)
- [x] Dashboard numbers come from local data; empty = 0
- [x] Dashboard sections reorderable / hideable
- [x] Keyboard: ⌘K / Ctrl+K search, ⌘1–3 sections, ⌘, settings; Enter submits forms
- [x] Context menus on cards/rows; confirmation on destructive actions; empty states everywhere
- [x] Light and dark themes (dark default); responsive layouts; tooltips/semantics on icon buttons
- [x] README, ARCHITECTURE, BUILD, PROGRESS docs; catalog + brand-icon generators

## Verification record (this environment: Linux container, no Xcode)

| Check | Result |
| --- | --- |
| `flutter analyze` | No issues |
| `flutter test` (unit + data-layer + widget) | **60 passed, 0 failed** |
| `integration_test/app_test.dart` on Linux desktop (Xvfb, real on-disk DB + libsecret) | **1 passed**: Explore → Add → My World → platform detail → account form → saved row verified → global search finds it → ⌘K palette opens |
| `flutter build linux --release` | ✅ bundle produced |
| `flutter build apk --release` | ✅ `app-release.apk` (73.5 MB universal, debug-signed) containing all 1,137 logo PNGs (2.7 MB). Gradle needed a Maven Central mirror because the container's proxy rate-limited Central. |
| `flutter build macos --release` / `flutter build ios --release --no-codesign` | ✅ Built on a GitHub-hosted Mac (macOS 15, Xcode 16.4, Flutter 3.47.8) by `.github/workflows/apple-builds.yml`, run 1: analyzer clean, 60/60 tests, `SYHU Account Hub.app` (61 MB) and unsigned `Runner.app` (27 MB) uploaded as artifacts. |
| Touch ID / Face ID, Keychain, Apple notifications | Implemented via `local_auth`, `flutter_secure_storage`, `flutter_local_notifications`; compile on Apple toolchains (CI), **runtime behaviour not yet exercised on Apple hardware.** |

Screenshots of the Linux build are in `docs/screenshots/`.

## Test inventory

| File | Covers |
| --- | --- |
| `test/domain_test.dart` (14) | Money, per-currency totals, cycle math, upcoming renewals, month-end clamping, id/email normalisation |
| `test/crypto_test.dart` (4) | Master key lifecycle, AES-GCM round trip + tamper/AAD rejection, passphrase envelope, passcode hashing |
| `test/data_layer_test.dart` (13) | Catalog seeding/idempotence/flag preservation/duplicate rejection, email reuse + dedupe, multi-account, channel owner/managers, link table, bank/card masking, subscription totals + history, vault secrecy in search/backup/audit, encrypted backup restore, global search, zero stats |
| `test/persistence_test.dart` (2) | On-disk reopen, schema version + 22 tables |
| `test/app_smoke_test.dart` (4) | Boot to Home with zeros, sidebar navigation, Explore Add vs browse, dashboard customisation |
| `test/features/*` (23) | Accounts/emails, vault, settings, YouTube, studio, banking, subscriptions screens |

## Known limitations / next steps

1. **Apple runtime check.** The apps compile in CI; run the macOS artifact (right-click → Open the first time, it is unsigned) and `flutter test integration_test -d macos` on a Mac to exercise Keychain, Touch ID and notifications. For iOS on a device, open `ios/Runner.xcworkspace` in Xcode, pick your team, and run.
2. Logos: 1137 of 1227 catalog entries ship a coloured original mark; 20 more have an official monochrome glyph tinted in brand colour; 70 show a monogram because no official source was reachable from this container (list: play-ht, moj, josh, tunecore, awal, the-orchard, onerpm, output, pro-tools, studio-one, reaper, spitfire-audio, eastwest, sonarworks, sibelius, submithub, linkfire, toneden, resso, hungama-music, fanhouse, comixology, lulu, campfire, mixamo, cgtrader, hitfilm, moho, opentoonz, synfig-studio, tvpaint, reallusion, ibm-cloud, bethesda-net, poki-developers, defold, phaser, playcanvas, pygame, stride, tiled, dragonbones, kenney, opengameart, aol-mail, rediffmail, yes-bank, punjab-sind-bank, paytm-payments-bank, zerodha, groww, fidelity, rupay, upi, gst-portal, mca-india, udyam-registration, pan-india, epfo, startup-india, ip-india, copyright-india, uspto, society6, best-buy, byju-s, scaler, podia, tata-play, kits-ai). Drop originals into `assets/logos/<catalog-id>.png` to fill them.
3. Cloud sync is intentionally not implemented (architecture is sync-ready: UUID keys, `updated_at`, full-document backups).
4. Email inbox integrations are not implemented (by design; would need explicit OAuth consent).
5. Currency conversion is not implemented; totals are shown per currency.
6. Not independently security-audited.
