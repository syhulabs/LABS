import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/launch.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/secure/vault_repository.dart';
import '../../domain/enums.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/form_sheet.dart';
import '../../shared/widgets/page_scaffold.dart';
import '../../shared/widgets/status_chip.dart';
import '../../shared/widgets/toast.dart';

const _managers = ['1Password', 'Bitwarden', 'Proton Pass', 'iCloud Keychain', 'Google Password Manager', 'KeePassXC', 'Dashlane', 'Other'];

/// Encrypted vault (AES-GCM, key in the OS keychain) plus references to
/// where credentials live in an external password manager.
class VaultScreen extends ConsumerStatefulWidget {
  const VaultScreen({super.key});
  @override
  ConsumerState<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends ConsumerState<VaultScreen> {
  int _tab = 0;
  SecureItemKind? _kind;
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final items = ref.watch(vaultItemsProvider).value ?? const <SecureItem>[];
    final refs = ref.watch(credentialRefsProvider).value ?? const <CredentialReference>[];
    final lock = ref.watch(appLockProvider);
    return PageScaffold(
      title: 'Secure Vault',
      subtitle: 'Secrets are encrypted on this device with AES-256-GCM. The key never leaves the OS keychain.',
      actions: [
        if (_tab == 0)
          FilledButton.icon(onPressed: () => showVaultItemForm(context, ref), icon: const Icon(Icons.add, size: 18), label: const Text('Add secret'))
        else
          FilledButton.icon(onPressed: () => showCredentialRefForm(context, ref), icon: const Icon(Icons.add, size: 18), label: const Text('Add reference')),
      ],
      children: [
        if (!lock.enabled)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              borderColor: c.warning.withValues(alpha: 0.6),
              child: Row(children: [
                Icon(Icons.lock_open, color: c.warning),
                const SizedBox(width: 12),
                Expanded(child: Text('App Lock is off. Anyone with this device can open the vault.', style: context.text.bodyMedium)),
                TextButton(onPressed: () => context.go('${Routes.settings}?section=security'), child: const Text('Turn on App Lock')),
              ]),
            ),
          ),
        SegmentedButton<int>(
          segments: [
            ButtonSegment(value: 0, label: Text('Vault items (${items.length})'), icon: const Icon(Icons.lock_outline, size: 16)),
            ButtonSegment(value: 1, label: Text('Credential references (${refs.length})'), icon: const Icon(Icons.key_outlined, size: 16)),
          ],
          selected: {_tab},
          onSelectionChanged: (s) => setState(() => _tab = s.first),
        ),
        const SizedBox(height: 18),
        if (_tab == 0) _itemsTab(items) else _refsTab(refs),
      ],
    );
  }

  Widget _itemsTab(List<SecureItem> all) {
    final c = context.colors;
    if (all.isEmpty) {
      return AppCard(
        child: EmptyState(
          compact: true,
          icon: Icons.lock_outline,
          title: 'The vault is empty',
          message: 'Keep API keys, recovery codes, a full bank account number or a secure note here. Everything is encrypted with AES-GCM using a key held in the OS keychain. For everyday website passwords a dedicated password manager is the better home; add a credential reference instead.',
          actionLabel: 'Add secret',
          onAction: () => showVaultItemForm(context, ref),
          secondaryLabel: 'Add credential reference',
          onSecondary: () => showCredentialRefForm(context, ref),
        ),
      );
    }
    final q = _q.trim().toLowerCase();
    final filtered = all.where((i) => (_kind == null || i.kind == _kind!.name) && (q.isEmpty || i.title.toLowerCase().contains(q))).toList();
    final usedKinds = all.map((i) => i.kind).toSet();
    final fmt = DateFormat.yMMMd();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      TextField(decoration: const InputDecoration(hintText: 'Filter by title… (secret values are never searched)', prefixIcon: Icon(Icons.search, size: 18)), onChanged: (v) => setState(() => _q = v)),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: [
        ChoiceChip(label: const Text('All'), selected: _kind == null, onSelected: (_) => setState(() => _kind = null)),
        for (final k in SecureItemKind.values.where((k) => usedKinds.contains(k.name))) ChoiceChip(label: Text(k.label), selected: _kind == k, onSelected: (_) => setState(() => _kind = _kind == k ? null : k)),
      ]),
      const SizedBox(height: 14),
      if (filtered.isEmpty)
        const EmptyState(compact: true, icon: Icons.filter_alt_off, title: 'No items match', message: 'Try another title or kind.')
      else
        ResponsiveGrid(minTileWidth: 320, children: [
          for (final i in filtered)
            AppCard(
              padding: const EdgeInsets.all(14),
              onTap: () => _showItem(i),
              child: Row(children: [
                Container(width: 40, height: 40, decoration: BoxDecoration(color: c.accent.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(12)), child: Icon(_iconFor(i.kind), color: c.accent, size: 20)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(i.title, style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text('${enumFromName(SecureItemKind.values, i.kind, SecureItemKind.other).label} · updated ${fmt.format(i.updatedAt)}${i.lastViewedAt == null ? '' : ' · viewed ${fmt.format(i.lastViewedAt!)}'}', style: context.text.bodySmall?.copyWith(color: c.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
                ])),
                const Icon(Icons.chevron_right),
              ]),
            ),
        ]),
    ]);
  }

  Widget _refsTab(List<CredentialReference> refs) {
    final c = context.colors;
    if (refs.isEmpty) {
      return AppCard(
        child: EmptyState(
          compact: true,
          icon: Icons.key_outlined,
          title: 'No credential references',
          message: 'A reference records where a login lives: "1Password · Work vault · GitHub". Link it from an account so you always know which manager holds the password, without copying the password into this app.',
          actionLabel: 'Add reference',
          onAction: () => showCredentialRefForm(context, ref),
        ),
      );
    }
    final repo = ref.read(vaultRepositoryProvider);
    return ResponsiveGrid(minTileWidth: 340, children: [
      for (final r in refs)
        AppCard(
          padding: const EdgeInsets.all(14),
          onTap: () => showCredentialRefForm(context, ref, existing: r),
          child: Row(children: [
            Icon(Icons.key_outlined, color: c.accentBlue),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(r.label, style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text([if (r.manager != null) r.manager!, if (r.usernameHint != null) 'user: ${r.usernameHint}', if (r.locator != null) r.locator!].join(' · '), style: context.text.bodySmall?.copyWith(color: c.textMuted), maxLines: 2, overflow: TextOverflow.ellipsis),
              if (r.vaultItemId != null) Padding(padding: const EdgeInsets.only(top: 4), child: StatusChip('Linked vault item', color: c.accent, icon: Icons.lock_outline)),
            ])),
            PopupMenuButton<String>(
              tooltip: 'Actions',
              onSelected: (v) async {
                switch (v) {
                  case 'open':
                    await openUrl(context, r.locator);
                  case 'edit':
                    await showCredentialRefForm(context, ref, existing: r);
                  case 'delete':
                    if (await confirmDestructive(context, title: 'Delete reference?', message: 'Accounts pointing at "${r.label}" lose the reference. No secret is affected.')) await repo.deleteCredentialRef(r.id);
                }
              },
              itemBuilder: (_) => [
                if (r.locator != null && r.locator!.contains('://')) const PopupMenuItem(value: 'open', child: ListTile(dense: true, leading: Icon(Icons.open_in_new, size: 18), title: Text('Open in password manager'))),
                const PopupMenuItem(value: 'edit', child: ListTile(dense: true, leading: Icon(Icons.edit_outlined, size: 18), title: Text('Edit'))),
                const PopupMenuItem(value: 'delete', child: ListTile(dense: true, leading: Icon(Icons.delete_outline, size: 18), title: Text('Delete'))),
              ],
            ),
          ]),
        ),
    ]);
  }

  Future<void> _showItem(SecureItem item) => showFormSheet<void>(context, title: item.title, maxWidth: 520, builder: (ctx, close) => _VaultItemDetail(itemId: item.id, close: close));

  static IconData _iconFor(String kind) => switch (enumFromName(SecureItemKind.values, kind, SecureItemKind.other)) {
        SecureItemKind.password => Icons.password,
        SecureItemKind.apiKey => Icons.vpn_key_outlined,
        SecureItemKind.secureNote => Icons.sticky_note_2_outlined,
        SecureItemKind.recoveryCodes => Icons.qr_code_2,
        SecureItemKind.bankAccountNumber => Icons.account_balance_outlined,
        SecureItemKind.document => Icons.description_outlined,
        SecureItemKind.other => Icons.lock_outline,
      };
}

