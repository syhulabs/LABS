# Architecture

## Principles

1. **Local-first, single database.** One SQLite file (via drift) holds every section. No per-category stores.
2. **Catalog ≠ ownership.** `platforms` rows come from the bundled catalog; `inMyWorld` is the user's explicit choice; `service_accounts` are user-owned records. Re-importing the catalog never touches user columns.
3. **Reusable identities.** An email address is one `email_identities` row referenced by accounts, channels, organizations, artists and project links. Addresses are deduplicated case-insensitively.
4. **Secrets are separate.** Metadata tables hold nothing confidential. Secrets live only in `secure_items` as ciphertext. Bank rows keep last-4 only; cards keep last-4 + expiry.
5. **Relationships are explicit.** Foreign keys for primary ownership (account → platform / email, channel → owner email), plus a generic `links` table for many-to-many relations (project ↔ account / email / subscription / channel / document / bank).
6. **Reactive UI.** Repositories expose drift `watch()` streams; Riverpod `StreamProvider`s feed widgets. Every screen reflects changes instantly.
7. **Shared logic is pure Dart** (`domain/`, `data/`) so it can be reused by any future client and tested without a device.

## Layers

```
features/*  (screens, forms)          ──▶ app/providers.dart (composition root)
shared/widgets (shell, cards, forms)  ──▶ data/repositories/* , data/secure/*, data/backup/*
                                            │
                                            ▼
                                      data/db/app_database.dart (drift)  ──▶ SQLite
domain/ (enums, Money, SubscriptionMath)   ◀── used everywhere, no Flutter imports
```

## Data model (22 tables)

| Table | Purpose | Key relations |
| --- | --- | --- |
| platforms | Catalog + custom platforms; user flags `inMyWorld`, `isFavorite`, `sortOrder` | — |
| email_identities | Reusable email identities (unique normalized address) | — |
| service_accounts | Accounts on a platform (many per platform) | platform, email?, credential_ref? |
| youtube_channels | Channels | owner email?, artist?, organization? |
| channel_managers | Extra managers per channel with role | channel, email |
| organizations | business / recordLabel / studio | primary email? |
| artists | Artist identities | label (organization)?, primary email? |
| projects | app / game / song / release / story / comic / website / IP | organization?, artist? |
| links | Generic entity ↔ entity relation (unique per pair + relation) | polymorphic |
| tags, tag_links | Tags on any entity | polymorphic |
| custom_fields | Non-secret label/value pairs on any entity | polymorphic |
| bank_accounts | Bank metadata (last4, IFSC, SWIFT, routing, netbanking username) | platform?, organization?, full number vault item? |
| payment_cards | Card references (last4, expiry, network, kind) | bank account? |
| payment_methods | Card / bank / UPI / wallet / store billing | card?, bank?, platform? |
| subscriptions | Plan, price (minor units + currency), cycle, dates, status | platform?, account?, payment method? |
| subscription_events | History: created, renewed, priceChanged, statusChanged, planChanged, note | subscription |
| credential_references | Pointer to where a credential lives (1Password item, …) | vault item? |
| document_references | Files / URLs | linked via `links` |
| secure_items | AES-GCM ciphertext + nonce + key id | — |
| audit_events | Non-secret activity trail | — |
| settings | JSON key/value (dashboard layout, lock, theme, currency…) | — |

Soft delete is implemented through `archived_at` on user-facing aggregates; hard delete detaches dependants (e.g. deleting an email sets `service_accounts.email_identity_id` to null rather than deleting accounts).

### Migrations

`AppDatabase.schemaVersion` + `MigrationStrategy.onUpgrade` in `lib/data/db/app_database.dart`. Add a step per version bump; regenerate with `dart run build_runner build`.

## Security design

| Concern | Implementation |
| --- | --- |
| Master key | 256-bit random, generated on first vault use, stored only in `flutter_secure_storage` (Keychain on macOS/iOS, Keystore-backed on Android, libsecret on Linux). Cached in memory per session. |
| Vault item | AES-256-GCM (`package:cryptography`), 96-bit random nonce per write, ciphertext‖tag stored; the item id is the associated data so ciphertext cannot be swapped between rows. |
| Reveal | Decrypts on demand; the audit log records *that* an item was revealed, never its value. |
| Clipboard | `ClipboardService.copySensitive` clears the clipboard after N seconds if it still holds the copied value. |
| App Lock | `AppLockController`: `local_auth` biometrics / system auth where supported; PBKDF2-hashed passcode fallback stored in the keychain; inactivity timer reset by pointer / key events; locks on background. The lock overlay sits above the router so nothing underneath is reachable. |
| Backups | Plain backups exclude `secure_items`. Encrypted backups decrypt vault items locally and wrap the whole document with a passphrase-derived key (PBKDF2-HMAC-SHA256, 600k iterations, random salt) → AES-256-GCM; restore re-encrypts with the local master key, keeping item ids. |
| Search / notifications / logs | `SearchService` only queries metadata tables; notification bodies contain the service name only; `AuditRepository.log` summaries are written by code paths that never see secret values. |
| Exports | CSV/JSON exports omit vault, bank and card tables. |

No custom cryptography. The app is not independently audited.

## Catalog

`assets/catalog/platforms.json` is generated by `tool/gen_catalog.py` (categories, ids, websites, Simple Icons slugs). `CatalogService.ensureSeeded()` upserts it on first launch or when `version` increases; `importFromJsonString` accepts user-supplied update files with the same shape. `tool/gen_brand_icons.py` emits `lib/shared/brand/brand_icons.g.dart`, a slug → (IconData, Color) map so icons resolve by string with no reflection.

Logo resolution order in `PlatformLogo`: original file in `assets/logos/<id>.(svg|png)` → Simple Icons glyph tinted with the brand color → monogram tile.

## Navigation

`go_router` with a `ShellRoute` hosting `AppShell` (grouped, collapsible sidebar on desktop; bottom navigation + drawer on phones). Section routes are in `lib/app/routes.dart`; detail routes push on top of the shell. `⌘K` opens `SearchPalette`.

## Future: sync

Rows use UUID primary keys and `updated_at` timestamps, and the backup document is a complete serialisation of all tables, so an optional end-to-end-encrypted sync can be layered on later without schema changes. Sync is **not** implemented.
