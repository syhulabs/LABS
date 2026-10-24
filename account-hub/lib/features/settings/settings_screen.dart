import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../data/backup/backup_service.dart';
import '../../data/db/database_connection.dart';
import '../../data/repositories/settings_repository.dart';
import '../../domain/money.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/form_sheet.dart';
import '../../shared/widgets/page_scaffold.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/status_chip.dart';
import '../../shared/widgets/toast.dart';

enum _Section {
  profile('Profile & appearance', Icons.person_outline),
  dashboard('Dashboard', Icons.dashboard_outlined),
  security('Security', Icons.lock_outline),
  notifications('Notifications', Icons.notifications_outlined),
  backup('Backup & export', Icons.backup_outlined),
  catalog('Platform catalog', Icons.apps_outlined),
  data('Data', Icons.storage_outlined),
  about('About', Icons.info_outline);

  const _Section(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// Settings: profile, appearance, security, notifications, backup/export,
/// catalog updates, data management, about.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key, this.initialSection});
  final String? initialSection;
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late _Section _section = _parse(widget.initialSection);

  static _Section _parse(String? s) => _Section.values.where((x) => x.name == s).firstOrNull ?? _Section.profile;

  @override
  void didUpdateWidget(covariant SettingsScreen old) {
    super.didUpdateWidget(old);
    if (old.initialSection != widget.initialSection && widget.initialSection != null) _section = _parse(widget.initialSection);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final body = switch (_section) {
      _Section.profile => const _ProfileSection(),
      _Section.dashboard => const _DashboardSection(),
      _Section.security => const _SecuritySection(),
      _Section.notifications => const _NotificationsSection(),
      _Section.backup => const _BackupSection(),
      _Section.catalog => const _CatalogSection(),
      _Section.data => const _DataSection(),
      _Section.about => const _AboutSection(),
    };
    final nav = context.isCompact
        ? Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [for (final s in _Section.values) Padding(padding: const EdgeInsets.only(right: 6), child: ChoiceChip(avatar: Icon(s.icon, size: 14), label: Text(s.label), selected: _section == s, onSelected: (_) => setState(() => _section = s)))]),
            ),
          )
        : SizedBox(
            width: 220,
            child: Column(children: [
              for (final s in _Section.values)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Material(
                    color: _section == s ? c.accent.withValues(alpha: 0.2) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: ListTile(
                      dense: true,
                      selected: _section == s,
                      leading: Icon(s.icon, size: 18, color: _section == s ? c.text : c.textMuted),
                      title: Text(s.label, style: TextStyle(fontWeight: _section == s ? FontWeight.w600 : FontWeight.w500)),
                      onTap: () => setState(() => _section = s),
                    ),
                  ),
                ),
            ]),
          );
    return PageScaffold(
      title: 'Settings',
      subtitle: 'Everything stays on this device unless you export it.',
      children: [
        if (context.isCompact) ...[nav, body] else Row(crossAxisAlignment: CrossAxisAlignment.start, children: [nav, const SizedBox(width: 28), Expanded(child: body)]),
      ],
    );
  }
}

// ---------------------------------------------------------------- Profile
class _ProfileSection extends ConsumerStatefulWidget {
  const _ProfileSection();
  @override
  ConsumerState<_ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends ConsumerState<_ProfileSection> {
  final _name = TextEditingController();
  final _focus = FocusNode();
  bool _seeded = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (!_focus.hasFocus) _save();
    });
  }

  @override
  void dispose() {
    _focus.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await ref.read(settingsRepositoryProvider).set(SettingsRepository.kDisplayName, _name.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider).value ?? const <String, dynamic>{};
    if (!_seeded && settings.isNotEmpty || (!_seeded && ref.watch(settingsProvider).hasValue)) {
      _seeded = true;
      _name.text = settings.displayName ?? '';
    }
    final repo = ref.read(settingsRepositoryProvider);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SectionHeader(title: 'Profile'),
      AppCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          TextField(
            controller: _name,
            focusNode: _focus,
            decoration: const InputDecoration(labelText: 'Display name', hintText: 'Shown in the greeting and sidebar', prefixIcon: Icon(Icons.badge_outlined, size: 18)),
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 6),
          Text('Saved automatically when you leave the field.', style: context.text.bodySmall?.copyWith(color: context.colors.textMuted)),
        ]),
      ),
      const SizedBox(height: 20),
      const SectionHeader(title: 'Appearance'),
      AppCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Theme', style: context.text.labelLarge),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'dark', label: Text('Dark'), icon: Icon(Icons.dark_mode_outlined, size: 16)),
              ButtonSegment(value: 'light', label: Text('Light'), icon: Icon(Icons.light_mode_outlined, size: 16)),
              ButtonSegment(value: 'system', label: Text('System'), icon: Icon(Icons.brightness_auto_outlined, size: 16)),
            ],
            selected: {settings.themeMode},
            onSelectionChanged: (s) => repo.set(SettingsRepository.kThemeMode, s.first),
          ),
          const SizedBox(height: 18),
          AppDropdown<String>(
            label: 'Default currency for new subscriptions',
            value: settings.defaultCurrency,
            items: [for (final cur in supportedCurrencies) (cur, '${Money.currencySymbol(cur).trim()} $cur')],
            onChanged: (v) => repo.set(SettingsRepository.kDefaultCurrency, v ?? 'INR'),
          ),
        ]),
      ),
    ]);
  }
}