/// Detail sheet: metadata always, secret only after an explicit Reveal, hidden
/// again automatically after 30 seconds.
class _VaultItemDetail extends ConsumerStatefulWidget {
  const _VaultItemDetail({required this.itemId, required this.close});
  final String itemId;
  final void Function([void]) close;
  @override
  ConsumerState<_VaultItemDetail> createState() => _VaultItemDetailState();
}

class _VaultItemDetailState extends ConsumerState<_VaultItemDetail> {
  VaultSecret? _secret;
  bool _show = false;
  bool _busy = false;
  int _remaining = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _secret = null;
    super.dispose();
  }

  Future<void> _reveal() async {
    setState(() => _busy = true);
    try {
      final s = await ref.read(vaultRepositoryProvider).reveal(widget.itemId);
      if (!mounted) return;
      setState(() {
        _secret = s;
        _show = false;
        _remaining = 30;
      });
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) return t.cancel();
        setState(() => _remaining--);
        if (_remaining <= 0) {
          t.cancel();
          setState(() {
            _secret = null;
            _show = false;
          });
        }
      });
    } catch (e) {
      if (mounted) showToast(context, 'Could not decrypt this item', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _copy(String value) async {
    final secs = (ref.read(settingsProvider).value ?? const <String, dynamic>{}).clipboardClearSeconds;
    await ref.read(clipboardServiceProvider).copySensitive(value);
    if (mounted) showToast(context, secs > 0 ? 'Copied · clears in $secs s' : 'Copied');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final items = ref.watch(vaultItemsProvider).value ?? const <SecureItem>[];
    final item = items.where((i) => i.id == widget.itemId).firstOrNull;
    if (item == null) return const Padding(padding: EdgeInsets.all(24), child: Text('This item no longer exists.'));
    final fmt = DateFormat.yMMMd().add_jm();
    final s = _secret;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Wrap(spacing: 6, runSpacing: 6, children: [
        StatusChip(enumFromName(SecureItemKind.values, item.kind, SecureItemKind.other).label, color: c.accent, dense: false),
        StatusChip('AES-256-GCM', color: c.success, icon: Icons.verified_user_outlined, dense: false),
      ]),
      const SizedBox(height: 12),
      Text('Created ${fmt.format(item.createdAt)} · updated ${fmt.format(item.updatedAt)}${item.lastViewedAt == null ? '' : ' · last viewed ${fmt.format(item.lastViewedAt!)}'}', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
      const SizedBox(height: 18),
      if (s == null)
        FilledButton.icon(onPressed: _busy ? null : _reveal, icon: const Icon(Icons.visibility_outlined, size: 18), label: const Text('Reveal secret'))
      else ...[
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: c.surfaceAlt, borderRadius: BorderRadius.circular(AppTheme.radiusSmall), border: Border.all(color: c.border)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: _show
                    ? SelectableText(s.value, style: const TextStyle(fontFamily: 'monospace'))
                    : Text('•' * s.value.length.clamp(8, 32), style: TextStyle(letterSpacing: 2, color: c.text)),
              ),
              IconButton(tooltip: _show ? 'Hide' : 'Show', icon: Icon(_show ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18), onPressed: () => setState(() => _show = !_show)),
              IconButton(tooltip: 'Copy secret', icon: const Icon(Icons.copy, size: 18), onPressed: () => _copy(s.value)),
            ]),
            if (s.username != null) Padding(padding: const EdgeInsets.only(top: 6), child: Row(children: [Text('Username: ', style: TextStyle(color: c.textMuted)), SelectableText(s.username!), IconButton(tooltip: 'Copy username', iconSize: 16, icon: const Icon(Icons.copy), onPressed: () => ref.read(clipboardServiceProvider).copyPlain(s.username!))])),
            if (s.url != null) Padding(padding: const EdgeInsets.only(top: 2), child: InkWell(onTap: () => openUrl(context, s.url), child: Text(s.url!, style: TextStyle(color: c.accent)))),
            if (s.notes != null) Padding(padding: const EdgeInsets.only(top: 6), child: SelectableText(s.notes!)),
          ]),
        ),
        const SizedBox(height: 6),
        Text('Hides automatically in $_remaining s.', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
      ],
      const SizedBox(height: 18),
      Row(children: [
        TextButton.icon(
          style: TextButton.styleFrom(foregroundColor: c.danger),
          onPressed: () async {
            if (!await confirmDestructive(context, title: 'Delete "${item.title}"?', message: 'The encrypted value is removed permanently. Records that referenced it are detached.')) return;
            await ref.read(vaultRepositoryProvider).delete(item.id);
            if (mounted) widget.close();
          },
          icon: const Icon(Icons.delete_outline, size: 16),
          label: const Text('Delete'),
        ),
        const Spacer(),
        OutlinedButton.icon(
          onPressed: () async {
            widget.close();
            await showVaultItemForm(context, ref, existing: item);
          },
          icon: const Icon(Icons.edit_outlined, size: 16),
          label: const Text('Edit'),
        ),
        const SizedBox(width: 8),
        FilledButton(onPressed: widget.close, child: const Text('Done')),
      ]),
    ]);
  }
}

