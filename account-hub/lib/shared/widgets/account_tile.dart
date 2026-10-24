import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/launch.dart';
import '../../data/repositories/account_repository.dart';
import '../../features/accounts/account_form.dart';
import 'app_card.dart';
import 'confirm_dialog.dart';
import 'platform_logo.dart';
import 'status_chip.dart';
import 'toast.dart';

/// Account row used across hubs, platform detail and the accounts list.
class AccountTile extends ConsumerWidget {
  const AccountTile({super.key, required this.view, this.showPlatform = true, this.dense = false});
  final AccountView view;
  final bool showPlatform;
  final bool dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final a = view.account;
    final repo = ref.read(accountRepositoryProvider);
    return AppCard(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: dense ? 10 : 12),
      onTap: () {
        repo.touchAccessed(a.id);
        context.push(Routes.account(a.id));
      },
      child: Row(children: [
        PlatformLogo(platform: view.platform, size: dense ? 34 : 40),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Flexible(child: Text(showPlatform ? '${view.platform.name} · ${a.accountName}' : a.accountName, style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
              if (a.isFavorite) Padding(padding: const EdgeInsets.only(left: 6), child: Icon(Icons.star_rounded, size: 14, color: c.warning)),
            ]),
            const SizedBox(height: 2),
            Text(
              [if (view.email != null) view.email!.address, if (a.username != null) '@${a.username!.replaceFirst('@', '')}', if (a.plan != null) a.plan!].join(' · '),
              style: context.text.bodySmall?.copyWith(color: c.textMuted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ]),
        ),
        const SizedBox(width: 8),
        if (!context.isCompact) ...[
          ClassificationChip(a.classification),
          const SizedBox(width: 6),
          StatusChip(statusLabel(a.status), color: statusColor(context, a.status)),
        ],
        PopupMenuButton<String>(
          tooltip: 'Actions',
          onSelected: (v) async {
            switch (v) {
              case 'open':
                await openUrl(context, a.profileUrl ?? view.platform.website);
              case 'edit':
                await showAccountForm(context, ref, existing: view);
              case 'fav':
                await repo.setFavorite(a.id, !a.isFavorite);
              case 'archive':
                await repo.setArchived(a.id, true);
                if (context.mounted) showToast(context, 'Account archived');
              case 'restore':
                await repo.setArchived(a.id, false);
              case 'delete':
                if (await confirmDestructive(context, title: 'Delete account?', message: 'This permanently removes "${a.accountName}" on ${view.platform.name}. Linked subscriptions are kept but detached.')) {
                  await repo.delete(a.id);
                }
            }
          },
          itemBuilder: (_) => [
            if ((a.profileUrl ?? view.platform.website) != null) const PopupMenuItem(value: 'open', child: ListTile(dense: true, leading: Icon(Icons.open_in_new, size: 18), title: Text('Open website'))),
            const PopupMenuItem(value: 'edit', child: ListTile(dense: true, leading: Icon(Icons.edit_outlined, size: 18), title: Text('Edit'))),
            PopupMenuItem(value: 'fav', child: ListTile(dense: true, leading: Icon(a.isFavorite ? Icons.star_outline : Icons.star, size: 18), title: Text(a.isFavorite ? 'Remove favorite' : 'Favorite'))),
            if (a.archivedAt == null) const PopupMenuItem(value: 'archive', child: ListTile(dense: true, leading: Icon(Icons.archive_outlined, size: 18), title: Text('Archive')))
            else const PopupMenuItem(value: 'restore', child: ListTile(dense: true, leading: Icon(Icons.unarchive_outlined, size: 18), title: Text('Restore'))),
            const PopupMenuItem(value: 'delete', child: ListTile(dense: true, leading: Icon(Icons.delete_outline, size: 18), title: Text('Delete'))),
          ],
        ),
      ]),
    );
  }
}