// -------------------------------------------------------------- Dashboard
class _DashboardSection extends StatelessWidget {
  const _DashboardSection();
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SectionHeader(title: 'Dashboard'),
      AppCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('The Home dashboard is built from sections you can reorder or hide: welcome, overview numbers, My World, upcoming renewals, recently accessed, favorites, security overview and quick actions.', style: context.text.bodyMedium),
          const SizedBox(height: 8),
          Text('All numbers come from your local data. An empty hub shows zeros, never sample figures.', style: context.text.bodySmall?.copyWith(color: context.colors.textMuted)),
          const SizedBox(height: 14),
          FilledButton.icon(onPressed: () => context.go(Routes.home), icon: const Icon(Icons.tune, size: 18), label: const Text('Open Home → Customize dashboard')),
        ]),
      ),
    ]);
  }
}

// --------------------------------------------------------------- Security
class _SecuritySection extends ConsumerStatefulWidget {
  const _SecuritySection();
  @override
  ConsumerState<_SecuritySection> createState() => _SecuritySectionState();
}

class _SecuritySectionState extends ConsumerState<_SecuritySection> {
  bool? _deviceAuth;
  bool? _hasPasscode;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final lock = ref.read(appLockProvider);
    final d = await lock.canUseDeviceAuth();
    final p = await lock.crypto.hasPasscode();
    if (mounted) setState(() { _deviceAuth = d; _hasPasscode = p; });
  }

  Future<String?> _askPasscode(String title) async {
    final a = TextEditingController();
    final b = TextEditingController();
    String? error;
    return showFormSheet<String>(context, title: title, maxWidth: 420, builder: (ctx, close) {
      return StatefulBuilder(builder: (ctx, setState) {
        void submit() {
          if (a.text.length < 4) { setState(() => error = 'Use at least 4 characters'); return; }
          if (a.text != b.text) { setState(() => error = 'Passcodes do not match'); return; }
          close(a.text);
        }
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('The passcode is hashed and kept in the OS keychain. It unlocks the app when biometrics are unavailable.', style: ctx.text.bodySmall?.copyWith(color: ctx.colors.textMuted)),
          const SizedBox(height: 12),
          TextField(controller: a, obscureText: true, autofocus: true, decoration: const InputDecoration(labelText: 'Passcode')),
          const SizedBox(height: 10),
          TextField(controller: b, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm passcode'), onSubmitted: (_) => submit()),
          if (error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(error!, style: TextStyle(color: ctx.colors.danger))),
          FormActions(onCancel: close, onSave: submit, saveLabel: 'Set passcode'),
        ]);
      });
    });
  }

  Future<void> _toggleLock(bool on) async {
    final lock = ref.read(appLockProvider);
    final settings = ref.read(settingsRepositoryProvider);
    if (on) {
      String? passcode;
      final hasPass = await lock.crypto.hasPasscode();
      final device = await lock.canUseDeviceAuth();
      if (!mounted) return;
      if (!hasPass) {
        final wantPasscode = !device ||
            await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Add a passcode too?'),
                    content: const Text('Device authentication (Touch ID / Face ID / system) is available. A passcode is a fallback when biometrics fail.'),
                    actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Biometrics only')), FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Set passcode'))],
                  ),
                ) ==
                true;
        if (wantPasscode) {
          if (!mounted) return;
          passcode = await _askPasscode('Set a passcode');
          if (passcode == null) return;
        }
      }
      final err = await lock.enable(passcode: passcode);
      if (err != null) {
        if (mounted) showToast(context, err, error: true);
        return;
      }
      await settings.set(SettingsRepository.kLockEnabled, true);
      if (mounted) showToast(context, 'App Lock enabled');
    } else {
      if (!await confirmDestructive(context, title: 'Turn off App Lock?', message: 'The app opens without authentication until you turn it back on.', confirmLabel: 'Turn off', danger: false)) return;
      await lock.disable();
      await settings.set(SettingsRepository.kLockEnabled, false);
    }
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final lock = ref.watch(appLockProvider);
    final settings = ref.watch(settingsProvider).value ?? const <String, dynamic>{};
    final repo = ref.read(settingsRepositoryProvider);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SectionHeader(title: 'App Lock'),
      AppCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Require authentication to open'),
            subtitle: Text(_deviceAuth == null ? 'Checking device capabilities…' : _deviceAuth! ? 'Biometric / system authentication available on this device.' : 'No biometric or system authentication available here: a passcode is required.', style: TextStyle(color: c.textMuted, fontSize: 12)),
            value: lock.enabled,
            onChanged: _toggleLock,
          ),
          const Divider(height: 20),
          AppDropdown<int>(
            label: 'Auto-lock after inactivity',
            value: settings.lockTimeoutSeconds,
            items: const [(60, '1 minute'), (300, '5 minutes'), (900, '15 minutes'), (3600, '1 hour'), (0, 'Never')],
            onChanged: (v) async {
              final secs = v ?? 300;
              await repo.set(SettingsRepository.kLockTimeoutSeconds, secs);
              ref.read(appLockProvider).timeout = Duration(seconds: secs);
            },
          ),
          Wrap(spacing: 10, runSpacing: 10, children: [
            OutlinedButton.icon(
              onPressed: () async {
                final p = await _askPasscode(_hasPasscode == true ? 'Change passcode' : 'Set a passcode');
                if (p == null) return;
                await ref.read(appLockProvider).crypto.setPasscode(p);
                await _refresh();
                if (context.mounted) showToast(context, 'Passcode saved');
              },
              icon: const Icon(Icons.password, size: 18),
              label: Text(_hasPasscode == true ? 'Change passcode' : 'Set passcode'),
            ),
            if (_hasPasscode == true && _deviceAuth == true)
              OutlinedButton.icon(
                onPressed: () async {
                  if (!await confirmDestructive(context, title: 'Remove passcode?', message: 'You will rely on device authentication only.', confirmLabel: 'Remove')) return;
                  await ref.read(appLockProvider).crypto.clearPasscode();
                  await _refresh();
                },
                icon: const Icon(Icons.remove_circle_outline, size: 18),
                label: const Text('Remove passcode'),
              ),
            if (lock.enabled) FilledButton.tonalIcon(onPressed: lock.lock, icon: const Icon(Icons.lock, size: 18), label: const Text('Lock now')),
          ]),
        ]),
      ),
      const SizedBox(height: 20),
      const SectionHeader(title: 'Clipboard'),
      AppCard(
        child: AppDropdown<int>(
          label: 'Clear copied secrets after',
          value: settings.clipboardClearSeconds,
          items: const [(15, '15 seconds'), (30, '30 seconds'), (60, '60 seconds'), (0, 'Never')],
          onChanged: (v) async {
            final secs = v ?? 30;
            await repo.set(SettingsRepository.kClipboardClearSeconds, secs);
            ref.read(clipboardServiceProvider).clearAfter = Duration(seconds: secs);
          },
        ),
      ),
      const SizedBox(height: 12),
      Text('Secrets are encrypted with AES-256-GCM using a key stored in the OS keychain. Nothing sensitive is written to logs, notifications or search. This app has not been independently security-audited.', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
    ]);
  }
}