/// Create or edit a vault item. When editing, the secret is only re-encrypted
/// if the user types a new value.
Future<void> showVaultItemForm(BuildContext context, WidgetRef ref, {SecureItem? existing}) async {
  final title = TextEditingController(text: existing?.title ?? '');
  final value = TextEditingController();
  final username = TextEditingController();
  final url = TextEditingController();
  final notes = TextEditingController();
  var kind = enumFromName(SecureItemKind.values, existing?.kind, SecureItemKind.apiKey);
  var show = false;
  final key = GlobalKey<FormState>();
  await showFormSheet<void>(context, title: existing == null ? 'Add secret to vault' : 'Edit vault item', maxWidth: 520, builder: (ctx, close) {
    return StatefulBuilder(builder: (ctx, setState) {
      Future<void> save() async {
        if (!key.currentState!.validate()) return;
        final newSecret = value.text.isEmpty
            ? null
            : VaultSecret(value: value.text, username: username.text.trim().isEmpty ? null : username.text.trim(), url: url.text.trim().isEmpty ? null : url.text.trim(), notes: notes.text.trim().isEmpty ? null : notes.text.trim());
        try {
          final repo = ref.read(vaultRepositoryProvider);
          if (existing == null) {
            await repo.create(title: title.text, kind: kind, secret: newSecret!);
          } else {
            await repo.update(existing.id, title: title.text, kind: kind, secret: newSecret);
          }
          value.clear();
          close();
          if (context.mounted) showToast(context, existing == null ? 'Secret stored in the vault' : 'Vault item updated');
        } catch (e) {
          if (ctx.mounted) showToast(ctx, friendlyError(e), error: true);
        }
      }

      return Form(
        key: key,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          AppTextField(controller: title, label: 'Title', hint: 'OpenAI API key, HDFC account number…', autofocus: true, validator: (v) => requiredValidator(v, 'Title')),
          AppDropdown<SecureItemKind>(label: 'Kind', value: kind, items: [for (final k in SecureItemKind.values) (k, k.label)], onChanged: (v) => setState(() => kind = v ?? kind)),
          FormSectionTitle(existing == null ? 'Secret' : 'Replace secret', hint: existing == null ? 'Encrypted before it touches the database.' : 'Leave empty to keep the current encrypted value.'),
          AppTextField(
            controller: value,
            label: 'Secret value',
            obscure: !show,
            maxLines: show ? 4 : 1,
            validator: (v) => existing == null && (v == null || v.isEmpty) ? 'Enter the secret value' : null,
            suffix: IconButton(tooltip: show ? 'Hide' : 'Show', icon: Icon(show ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18), onPressed: () => setState(() => show = !show)),
          ),
          Row(children: [
            Expanded(child: AppTextField(controller: username, label: 'Username (optional)')),
            const SizedBox(width: 10),
            Expanded(child: AppTextField(controller: url, label: 'URL (optional)', keyboardType: TextInputType.url)),
          ]),
          AppTextField(controller: notes, label: 'Notes (optional, encrypted too)', maxLines: 2),
          FormActions(onCancel: close, onSave: save, saveLabel: existing == null ? 'Encrypt & save' : 'Save'),
        ]),
      );
    });
  });
}

