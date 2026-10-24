import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/json_list.dart';
import '../../core/launch.dart';
import '../../data/repositories/account_repository.dart';
import '../../data/repositories/subscription_repository.dart';
import '../../shared/widgets/account_tile.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/page_scaffold.dart';
import '../../shared/widgets/platform_logo.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/toast.dart';
import '../accounts/account_form.dart';

/// A platform (catalog entry or custom) with the user's accounts on it.
class PlatformDetailScreen extends ConsumerWidget {
  const PlatformDetailScreen({super.key, required this.platformId});
  final String platformId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final platform = ref.watch(platformByIdProvider(platformId)).value;
    if (platform == null) {
      return const Scaffold(body: Center(child: Text('Platform not found')));
    }
    final accounts = ref.watch(accountsByPlatformProvider(platformId)).value ?? const <AccountView>[];
    final subs = (ref.watch(subscriptionsProvider).value ?? const <SubscriptionView>[]).where((s) => s.sub.platformId == platformId).toList();
    final catalog = ref.watch(catalogServiceProvider);
    final repo = ref.read(platformRepositoryProvider);
    return Scaffold(
      appBar: AppBar(backgroundColor: c.background, title: Text(platform.name), leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go(Routes.myWorld))),
      body: PageScaffold(
        title: platform.name,
        header: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          PlatformLogo(platform: platform, size: 72, radius: 20),
          const SizedBox(width: 18),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(platform.name, style: context.text.headlineMedium),
            const SizedBox(height: 4),
            Text(platform.description.isEmpty ? 'Custom platform' : platform.description, style: context.text.bodyMedium?.copyWith(color: c.textMuted)),
            const SizedBox(height: 8),
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (final cat in decodeStringList(platform.categories)) ActionChip(label: Text(catalog.categoryLabel(cat)), onPressed: () => context.go('${Routes.explore}?category=$cat')),
              if (platform.vendor != null) Chip(avatar: const Icon(Icons.hub_outlined, size: 14), label: Text('${platform.vendor![0].toUpperCase()}${platform.vendor!.substring(1)} ecosystem')),
            ]),
          ])),
        ]),
        children: [
          Wrap(spacing: 10, runSpacing: 10, children: [
            FilledButton.icon(onPressed: () => showAccountForm(context, ref, platform: platform), icon: const Icon(Icons.person_add_alt, size: 18), label: const Text('Add account')),
            if (platform.website != null) OutlinedButton.icon(onPressed: () => openUrl(context, platform.website), icon: const Icon(Icons.open_in_new, size: 18), label: const Text('Open website')),
            OutlinedButton.icon(
              onPressed: () => repo.setFavorite(platform.id, !platform.isFavorite),
              icon: Icon(platform.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded, size: 18, color: platform.isFavorite ? c.warning : null),
              label: Text(platform.isFavorite ? 'Favorited' : 'Favorite'),
            ),
            platform.inMyWorld
                ? OutlinedButton.icon(
                    onPressed: () async {
                      if (accounts.isNotEmpty && !await confirmDestructive(context, title: 'Remove from My World?', message: 'Your ${accounts.length} account(s) stay saved; the platform just leaves the My World grid.', confirmLabel: 'Remove', danger: false)) return;
                      await repo.setInMyWorld(platform.id, false);
                    },
                    icon: const Icon(Icons.remove_circle_outline, size: 18),
                    label: const Text('Remove from My World'),
                  )
                : FilledButton.tonalIcon(onPressed: () => repo.setInMyWorld(platform.id, true), icon: const Icon(Icons.public, size: 18), label: const Text('Add to My World')),
            if (platform.isCustom)
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(foregroundColor: c.danger),
                onPressed: () async {
                  if (!await confirmDestructive(context, title: 'Delete custom platform?', message: 'Only possible when it has no accounts.')) return;
                  final ok = await repo.deleteCustom(platform.id);
                  if (!context.mounted) return;
                  if (ok) {
                    context.go(Routes.explore);
                  } else {
                    showToast(context, 'Delete or move its accounts first', error: true);
                  }
                },
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Delete custom platform'),
              ),
          ]),
          const SizedBox(height: 24),
          SectionHeader(title: 'Accounts', subtitle: accounts.isEmpty ? null : '${accounts.length} on ${platform.name}'),
          if (accounts.isEmpty)
            AppCard(child: EmptyState(compact: true, icon: Icons.person_outline, title: 'No accounts yet', message: 'Track every ${platform.name} account you own: personal, studio, business, each with its own email identity.', actionLabel: 'Add account', onAction: () => showAccountForm(context, ref, platform: platform)))
          else
            Column(children: [for (final a in accounts) Padding(padding: const EdgeInsets.only(bottom: 8), child: AccountTile(view: a, showPlatform: false))]),
          if (subs.isNotEmpty) ...[
            const SizedBox(height: 20),
            SectionHeader(title: 'Subscriptions', onViewAll: () => context.go(Routes.subscriptions)),
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(children: [
                for (final s in subs)
                  ListTile(title: Text(s.sub.plan ?? s.sub.serviceName), subtitle: Text('${s.price.format()} · ${s.cycle.label} · ${s.status.label}'), trailing: const Icon(Icons.chevron_right), onTap: () => context.push(Routes.subscription(s.sub.id))),
              ]),
            ),
          ],
          if (platform.website != null) ...[
            const SizedBox(height: 20),
            Text(platform.website!, style: context.text.bodySmall?.copyWith(color: c.textMuted)),
          ],
        ],
      ),
    );
  }
}