// ---------------------------------------------------------- Notifications
class _NotificationsSection extends ConsumerWidget {
  const _NotificationsSection();

  Future<void> _reschedule(WidgetRef ref) async {
    final settings = ref.read(settingsProvider).value ?? const <String, dynamic>{};
    final ns = ref.read(notificationServiceProvider);
    if (!await ns.initialize()) return;
    final subs = await ref.read(subscriptionRepositoryProvider).watchAll().first;
    await ns.rescheduleRenewals(subs, daysBefore: settings.renewalReminderDays, enabled: settings.notificationsEnabled);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final settings = ref.watch(settingsProvider).value ?? const <String, dynamic>{};
    final repo = ref.read(settingsRepositoryProvider);
    final supported = ref.read(notificationServiceProvider).isSupported;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SectionHeader(title: 'Renewal reminders'),
      AppCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Notify before a subscription renews'),
            subtitle: Text('Reminders name the service only; never amounts or account details.', style: TextStyle(color: c.textMuted, fontSize: 12)),
            value: settings.notificationsEnabled,
            onChanged: (v) async {
              await repo.set(SettingsRepository.kNotificationsEnabled, v);
              await _reschedule(ref);
            },
          ),
          const SizedBox(height: 8),
          AppDropdown<int>(
            label: 'Remind me',
            value: settings.renewalReminderDays,
            items: const [(1, '1 day before'), (3, '3 days before'), (7, '7 days before'), (14, '14 days before')],
            onChanged: (v) async {
              await repo.set(SettingsRepository.kRenewalReminderDays, v ?? 3);
              await _reschedule(ref);
            },
          ),
          Wrap(spacing: 10, children: [
            OutlinedButton.icon(
              onPressed: () async {
                final ns = ref.read(notificationServiceProvider);
                final ok = await ns.initialize();
                if (!context.mounted) return;
                if (!ok) {
                  showToast(context, 'Notifications are not available on this platform or were denied.', error: true);
                  return;
                }
                await ns.showTest();
                if (context.mounted) showToast(context, 'Test notification sent');
              },
              icon: const Icon(Icons.notifications_active_outlined, size: 18),
              label: const Text('Send test notification'),
            ),
            OutlinedButton.icon(
              onPressed: () async {
                await _reschedule(ref);
                if (context.mounted) showToast(context, 'Reminders re-planned');
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Re-plan reminders'),
            ),
          ]),
          if (!supported) Padding(padding: const EdgeInsets.only(top: 10), child: Text('Local notifications are not supported on this platform build.', style: TextStyle(color: c.warning))),
        ]),
      ),
    ]);
  }
}