/// Create or edit a credential reference (pointer to a password manager item).
Future<void> showCredentialRefForm(BuildContext context, WidgetRef ref, {CredentialReference? existing}) async {
  final label = TextEditingController(text: existing?.label ?? '');
  final manager = TextEditingController(text: existing?.manager ?? '');
  final locator = TextEditingController(text: existing?.locator ?? '');
  final hint = TextEditingController(text: existing?.usernameHint ?? '');
  final notes = TextEditingController(text: existing?.notes ?? '');
  String? vaultItemId = existing?.vaultItemId;
  final key = GlobalKey<FormState>();
  await showFormSheet<void>(context, title: existing == null ? 'Add credential reference' : 'Edit credential reference', maxWidth: 520, builder: (ctx, close) {
    return StatefulBuilder(builder: (ctx, setState) {
      final items = ref.watch(vaultItemsProvider).value ?? const <SecureItem>[];
      return Form(
        key: key,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Records where a password is kept. The password itself stays in your password manager.', style: ctx.text.bodySmall?.copyWith(color: ctx.colors.textMuted)),
          const SizedBox(height: 12),
          AppTextField(controller: label, label: 'Label', hint: 'GitHub login, Studio Google account…', autofocus: true, validator: (v) => requiredValidator(v, 'Label')),
          AppTextField(controller: manager, label: 'Password manager', hint: 'Pick below or type your own'),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Wrap(spacing: 6, runSpacing: 6, children: [for (final m in _managers) ActionChip(label: Text(m), onPressed: () => setState(() => manager.text = m))]),
          ),
          AppTextField(controller: locator, label: 'Item locator', hint: 'Deep link (onepassword://…) or vault / item name'),
          AppTextField(controller: hint, label: 'Username hint', hint: 'e.g. studio@… (not the password)'),
          AppDropdown<String>(label: 'Linked vault item (optional)', value: vaultItemId, allowNull: true, nullLabel: 'None', items: [for (final i in items) (i.id, i.title)], onChanged: (v) => setState(() => vaultItemId = v)),
          AppTextField(controller: notes, label: 'Notes', maxLines: 2),
          FormActions(
            onCancel: close,
            destructiveLabel: existing == null ? null : 'Delete',
            onDestructive: existing == null ? null : () async {
              if (!await confirmDestructive(ctx, title: 'Delete reference?', message: 'Accounts pointing at it lose the reference.')) return;
              await ref.read(vaultRepositoryProvider).deleteCredentialRef(existing.id);
              close();
            },
            onSave: () async {
              if (!key.currentState!.validate()) return;
              try {
                await ref.read(vaultRepositoryProvider).upsertCredentialRef(id: existing?.id, label: label.text, manager: manager.text, locator: locator.text, usernameHint: hint.text, notes: notes.text, vaultItemId: vaultItemId);
                close();
              } catch (e) {
                if (ctx.mounted) showToast(ctx, friendlyError(e), error: true);
              }
            },
          ),
        ]),
      );
    });
  });
}

