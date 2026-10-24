import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import 'bank_account_form.dart';
import 'banking_providers.dart';
import 'banking_screen.dart';
import 'secret_reveal.dart';

class BankAccountDetailScreen extends ConsumerWidget {
  const BankAccountDetailScreen({super.key, required this.bankAccountId});
  final String bankAccountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final b = ref.watch(bankAccountByIdProvider(bankAccountId)).value;
    void back() => context.canPop() ? context.pop() : context.go(Routes.banking);
    if (b == null) {
      return Scaffold(appBar: AppBar(backgroundColor: c.background, leading: BackButton(onPressed: back)), body: const Center(child: Text('Bank account not found')));
    }
    final platforms = ref.watch(allPlatformsProvider).value ?? const <Platform>[];
    final platform = b.platformId == null ? null : platforms.where((p) => p.id == b.platformId).firstOrNull;
    final website = b.website ?? platform?.website;
    final orgs = ref.watch(organizationsProvider).value ?? const <Organization>[];
    final org = b.organizationId == null ? null : orgs.where((o) => o.id == b.organizationId).firstOrNull;
    final cards = (ref.watch(cardsProvider).value ?? const <PaymentCard>[]).where((k) => k.bankAccountId == b.id).toList();
    final methods = (ref.watch(paymentMethodsProvider).value ?? const <PaymentMethod>[]).where((m) => m.bankAccountId == b.id || cards.any((k) => k.id == m.cardId)).toList();
    final methodIds = methods.map((m) => m.id).toSet();
    final subs = (ref.watch(subscriptionsProvider).value ?? const <SubscriptionView>[]).where((s) => s.sub.paymentMethodId != null && methodIds.contains(s.sub.paymentMethodId)).toList();
    final repo = ref.read(financeRepositoryProvider);

    final fields = <(String, String?)>[
      ('Bank', b.bankName),
      ('Nickname', b.nickname),
      ('Account holder', b.holderName),
      ('Account type', b.accountType),
      ('Account number', b.last4 == null ? null : '•••• ${b.last4}'),
      ('IFSC', b.ifsc),
      ('Branch', b.branch),
      ('SWIFT / BIC', b.swift),
      ('Routing number', b.routing),
      ('Netbanking username', b.netbankingUsername),
      ('Currency', b.currency),
      ('Related business', org?.name),
      ('Website', website),
    ];

