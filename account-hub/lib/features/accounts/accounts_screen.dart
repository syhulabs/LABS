import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/json_list.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/account_repository.dart';
import '../../domain/enums.dart';
import '../../shared/widgets/account_tile.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/page_scaffold.dart';
import '../../shared/widgets/platform_logo.dart';
import '../../shared/widgets/status_chip.dart';
import '../../shared/widgets/toast.dart';
import 'account_form.dart';
import 'email_form.dart';

/// Accounts & Emails: every account across platforms, the reusable email
/// identities behind them, and the archive.
class AccountsScreen extends ConsumerStatefulWidget {
  const AccountsScreen({super.key, this.initialTab});
  final String? initialTab;
  @override
  ConsumerState<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends ConsumerState<AccountsScreen> {
  static const _tabs = ['accounts', 'emails', 'archived'];
  late int _tab = _tabs.indexOf(widget.initialTab ?? 'accounts').clamp(0, 2);
  String _q = '';
  Classification? _classification;
  AccountStatus? _status;
  String? _category;

  @override
  void didUpdateWidget(covariant AccountsScreen old) {
    super.didUpdateWidget(old);
    if (old.initialTab != widget.initialTab && widget.initialTab != null) {
      _tab = _tabs.indexOf(widget.initialTab!).clamp(0, 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountsProvider).value ?? const <AccountView>[];
    final emails = ref.watch(emailsProvider).value ?? const <EmailIdentity>[];
    return PageScaffold(
      title: 'Accounts & Emails',
      subtitle: '${accounts.length} account${accounts.length == 1 ? '' : 's'} · ${emails.length} email identit${emails.length == 1 ? 'y' : 'ies'}',
      actions: [
        OutlinedButton.icon(onPressed: () => showEmailForm(context, ref), icon: const Icon(Icons.alternate_email, size: 18), label: const Text('Add email')),
        FilledButton.icon(onPressed: () => showAccountForm(context, ref), icon: const Icon(Icons.person_add_alt, size: 18), label: const Text('Add account')),
      ],
      children: [
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 0, label: Text('Accounts'), icon: Icon(Icons.people_outline, size: 16)),
            ButtonSegment(value: 1, label: Text('Emails'), icon: Icon(Icons.alternate_email, size: 16)),
            ButtonSegment(value: 2, label: Text('Archived'), icon: Icon(Icons.archive_outlined, size: 16)),
          ],
          selected: {_tab},
          onSelectionChanged: (s) => setState(() => _tab = s.first),
        ),
        const SizedBox(height: 18),
        switch (_tab) { 0 => _accountsTab(accounts), 1 => _emailsTab(emails), _ => const _ArchivedTab() },
      ],
    );
  }

  Widget _accountsTab(List<AccountView> all) {
    final c = context.colors;
    final catalog = ref.watch(catalogServiceProvider);
    final usedCategories = <String>{};
    for (final a in all) {
      usedCategories.addAll(decodeStringList(a.platform.categories));
    }
    final filtered = AccountRepository.filter(all, query: _q, classification: _classification, category: _category).where((a) => _status == null || a.account.status == _status!.name).toList();
    if (all.isEmpty) {
      return AppCard(
        child: EmptyState(
          compact: true,
          icon: Icons.people_outline,
          title: 'No accounts yet',
          message: 'Add your first account. Each platform can hold several (Personal, Studio, Business…) and each can reuse one of your email identities.',
          actionLabel: 'Add account',
          onAction: () => showAccountForm(context, ref),
          secondaryLabel: 'Browse Explore',
          onSecondary: () => context.go(Routes.explore),
        ),
      );
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      TextField(decoration: const InputDecoration(hintText: 'Search accounts by platform, label, username or email…', prefixIcon: Icon(Icons.search, size: 18)), onChanged: (v) => setState(() => _q = v)),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
        for (final cl in Classification.values)
          FilterChip(label: Text(cl.label), selected: _classification == cl, onSelected: (v) => setState(() => _classification = v ? cl : null)),
        const SizedBox(width: 4),
        DropdownButton<AccountStatus?>(
          value: _status,
          hint: const Text('Any status'),
          underline: const SizedBox.shrink(),
          dropdownColor: c.surfaceAlt,
          items: [
            const DropdownMenuItem<AccountStatus?>(value: null, child: Text('Any status')),
            for (final s in AccountStatus.values) DropdownMenuItem<AccountStatus?>(value: s, child: Text(s.label)),
          ],
          onChanged: (v) => setState(() => _status = v),
        ),
        DropdownButton<String?>(
          value: _category,
          hint: const Text('Any category'),
          underline: const SizedBox.shrink(),
          dropdownColor: c.surfaceAlt,
          items: [
            const DropdownMenuItem<String?>(value: null, child: Text('Any category')),
            for (final cat in catalog.categories.where((cat) => usedCategories.contains(cat.id))) DropdownMenuItem<String?>(value: cat.id, child: Text(cat.label)),
          ],
          onChanged: (v) => setState(() => _category = v),
        ),
        if (_classification != null || _status != null || _category != null || _q.isNotEmpty)
          TextButton.icon(onPressed: () => setState(() { _classification = null; _status = null; _category = null; _q = ''; }), icon: const Icon(Icons.clear, size: 14), label: const Text('Clear filters')),
      ]),
      const SizedBox(height: 14),
      if (filtered.isEmpty)
        const EmptyState(compact: true, icon: Icons.filter_alt_off, title: 'No accounts match', message: 'Try a different search or clear the filters.')
      else ...[
        Text('${filtered.length} of ${all.length}', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
        const SizedBox(height: 8),
        for (final a in filtered) Padding(padding: const EdgeInsets.only(bottom: 8), child: AccountTile(view: a)),
      ],
    ]);
  }

  Widget _emailsTab(List<EmailIdentity> all) {
    final c = context.colors;
    final q = _q.trim().toLowerCase();
    final filtered = all.where((e) {
      if (_classification != null && e.classification != _classification!.name) return false;
      if (q.isEmpty) return true;
      return e.address.toLowerCase().contains(q) || (e.displayName ?? '').toLowerCase().contains(q) || (e.provider ?? '').toLowerCase().contains(q) || (e.purpose ?? '').toLowerCase().contains(q);
    }).toList();
    if (all.isEmpty) {
      return AppCard(
        child: EmptyState(
          compact: true,
          icon: Icons.alternate_email,
          title: 'No email identities yet',
          message: 'Add each address you sign up with once. Then link it to any number of accounts and channels and look up everything connected to it.',
          actionLabel: 'Add email',
          onAction: () => showEmailForm(context, ref),
        ),
      );
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      TextField(decoration: const InputDecoration(hintText: 'Search emails…', prefixIcon: Icon(Icons.search, size: 18)), onChanged: (v) => setState(() => _q = v)),
      const SizedBox(height: 10),
      Wrap(spacing: 8, children: [
        for (final cl in Classification.values) FilterChip(label: Text(cl.label), selected: _classification == cl, onSelected: (v) => setState(() => _classification = v ? cl : null)),
      ]),
      const SizedBox(height: 14),
      if (filtered.isEmpty)
        const EmptyState(compact: true, icon: Icons.filter_alt_off, title: 'No emails match', message: 'Try a different search.')
      else
        ResponsiveGrid(minTileWidth: 340, children: [for (final e in filtered) _EmailCard(email: e)]),
      const SizedBox(height: 12),
      Text('Tip: open an email to see every account, channel, organization and project connected to it.', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
    ]);
  }
}

