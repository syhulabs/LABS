import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/launch.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/subscription_repository.dart';
import '../../domain/enums.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/page_scaffold.dart';
import '../../shared/widgets/platform_logo.dart';
import '../../shared/widgets/relations_panel.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/status_chip.dart';
import '../../shared/widgets/toast.dart';
import 'account_form.dart';
import 'account_providers.dart';

/// Full view of one service account.
class AccountDetailScreen extends ConsumerStatefulWidget {
  const AccountDetailScreen({super.key, required this.accountId});
  final String accountId;
  @override
  ConsumerState<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends ConsumerState<AccountDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(accountRepositoryProvider).touchAccessed(widget.accountId);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final view = ref.watch(accountByIdProvider(widget.accountId)).value;
    void back() => context.canPop() ? context.pop() : context.go(Routes.accounts);
    if (view == null) {
      return Scaffold(appBar: AppBar(backgroundColor: c.background, leading: BackButton(onPressed: back)), body: const Center(child: Text('Account not found')));
    }
    final a = view.account;
    final p = view.platform;
    final repo = ref.read(accountRepositoryProvider);
    final refs = ref.watch(credentialRefsProvider).value ?? const <CredentialReference>[];
    final cred = a.credentialRefId == null ? null : refs.where((r) => r.id == a.credentialRefId).firstOrNull;
    final subs = (ref.watch(subscriptionsProvider).value ?? const <SubscriptionView>[]).where((s) => s.sub.accountId == a.id).toList();
    final fmt = DateFormat.yMMMd().add_jm();
    final website = a.profileUrl ?? p.website;