// ------------------------------------------------------------------ Backup
class _BackupSection extends ConsumerWidget {
  const _BackupSection();

  static String _stamp() => DateFormat('yyyyMMdd-HHmm').format(DateTime.now());

  Future<bool> _save(BuildContext context, String fileName, String content, {String mime = 'application/json'}) async {
    try {
      final uri = await FilePicker.saveFile(dialogTitle: 'Save $fileName', fileName: fileName, bytes: Uint8List.fromList(utf8.encode(content)), mimeType: mime);
      if (uri == null) return false;
      if (context.mounted) showToast(context, 'Saved $fileName');
      return true;
    } catch (e) {
      if (context.mounted) showToast(context, 'Could not save: ${friendlyError(e)}', error: true);
      return false;
    }
  }

  Future<void> _export(BuildContext context, String fileName, Future<String> Function() produce, {String mime = 'application/json'}) async {
    final content = await produce();
    if (!context.mounted) return;
    await _save(context, fileName, content, mime: mime);
  }

  Future<String?> _askPassphrase(BuildContext context, {required String title, bool confirm = true}) async {
    final a = TextEditingController();
    final b = TextEditingController();
    String? error;
    return showFormSheet<String>(context, title: title, maxWidth: 440, builder: (ctx, close) {
      return StatefulBuilder(builder: (ctx, setState) {
        void submit() {
          if (confirm && a.text.length < 8) { setState(() => error = 'Use at least 8 characters'); return; }
          if (confirm && a.text != b.text) { setState(() => error = 'Passphrases do not match'); return; }
          if (a.text.isEmpty) { setState(() => error = 'Enter the passphrase'); return; }
          close(a.text);
        }
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (confirm) Text('There is no recovery: a lost passphrase makes the backup unreadable.', style: ctx.text.bodySmall?.copyWith(color: ctx.colors.warning)),
          const SizedBox(height: 12),
          TextField(controller: a, obscureText: true, autofocus: true, decoration: const InputDecoration(labelText: 'Passphrase'), onSubmitted: confirm ? null : (_) => submit()),
          if (confirm) ...[const SizedBox(height: 10), TextField(controller: b, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm passphrase'), onSubmitted: (_) => submit())],
          if (error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(error!, style: TextStyle(color: ctx.colors.danger))),
          FormActions(onCancel: close, onSave: submit, saveLabel: 'Continue'),
        ]);
      });
    });
  }