class _EmailCard extends ConsumerWidget {
  const _EmailCard({required this.email});
  final EmailIdentity email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final usage = ref.watch(emailUsageProvider(email.id)).value;
    final repo = ref.read(emailRepositoryProvider);
    final count = usage?.total;
    return AppCard(
      padding: const EdgeInsets.all(14),
      onTap: () => context.push(Routes.email(email.id)),
      child: Row(children: [
        MonogramAvatar(text: email.address, seed: email.id, size: 42, icon: Icons.alternate_email),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Flexible(child: Text(email.address, style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
            if (email.isFavorite) Padding(padding: const EdgeInsets.only(left: 6), child: Icon(Icons.star_rounded, size: 14, color: c.warning)),
          ]),
          const SizedBox(height: 2),
          Text([if (email.displayName != null) email.displayName!, if (email.provider != null) email.provider!, if (email.purpose != null) email.purpose!].join(' · '), style: context.text.bodySmall?.copyWith(color: c.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Wrap(spacing: 6, runSpacing: 4, children: [
            ClassificationChip(email.classification),
            StatusChip(statusLabel(email.status), color: statusColor(context, email.status)),
            StatusChip(count == null ? '…' : '$count connected', color: (count ?? 0) > 0 ? c.accent : c.textMuted, icon: Icons.hub_outlined),
          ]),
        ])),
        PopupMenuButton<String>(
          tooltip: 'Actions',
          onSelected: (v) async {
            switch (v) {
              case 'edit':
                await showEmailForm(context, ref, existing: email);
              case 'add':
                await showAccountForm(context, ref, presetEmailId: email.id);
              case 'fav':
                await repo.setFavorite(email.id, !email.isFavorite);
              case 'archive':
                await repo.setArchived(email.id, true);
                if (context.mounted) showToast(context, 'Email archived');
              case 'delete':
                if (await confirmDestructive(context, title: 'Delete ${email.address}?', message: 'Accounts and channels that use it are kept, but they will no longer be linked to this email.')) {
                  await repo.delete(email.id);
                }
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'edit', child: ListTile(dense: true, leading: Icon(Icons.edit_outlined, size: 18), title: Text('Edit'))),
            const PopupMenuItem(value: 'add', child: ListTile(dense: true, leading: Icon(Icons.person_add_alt, size: 18), title: Text('Add account with this email'))),
            PopupMenuItem(value: 'fav', child: ListTile(dense: true, leading: Icon(email.isFavorite ? Icons.star_outline : Icons.star, size: 18), title: Text(email.isFavorite ? 'Remove favorite' : 'Favorite'))),
            const PopupMenuItem(value: 'archive', child: ListTile(dense: true, leading: Icon(Icons.archive_outlined, size: 18), title: Text('Archive'))),
            const PopupMenuItem(value: 'delete', child: ListTile(dense: true, leading: Icon(Icons.delete_outline, size: 18), title: Text('Delete'))),
          ],
        ),
      ]),
    );
  }
}