    return Scaffold(
      appBar: AppBar(backgroundColor: c.background, title: Text('${p.name} · ${a.accountName}'), leading: BackButton(onPressed: back)),
      body: PageScaffold(
        title: a.accountName,
        header: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          PlatformLogo(platform: p, size: 72, radius: 20),
          const SizedBox(width: 18),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(a.accountName, style: context.text.headlineSmall),
            const SizedBox(height: 4),
            InkWell(onTap: () => context.push(Routes.platform(p.id)), child: Text(p.name, style: context.text.bodyMedium?.copyWith(color: c.accent))),
            const SizedBox(height: 8),
            Wrap(spacing: 6, runSpacing: 6, children: [
              ClassificationChip(a.classification),
              StatusChip(statusLabel(a.status), color: statusColor(context, a.status), dense: false),
              if (a.isApiAccount) StatusChip('API account', color: c.accentBlue, icon: Icons.code, dense: false),
              if (a.archivedAt != null) StatusChip('Archived', color: c.warning, dense: false),
              if (a.isFavorite) StatusChip('Favorite', color: c.warning, icon: Icons.star, dense: false),
            ]),
          ])),
        ]),
        children: [
          Wrap(spacing: 10, runSpacing: 10, children: [
            FilledButton.icon(onPressed: () => showAccountForm(context, ref, existing: view), icon: const Icon(Icons.edit_outlined, size: 18), label: const Text('Edit')),
            if (website != null) OutlinedButton.icon(onPressed: () => openUrl(context, website), icon: const Icon(Icons.open_in_new, size: 18), label: Text(a.profileUrl != null ? 'Open profile' : 'Open website')),
            OutlinedButton.icon(
              onPressed: () => repo.setFavorite(a.id, !a.isFavorite),
              icon: Icon(a.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded, size: 18, color: a.isFavorite ? c.warning : null),
              label: Text(a.isFavorite ? 'Favorited' : 'Favorite'),
            ),
            OutlinedButton.icon(
              onPressed: () async {
                await repo.setArchived(a.id, a.archivedAt == null);
                if (context.mounted) showToast(context, a.archivedAt == null ? 'Account archived' : 'Account restored');
              },
              icon: Icon(a.archivedAt == null ? Icons.archive_outlined : Icons.unarchive_outlined, size: 18),
              label: Text(a.archivedAt == null ? 'Archive' : 'Restore'),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: c.danger),
              onPressed: () async {
                if (!await confirmDestructive(context, title: 'Delete account?', message: 'Permanently removes "${a.accountName}" on ${p.name}. Subscriptions linked to it are kept but detached.')) return;
                await repo.delete(a.id);
                if (context.mounted) {
                  showToast(context, 'Account deleted');
                  back();
                }
              },
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Delete'),
            ),
          ]),
          const SizedBox(height: 22),
          AppCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _row(context, 'Email identity', view.email == null ? Text('Not linked', style: TextStyle(color: c.textMuted)) : InkWell(onTap: () => context.push(Routes.email(view.email!.id)), child: Text(view.email!.address, style: TextStyle(color: c.accent)))),
              if (a.username != null) _row(context, 'Username', SelectableText(a.username!)),
              if (a.displayName != null) _row(context, 'Display name', SelectableText(a.displayName!)),
              if (a.profileUrl != null) _row(context, 'Profile URL', InkWell(onTap: () => openUrl(context, a.profileUrl), child: Text(a.profileUrl!, style: TextStyle(color: c.accent)))),
              if (a.purpose != null) _row(context, 'Purpose', SelectableText(a.purpose!)),
              if (a.plan != null || a.billingCycle != null)
                _row(context, 'Plan', Text([if (a.plan != null) a.plan!, if (a.billingCycle != null) enumFromName(BillingCycle.values, a.billingCycle, BillingCycle.monthly).label].join(' · '))),
              if (a.notes != null) _row(context, 'Notes', SelectableText(a.notes!)),
              _row(context, 'Last accessed', Text(a.lastAccessedAt == null ? 'Never' : fmt.format(a.lastAccessedAt!), style: TextStyle(color: c.textMuted))),
              _row(context, 'Created', Text(fmt.format(a.createdAt), style: TextStyle(color: c.textMuted))),
              _row(context, 'Updated', Text(fmt.format(a.updatedAt), style: TextStyle(color: c.textMuted)), last: true),
            ]),
          ),
          const SizedBox(height: 18),
          const SectionHeader(title: 'Credential reference', subtitle: 'Where the password lives. The password itself is never stored here.'),
          if (cred == null)
            Text('No credential reference. Edit the account to point at a password-manager item.', style: context.text.bodySmall?.copyWith(color: c.textMuted))
          else
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(children: [
                Icon(Icons.key_outlined, color: c.accent),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(cred.label, style: context.text.titleSmall),
                  Text([if (cred.manager != null) cred.manager!, if (cred.usernameHint != null) 'user: ${cred.usernameHint}', if (cred.locator != null) cred.locator!].join(' · '), style: context.text.bodySmall?.copyWith(color: c.textMuted), maxLines: 2, overflow: TextOverflow.ellipsis),
                ])),
                if (cred.locator != null)
                  (cred.locator!.contains('://')
                      ? TextButton.icon(onPressed: () => openUrl(context, cred.locator), icon: const Icon(Icons.open_in_new, size: 16), label: const Text('Open in password manager'))
                      : TextButton.icon(
                          onPressed: () async {
                            await ref.read(clipboardServiceProvider).copyPlain(cred.locator!);
                            if (context.mounted) showToast(context, 'Item reference copied');
                          },
                          icon: const Icon(Icons.copy, size: 16),
                          label: const Text('Copy reference'),
                        )),
                if (cred.vaultItemId != null) TextButton.icon(onPressed: () => context.go(Routes.vault), icon: const Icon(Icons.lock_outline, size: 16), label: const Text('Vault')),
              ]),
            ),
          if (subs.isNotEmpty) ...[
            const SizedBox(height: 18),
            SectionHeader(title: 'Subscriptions', onViewAll: () => context.go(Routes.subscriptions)),
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(children: [
                for (final s in subs)
                  ListTile(title: Text(s.sub.plan == null ? s.sub.serviceName : '${s.sub.serviceName} · ${s.sub.plan}'), subtitle: Text('${s.price.format()} · ${s.cycle.label} · ${s.status.label}'), trailing: const Icon(Icons.chevron_right), onTap: () => context.push(Routes.subscription(s.sub.id))),
              ]),
            ),
          ],
          const SizedBox(height: 18),
          RelationsPanel(type: EntityType.serviceAccount, id: a.id),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, Widget value, {bool last = false}) => Padding(
        padding: EdgeInsets.only(bottom: last ? 0 : 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 130, child: Text(label, style: context.text.bodySmall?.copyWith(color: context.colors.textMuted))),
          Expanded(child: value),
        ]),
      );
}