  Future<void> _backupPlain(BuildContext context, WidgetRef ref) async {
    final json = await ref.read(backupServiceProvider).plainBackupJson();
    if (!context.mounted) return;
    if (await _save(context, 'syhu-account-hub-backup-${_stamp()}.json', json)) {
      await ref.read(settingsRepositoryProvider).set(SettingsRepository.kLastBackupAt, DateTime.now().toIso8601String());
      await ref.read(auditRepositoryProvider).log('backup.plain', summary: 'Created plain backup');
    }
  }

  Future<void> _backupEncrypted(BuildContext context, WidgetRef ref) async {
    final pass = await _askPassphrase(context, title: 'Encrypt backup');
    if (pass == null || !context.mounted) return;
    try {
      final env = await ref.read(backupServiceProvider).encryptedBackup(pass);
      if (!context.mounted) return;
      if (await _save(context, 'syhu-account-hub-backup-${_stamp()}.syhubackup', env, mime: 'application/octet-stream')) {
        await ref.read(settingsRepositoryProvider).set(SettingsRepository.kLastBackupAt, DateTime.now().toIso8601String());
      }
    } catch (e) {
      if (context.mounted) showToast(context, friendlyError(e), error: true);
    }
  }

  Future<void> _restore(BuildContext context, WidgetRef ref) async {
    final files = await FilePicker.pickFiles(dialogTitle: 'Choose a backup');
    if (files.isEmpty || !context.mounted) return;
    final content = await files.first.xFile.readAsString();
    if (!context.mounted) return;
    final encrypted = content.contains('syhu-account-hub-encrypted-backup');
    String? pass;
    if (encrypted) {
      pass = await _askPassphrase(context, title: 'Backup passphrase', confirm: false);
      if (pass == null || !context.mounted) return;
    }
    final service = ref.read(backupServiceProvider);
    final Map<String, dynamic> doc;
    final BackupSummary summary;
    try {
      (doc, summary) = await service.inspect(content, passphrase: pass);
    } catch (e) {
      if (context.mounted) showToast(context, friendlyError(e), error: true);
      return;
    }
    if (!context.mounted) return;
    final go = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore this backup?'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Created ${DateFormat.yMMMd().add_jm().format(summary.createdAt)} · app ${summary.appVersion} · schema v${summary.schemaVersion}'),
            Text(summary.includesVault ? 'Includes vault items (will be re-encrypted on this device).' : 'Does not include vault items.'),
            const SizedBox(height: 10),
            for (final e in summary.rowCounts.entries.where((e) => e.value > 0)) Text('${e.key.replaceAll('_', ' ')}: ${e.value}', style: ctx.text.bodySmall),
            const SizedBox(height: 12),
            Text('All current data on this device is replaced.', style: TextStyle(color: ctx.colors.danger, fontWeight: FontWeight.w600)),
          ]),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Continue'))],
      ),
    );
    if (go != true || !context.mounted) return;
    if (!context.mounted || !await confirmTyped(context, title: 'Replace all data', message: 'This cannot be undone. Type RESTORE to continue.', word: 'RESTORE')) return;
    try {
      await service.restore(doc);
      if (!context.mounted) return;
      await ref.read(catalogServiceProvider).ensureSeeded();
      if (context.mounted) showToast(context, 'Backup restored (${summary.totalRows} rows)');
    } catch (e) {
      if (context.mounted) showToast(context, 'Restore failed: ${friendlyError(e)}', error: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final settings = ref.watch(settingsProvider).value ?? const <String, dynamic>{};
    final last = settings[SettingsRepository.kLastBackupAt] as String?;
    final service = ref.read(backupServiceProvider);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SectionHeader(title: 'Backup'),
      AppCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(last == null ? Icons.warning_amber_outlined : Icons.check_circle_outline, color: last == null ? c.warning : c.success),
            const SizedBox(width: 8),
            Text(last == null ? 'No backup yet' : 'Last backup ${DateFormat.yMMMd().add_jm().format(DateTime.parse(last))}'),
          ]),
          const SizedBox(height: 14),
          Wrap(spacing: 10, runSpacing: 10, children: [
            FilledButton.icon(onPressed: () => _backupPlain(context, ref), icon: const Icon(Icons.backup_outlined, size: 18), label: const Text('Back up now (JSON)')),
            FilledButton.tonalIcon(onPressed: () => _backupEncrypted(context, ref), icon: const Icon(Icons.enhanced_encryption_outlined, size: 18), label: const Text('Encrypted backup')),
            OutlinedButton.icon(onPressed: () => _restore(context, ref), icon: const Icon(Icons.restore, size: 18), label: const Text('Restore from backup…')),
          ]),
          const SizedBox(height: 12),
          Text('Plain backups contain all metadata but never vault secrets. Encrypted backups (.syhubackup) also carry the vault, protected by your passphrase (AES-256-GCM, PBKDF2), and can be restored on another device. Restoring replaces everything after confirmation.', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
        ]),
      ),
      const SizedBox(height: 20),
      const SectionHeader(title: 'Export'),
      AppCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(spacing: 10, runSpacing: 10, children: [
            OutlinedButton.icon(onPressed: () => _export(context, 'accounts-${_stamp()}.csv', service.exportAccountsCsv, mime: 'text/csv'), icon: const Icon(Icons.table_chart_outlined, size: 18), label: const Text('Accounts CSV')),
            OutlinedButton.icon(onPressed: () => _export(context, 'subscriptions-${_stamp()}.csv', service.exportSubscriptionsCsv, mime: 'text/csv'), icon: const Icon(Icons.table_chart_outlined, size: 18), label: const Text('Subscriptions CSV')),
            OutlinedButton.icon(onPressed: () => _export(context, 'emails-${_stamp()}.csv', service.exportEmailsCsv, mime: 'text/csv'), icon: const Icon(Icons.table_chart_outlined, size: 18), label: const Text('Emails CSV')),
            OutlinedButton.icon(onPressed: () => _export(context, 'metadata-${_stamp()}.json', service.exportMetadataJson), icon: const Icon(Icons.data_object, size: 18), label: const Text('Metadata JSON')),
          ]),
          const SizedBox(height: 12),
          Text('Exports never include vault items, bank account rows, card details or credential references.', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
        ]),
      ),
    ]);
  }
}