class _ArchivedTab extends ConsumerWidget {
  const _ArchivedTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final accounts = ref.watch(archivedAccountsProvider).value ?? const <AccountView>[];
    final emails = ref.watch(archivedEmailsProvider).value ?? const <EmailIdentity>[];
    final accRepo = ref.read(accountRepositoryProvider);
    final emailRepo = ref.read(emailRepositoryProvider);
    if (accounts.isEmpty && emails.isEmpty) {
      return const AppCard(child: EmptyState(compact: true, icon: Icons.archive_outlined, title: 'Archive is empty', message: 'Archived accounts and emails land here. Restore them any time or delete them for good.'));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (accounts.isNotEmpty) ...[
        Text('Archived accounts (${accounts.length})', style: context.text.titleMedium),
        const SizedBox(height: 8),
        for (final a in accounts)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              onTap: () => context.push(Routes.account(a.account.id)),
              child: Row(children: [
                PlatformLogo(platform: a.platform, size: 36),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${a.platform.name} · ${a.account.accountName}', style: context.text.titleSmall),
                  Text(a.email?.address ?? a.account.username ?? '', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
                ])),
                TextButton.icon(onPressed: () => accRepo.setArchived(a.account.id, false), icon: const Icon(Icons.unarchive_outlined, size: 16), label: const Text('Restore')),
                IconButton(
                  tooltip: 'Delete permanently',
                  icon: Icon(Icons.delete_outline, color: c.danger, size: 18),
                  onPressed: () async {
                    if (await confirmDestructive(context, title: 'Delete account?', message: 'Permanently removes "${a.account.accountName}" on ${a.platform.name}.')) await accRepo.delete(a.account.id);
                  },
                ),
              ]),
            ),
          ),
        const SizedBox(height: 16),
      ],
      if (emails.isNotEmpty) ...[
        Text('Archived emails (${emails.length})', style: context.text.titleMedium),
        const SizedBox(height: 8),
        for (final e in emails)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              onTap: () => context.push(Routes.email(e.id)),
              child: Row(children: [
                MonogramAvatar(text: e.address, seed: e.id, size: 36, icon: Icons.alternate_email),
                const SizedBox(width: 12),
                Expanded(child: Text(e.address, style: context.text.titleSmall)),
                TextButton.icon(onPressed: () => emailRepo.setArchived(e.id, false), icon: const Icon(Icons.unarchive_outlined, size: 16), label: const Text('Restore')),
                IconButton(
                  tooltip: 'Delete permanently',
                  icon: Icon(Icons.delete_outline, color: c.danger, size: 18),
                  onPressed: () async {
                    if (await confirmDestructive(context, title: 'Delete ${e.address}?', message: 'Accounts using it are kept but detached.')) await emailRepo.delete(e.id);
                  },
                ),
              ]),
            ),
          ),
      ],
    ]);
  }
}
