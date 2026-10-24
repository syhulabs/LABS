import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../data/repositories/account_repository.dart';
import '../../domain/enums.dart';
import '../../shared/widgets/account_tile.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/page_scaffold.dart';
import '../../shared/widgets/platform_logo.dart';
import '../../shared/widgets/relations_panel.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/status_chip.dart';
import '../../shared/widgets/toast.dart';
import 'account_form.dart';
import 'email_form.dart';

final _emailByIdProvider = StreamProvider.family((ref, String id) => ref.watch(emailRepositoryProvider).watchById(id));

/// One email identity and everything connected to it (reverse lookup).
class EmailDetailScreen extends ConsumerWidget {
  const EmailDetailScreen({super.key, required this.emailId});
  final String emailId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final email = ref.watch(_emailByIdProvider(emailId)).value;
    if (email == null) {
      return Scaffold(appBar: AppBar(backgroundColor: c.background, leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go(Routes.accounts))), body: const Center(child: Text('Email identity not found')));
    }
    final usage = ref.watch(emailUsageProvider(emailId)).value;
    final repo = ref.read(emailRepositoryProvider);
    final accounts = usage == null ? const <AccountView>[] : [for (final (a, p) in usage.accounts) AccountView(a, p, email)];
    return Scaffold(
      appBar: AppBar(backgroundColor: c.background, title: Text(email.address), leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go('${Routes.accounts}?tab=emails'))),
      body: PageScaffold(
        title: email.address,
        header: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          MonogramAvatar(text: email.address, seed: email.id, size: 72, icon: Icons.alternate_email),
          const SizedBox(width: 18),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SelectableText(email.address, style: context.text.headlineSmall),
            if (email.displayName != null || email.provider != null)
              Padding(padding: const EdgeInsets.only(top: 4), child: Text([if (email.displayName != null) email.displayName!, if (email.provider != null) email.provider!].join(' · '), style: context.text.bodyMedium?.copyWith(color: c.textMuted))),
            const SizedBox(height: 8),
            Wrap(spacing: 6, runSpacing: 6, children: [
              ClassificationChip(email.classification),
              StatusChip(statusLabel(email.status), color: statusColor(context, email.status), dense: false),
              if (email.archivedAt != null) StatusChip('Archived', color: c.warning, dense: false),
              if (usage != null) StatusChip('${usage.total} connected', color: c.accent, icon: Icons.hub_outlined, dense: false),
            ]),
          ])),
        ]),
        children: [
          Wrap(spacing: 10, runSpacing: 10, children: [
            FilledButton.icon(onPressed: () => showAccountForm(context, ref, presetEmailId: emailId), icon: const Icon(Icons.person_add_alt, size: 18), label: const Text('Add account with this email')),
            OutlinedButton.icon(onPressed: () => showEmailForm(context, ref, existing: email), icon: const Icon(Icons.edit_outlined, size: 18), label: const Text('Edit')),
            OutlinedButton.icon(
              onPressed: () => repo.setFavorite(email.id, !email.isFavorite),
              icon: Icon(email.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded, size: 18, color: email.isFavorite ? c.warning : null),
              label: Text(email.isFavorite ? 'Favorited' : 'Favorite'),
            ),
            OutlinedButton.icon(
              onPressed: () => repo.setArchived(email.id, email.archivedAt == null),
              icon: Icon(email.archivedAt == null ? Icons.archive_outlined : Icons.unarchive_outlined, size: 18),
              label: Text(email.archivedAt == null ? 'Archive' : 'Restore'),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: c.danger),
              onPressed: () async {
                if (!await confirmDestructive(context, title: 'Delete ${email.address}?', message: 'Accounts and channels that use it are kept but detached from this email.')) return;
                await repo.delete(email.id);
                if (context.mounted) {
                  showToast(context, 'Email identity deleted');
                  context.canPop() ? context.pop() : context.go('${Routes.accounts}?tab=emails');
                }
              },
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Delete'),
            ),
          ]),
          const SizedBox(height: 22),
          if (email.purpose != null || email.recoveryNotes != null || email.notes != null)
            AppCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (email.purpose != null) _row(context, 'Purpose', email.purpose!),
                if (email.recoveryNotes != null) _row(context, 'Recovery notes', email.recoveryNotes!),
                if (email.notes != null) _row(context, 'Notes', email.notes!),
              ]),
            ),
          const SizedBox(height: 18),
          SectionHeader(title: 'Accounts using this email', subtitle: accounts.isEmpty ? 'None yet' : '${accounts.length} account${accounts.length == 1 ? '' : 's'}'),
          if (accounts.isEmpty)
            Text('No accounts are linked to this address yet.', style: context.text.bodySmall?.copyWith(color: c.textMuted))
          else
            for (final a in accounts) Padding(padding: const EdgeInsets.only(bottom: 8), child: AccountTile(view: a)),
          if (usage != null) ...[
            if (usage.ownedChannels.isNotEmpty) ...[
              const SizedBox(height: 18),
              const SectionHeader(title: 'YouTube channels owned'),
              Wrap(spacing: 8, runSpacing: 8, children: [for (final ch in usage.ownedChannels) ActionChip(avatar: const Icon(Icons.play_circle_outline, size: 14), label: Text(ch.handle == null ? ch.name : '${ch.name} · ${ch.handle}'), onPressed: () => context.push(Routes.channel(ch.id)))]),
            ],
            if (usage.managedChannels.isNotEmpty) ...[
              const SizedBox(height: 18),
              const SectionHeader(title: 'Channels managed'),
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final (ch, m) in usage.managedChannels)
                  ActionChip(avatar: const Icon(Icons.manage_accounts_outlined, size: 14), label: Text('${ch.name} · ${enumFromName(ChannelRole.values, m.role, ChannelRole.manager).label}'), onPressed: () => context.push(Routes.channel(ch.id))),
              ]),
            ],
            if (usage.organizations.isNotEmpty) ...[
              const SizedBox(height: 18),
              const SectionHeader(title: 'Organizations'),
              Wrap(spacing: 8, runSpacing: 8, children: [for (final o in usage.organizations) ActionChip(avatar: const Icon(Icons.business_outlined, size: 14), label: Text(o.name), onPressed: () => context.push(Routes.organization(o.id)))]),
            ],
            if (usage.artists.isNotEmpty) ...[
              const SizedBox(height: 18),
              const SectionHeader(title: 'Artists'),
              Wrap(spacing: 8, runSpacing: 8, children: [for (final a in usage.artists) ActionChip(avatar: const Icon(Icons.mic_none, size: 14), label: Text(a.name), onPressed: () => context.push(Routes.artist(a.id)))]),
            ],
            if (usage.linkedProjects.isNotEmpty) ...[
              const SizedBox(height: 18),
              const SectionHeader(title: 'Linked projects'),
              Wrap(spacing: 8, runSpacing: 8, children: [for (final p in usage.linkedProjects) ActionChip(avatar: const Icon(Icons.folder_outlined, size: 14), label: Text(p.name), onPressed: () => context.push(Routes.project(p.id)))]),
            ],
          ],
          const SizedBox(height: 18),
          RelationsPanel(type: EntityType.emailIdentity, id: emailId),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 130, child: Text(label, style: context.text.bodySmall?.copyWith(color: context.colors.textMuted))),
          Expanded(child: SelectableText(value)),
        ]),
      );
}