// ----------------------------------------------------------------- Catalog
class _CatalogSection extends ConsumerWidget {
  const _CatalogSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final platforms = ref.watch(allPlatformsProvider).value ?? const [];
    final settings = ref.watch(settingsProvider).value ?? const <String, dynamic>{};
    final version = settings['catalog.importedVersion'];
    final custom = platforms.where((p) => p.isCustom).length;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SectionHeader(title: 'Platform catalog'),
      AppCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(spacing: 8, runSpacing: 8, children: [
            StatusChip('${platforms.length} platforms', color: c.accent, dense: false),
            StatusChip('$custom custom', color: c.accentBlue, dense: false),
            StatusChip('catalog v${version ?? '?'}', color: c.textMuted, dense: false),
          ]),
          const SizedBox(height: 14),
          Wrap(spacing: 10, runSpacing: 10, children: [
            FilledButton.icon(
              onPressed: () async {
                final files = await FilePicker.pickFiles(dialogTitle: 'Choose a catalog JSON file');
                if (files.isEmpty || !context.mounted) return;
                try {
                  final raw = await files.first.xFile.readAsString();
                  final n = await ref.read(catalogServiceProvider).importFromJsonString(raw);
                  if (context.mounted) showToast(context, 'Imported $n platform entries');
                } catch (e) {
                  if (context.mounted) showToast(context, 'Import failed: ${friendlyError(e)}', error: true);
                }
              },
              icon: const Icon(Icons.upload_file_outlined, size: 18),
              label: const Text('Import catalog update (JSON)…'),
            ),
            OutlinedButton.icon(onPressed: () => context.go(Routes.explore), icon: const Icon(Icons.explore_outlined, size: 18), label: const Text('Open Explore')),
          ]),
          const SizedBox(height: 12),
          Text('Format: {"version": N, "categories": [{"id","label"}], "platforms": [{"id","name","categories":[…],"website","type","vendor","icon","description"}]}. Entries are matched by id; your favorites, My World selection and ordering are preserved. Original logo files go in assets/logos/<id>.png or .svg.', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
        ]),
      ),
    ]);
  }
}

// -------------------------------------------------------------------- Data
class _DataSection extends ConsumerStatefulWidget {
  const _DataSection();
  @override
  ConsumerState<_DataSection> createState() => _DataSectionState();
}