    return Scaffold(
      appBar: AppBar(backgroundColor: c.background, title: Text(b.nickname), leading: BackButton(onPressed: back)),
      body: PageScaffold(
        title: b.nickname,
        header: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          platform != null ? PlatformLogo(platform: platform, size: 72, radius: 20) : MonogramAvatar(text: b.bankName, seed: b.bankName, size: 72, icon: Icons.account_balance_outlined),
          const SizedBox(width: 18),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(b.nickname, style: context.text.headlineMedium),
            const SizedBox(height: 4),
            Text('${b.bankName}${b.accountType == null ? '' : ' · ${b.accountType}'}', style: context.text.bodyMedium?.copyWith(color: c.textMuted)),
            const SizedBox(height: 8),
            Wrap(spacing: 6, runSpacing: 6, children: [
              ClassificationChip(b.classification),
              if (b.archivedAt != null) StatusChip('Archived', color: c.textMuted),
              if (b.fullNumberVaultId != null) StatusChip('Full number in Vault', icon: Icons.lock_outline, color: c.success),
            ]),
          ])),
        ]),
        children: [
          Wrap(spacing: 10, runSpacing: 10, children: [
            FilledButton.icon(onPressed: () => showBankAccountForm(context, ref, existing: b), icon: const Icon(Icons.edit_outlined, size: 18), label: const Text('Edit')),
            if (website != null) OutlinedButton.icon(onPressed: () => openUrl(context, website), icon: const Icon(Icons.open_in_new, size: 18), label: const Text('Open bank website')),
            OutlinedButton.icon(onPressed: () => showCardForm(context, ref), icon: const Icon(Icons.credit_card, size: 18), label: const Text('Add card')),
            if (b.archivedAt == null)
              OutlinedButton.icon(onPressed: () async { await repo.setBankArchived(b.id, true); if (context.mounted) showToast(context, 'Archived'); }, icon: const Icon(Icons.archive_outlined, size: 18), label: const Text('Archive'))
            else
              OutlinedButton.icon(onPressed: () => repo.setBankArchived(b.id, false), icon: const Icon(Icons.unarchive_outlined, size: 18), label: const Text('Restore')),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: c.danger),
              onPressed: () async {
                if (!await confirmDestructive(context, title: 'Delete bank account?', message: 'Removes "${b.nickname}" permanently. Linked cards and payment methods are kept but detached.')) return;
                await repo.deleteBankAccount(b.id);
                if (context.mounted) back();
              },
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Delete'),
            ),
          ]),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Details'),
          AppCard(
            child: LayoutBuilder(builder: (context, constraints) {
              final two = constraints.maxWidth > 620;
              final rows = fields.where((f) => f.$2 != null).toList();
              Widget cell((String, String?) f) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(f.$1, style: context.text.labelSmall?.copyWith(color: c.textMuted)),
                      const SizedBox(height: 2),
                      SelectableText(f.$2!, style: context.text.bodyMedium),
                    ]),
                  );
              if (!two) return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [for (final f in rows) cell(f)]);
              final left = <Widget>[], right = <Widget>[];
              for (var i = 0; i < rows.length; i++) {
                (i.isEven ? left : right).add(cell(rows[i]));
              }
              return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: left)),
                const SizedBox(width: 24),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: right)),
              ]);
            }),
          ),
          if (b.notes != null) ...[
            const SizedBox(height: 18),
            const SectionHeader(title: 'Notes'),
            AppCard(child: SelectableText(b.notes!)),
          ],
          const SizedBox(height: 18),
          const SectionHeader(title: 'Protected full account number'),
          AppCard(
            child: b.fullNumberVaultId == null
                ? Row(children: [
                    Icon(Icons.lock_open_outlined, color: c.textMuted),
                    const SizedBox(width: 10),
                    Expanded(child: Text('Not stored. Edit this account to keep the full number encrypted in the Vault.', style: TextStyle(color: c.textMuted))),
                  ])
                : SecretReveal(vaultItemId: b.fullNumberVaultId!, label: 'Full account number'),
          ),
          const SizedBox(height: 18),
          SectionHeader(title: 'Cards on this account', subtitle: cards.isEmpty ? 'None linked' : null),
          if (cards.isNotEmpty) ResponsiveGrid(minTileWidth: 300, children: [for (final k in cards) PaymentCardTile(card: k, banks: [b])]),
          const SizedBox(height: 18),
          SectionHeader(title: 'Payment methods using it', subtitle: methods.isEmpty ? 'None yet' : null, onViewAll: () => context.go('${Routes.banking}?tab=methods')),
          if (methods.isNotEmpty)
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final m in methods) InputChip(avatar: Icon(m.isDefault ? Icons.star_rounded : Icons.payments_outlined, size: 16), label: Text(m.label), onPressed: () => showPaymentMethodForm(context, ref, existing: m)),
            ]),
          const SizedBox(height: 18),
          SectionHeader(title: 'Subscriptions paid from this account', subtitle: subs.isEmpty ? 'None found' : '${subs.length} via linked payment methods', onViewAll: () => context.go(Routes.subscriptions)),
          if (subs.isNotEmpty)
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(children: [
                for (final s in subs)
                  ListTile(
                    leading: s.platform == null ? MonogramAvatar(text: s.sub.serviceName, seed: s.sub.id, size: 36) : PlatformLogo(platform: s.platform!, size: 36),
                    title: Text(s.sub.serviceName),
                    subtitle: Text('${s.price.format()} · ${s.cycle.label} · ${s.status.label}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(Routes.subscription(s.sub.id)),
                  ),
              ]),
            ),
          const SizedBox(height: 18),
          RelationsPanel(type: EntityType.bankAccount, id: b.id),
        ],
      ),
    );
  }
}