class _DataSectionState extends ConsumerState<_DataSection> {
  String? _path;

  @override
  void initState() {
    super.initState();
    databaseFilePath().then((p) => mounted ? setState(() => _path = p) : null).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final audit = ref.watch(auditProvider).value ?? const [];
    final fmt = DateFormat.MMMd().add_jm();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SectionHeader(title: 'Storage'),
      AppCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Database file', style: context.text.labelLarge),
          const SizedBox(height: 4),
          SelectableText(_path ?? 'Resolving…', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
          const SizedBox(height: 10),
          if (_path != null)
            TextButton.icon(
              onPressed: () async {
                await ref.read(clipboardServiceProvider).copyPlain(_path!);
                if (context.mounted) showToast(context, 'Path copied');
              },
              icon: const Icon(Icons.copy, size: 16),
              label: const Text('Copy path'),
            ),
        ]),
      ),
      const SizedBox(height: 20),
      SectionHeader(
        title: 'Activity log',
        subtitle: 'What changed, never secret values',
        actions: [
          if (audit.isNotEmpty)
            TextButton.icon(
              onPressed: () async {
                if (await confirmDestructive(context, title: 'Clear activity log?', message: 'Only the log is removed.', confirmLabel: 'Clear')) await ref.read(auditRepositoryProvider).clear();
              },
              icon: const Icon(Icons.delete_sweep_outlined, size: 16),
              label: const Text('Clear log'),
            ),
        ],
      ),
      AppCard(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: audit.isEmpty
            ? const EmptyState(compact: true, icon: Icons.history, title: 'No activity yet', message: 'Changes you make are listed here.')
            : Column(children: [
                for (final a in audit.take(50))
                  ListTile(dense: true, leading: Icon(Icons.history, size: 16, color: c.textMuted), title: Text(a.summary), subtitle: Text('${a.action} · ${fmt.format(a.at)}', style: TextStyle(color: c.textMuted))),
              ]),
      ),
      const SizedBox(height: 20),
      const SectionHeader(title: 'Danger zone'),
      AppCard(
        borderColor: c.danger.withValues(alpha: 0.5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Erase everything on this device: accounts, emails, channels, projects, finances, settings and vault items. The catalog is re-seeded afterwards. Make a backup first.', style: context.text.bodyMedium),
          const SizedBox(height: 12),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: c.danger),
            onPressed: () async {
              if (!await confirmTyped(context, title: 'Erase all data?', message: 'This deletes every record including encrypted vault items. Type ERASE to continue.', word: 'ERASE')) return;
              try {
                await ref.read(databaseProvider).clearAll();
                await ref.read(catalogServiceProvider).ensureSeeded();
                if (context.mounted) {
                  showToast(context, 'All data erased');
                  context.go(Routes.home);
                }
              } catch (e) {
                if (context.mounted) showToast(context, friendlyError(e), error: true);
              }
            },
            icon: const Icon(Icons.delete_forever_outlined, size: 18),
            label: const Text('Erase all data'),
          ),
        ]),
      ),
    ]);
  }
}

// ------------------------------------------------------------------- About
class _AboutSection extends StatelessWidget {
  const _AboutSection();
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SectionHeader(title: 'About'),
      AppCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(borderRadius: BorderRadius.circular(13), gradient: LinearGradient(colors: [c.accent, c.accentPink])), child: const Icon(Icons.hub_rounded, color: Colors.white)),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('SYHU Account Hub', style: context.text.titleLarge),
              Text('Version 0.1.0 · by SYHU LABS', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
            ]),
          ]),
          const SizedBox(height: 16),
          const Text('A private, local-first manager for your digital ecosystem: platforms, accounts, email identities, YouTube channels, projects, banking metadata, subscriptions and an encrypted vault. No online account, no telemetry, no cloud sync.'),
          const SizedBox(height: 10),
          Text('Security note: secrets use AES-256-GCM with keys in the OS keychain and standard libraries (package:cryptography). This application has not been independently security-audited.', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
          const SizedBox(height: 10),
          Text('Built with Flutter, Riverpod, drift/SQLite, flutter_secure_storage, local_auth, flutter_local_notifications, fl_chart and Simple Icons (CC0 brand glyphs). Brand names and logos belong to their owners.', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
        ]),
      ),
    ]);
  }
}
