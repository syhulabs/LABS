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
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/page_scaffold.dart';
import '../../shared/widgets/platform_logo.dart';
import '../../shared/widgets/stat_card.dart';
import '../../shared/widgets/status_chip.dart';
import '../../shared/widgets/toast.dart';
import 'bank_account_form.dart';
import 'banking_providers.dart';

enum _Tab { banks, cards, methods }

/// Banking & Payments: bank account metadata, card references and payment
/// methods. No bank connections, no transfers, no full numbers.
class BankingScreen extends ConsumerStatefulWidget {
  const BankingScreen({super.key, this.initialTab});
  final String? initialTab;
  @override
  ConsumerState<BankingScreen> createState() => _BankingScreenState();
}

class _BankingScreenState extends ConsumerState<BankingScreen> {
  late _Tab _tab = switch (widget.initialTab) { 'cards' => _Tab.cards, 'methods' => _Tab.methods, _ => _Tab.banks };
  bool _showArchived = false;

  @override
  void didUpdateWidget(covariant BankingScreen old) {
    super.didUpdateWidget(old);
    if (old.initialTab != widget.initialTab && widget.initialTab != null) {
      _tab = switch (widget.initialTab) { 'cards' => _Tab.cards, 'methods' => _Tab.methods, _ => _Tab.banks };
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final banks = ref.watch(bankAccountsProvider).value ?? const <BankAccount>[];
    final cards = ref.watch(cardsProvider).value ?? const <PaymentCard>[];
    final methods = ref.watch(paymentMethodsProvider).value ?? const <PaymentMethod>[];
    final subs = ref.watch(subscriptionsProvider).value ?? const <SubscriptionView>[];
    final defaultMethod = methods.where((m) => m.isDefault).firstOrNull;
    final subsOnDefault = defaultMethod == null ? 0 : subs.where((s) => s.sub.paymentMethodId == defaultMethod.id).length;

    return PageScaffold(
      title: 'Banking & Payments',
      subtitle: 'Organize bank accounts, cards and UPI / wallet references.',
      actions: [
        OutlinedButton.icon(
          onPressed: () => setState(() => _showArchived = !_showArchived),
          icon: Icon(_showArchived ? Icons.visibility_off_outlined : Icons.archive_outlined, size: 18),
          label: Text(_showArchived ? 'Hide archived' : 'Show archived'),
        ),
        FilledButton.icon(
          onPressed: () => switch (_tab) {
            _Tab.banks => showBankAccountForm(context, ref),
            _Tab.cards => showCardForm(context, ref),
            _Tab.methods => showPaymentMethodForm(context, ref),
          },
          icon: const Icon(Icons.add, size: 18),
          label: Text(switch (_tab) { _Tab.banks => 'Add bank account', _Tab.cards => 'Add card', _Tab.methods => 'Add payment method' }),
        ),
      ],
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: c.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: c.success.withValues(alpha: 0.35))),
          child: Row(children: [
            Icon(Icons.verified_user_outlined, color: c.success, size: 18),
            const SizedBox(width: 10),
            Expanded(child: Text('Metadata only. No bank connections, no payments. Full account numbers live encrypted in the Vault if you choose to store them.', style: context.text.bodySmall)),
          ]),
        ),
        const SizedBox(height: 16),
        ResponsiveGrid(minTileWidth: 170, children: [
          StatCard(label: 'Bank accounts', value: '${banks.length}', icon: Icons.account_balance_outlined, color: c.success, onTap: () => setState(() => _tab = _Tab.banks)),
          StatCard(label: 'Cards', value: '${cards.length}', icon: Icons.credit_card, color: c.accentBlue, onTap: () => setState(() => _tab = _Tab.cards)),
          StatCard(label: 'Payment methods', value: '${methods.length}', icon: Icons.payments_outlined, color: c.accent, onTap: () => setState(() => _tab = _Tab.methods)),
          StatCard(label: 'Subscriptions on default method', value: '$subsOnDefault', icon: Icons.autorenew, color: c.accentPink, caption: defaultMethod?.label ?? 'No default set', onTap: () => context.go(Routes.subscriptions)),
        ]),
        const SizedBox(height: 18),
        SegmentedButton<_Tab>(
          segments: const [
            ButtonSegment(value: _Tab.banks, label: Text('Banks'), icon: Icon(Icons.account_balance_outlined, size: 16)),
            ButtonSegment(value: _Tab.cards, label: Text('Cards'), icon: Icon(Icons.credit_card, size: 16)),
            ButtonSegment(value: _Tab.methods, label: Text('UPI, wallets & methods'), icon: Icon(Icons.payments_outlined, size: 16)),
          ],
          selected: {_tab},
          onSelectionChanged: (s) => setState(() => _tab = s.first),
        ),
        const SizedBox(height: 16),
        switch (_tab) {
          _Tab.banks => _BanksTab(banks: banks, showArchived: _showArchived),
          _Tab.cards => _CardsTab(cards: cards, banks: banks, showArchived: _showArchived),
          _Tab.methods => _MethodsTab(methods: methods, cards: cards, banks: banks, subs: subs),
        },
      ],
    );
  }
}

// ---------------------------------------------------------------- Banks

class _BanksTab extends ConsumerWidget {
  const _BanksTab({required this.banks, required this.showArchived});
  final List<BankAccount> banks;
  final bool showArchived;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archived = showArchived ? (ref.watch(archivedBankAccountsProvider).value ?? const <BankAccount>[]) : const <BankAccount>[];
    if (banks.isEmpty && archived.isEmpty) {
      return AppCard(
        child: EmptyState(
          compact: true,
          icon: Icons.account_balance_outlined,
          title: 'No bank accounts yet',
          message: 'Keep IFSC, branch, SWIFT and netbanking usernames in one place. Numbers are masked to the last four digits.',
          actionLabel: 'Add bank account',
          onAction: () => showBankAccountForm(context, ref),
        ),
      );
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      ResponsiveGrid(minTileWidth: 320, children: [for (final b in banks) BankAccountCard(account: b)]),
      if (archived.isNotEmpty) ...[
        const SizedBox(height: 18),
        Text('Archived', style: context.text.titleMedium),
        const SizedBox(height: 8),
        ResponsiveGrid(minTileWidth: 320, children: [for (final b in archived) BankAccountCard(account: b)]),
      ],
    ]);
  }
}

class BankAccountCard extends ConsumerWidget {
  const BankAccountCard({super.key, required this.account, this.onTap});
  final BankAccount account;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final b = account;
    final orgs = ref.watch(organizationsProvider).value ?? const <Organization>[];
    final org = b.organizationId == null ? null : orgs.where((o) => o.id == b.organizationId).firstOrNull;
    final platforms = ref.watch(allPlatformsProvider).value ?? const <Platform>[];
    final platform = b.platformId == null ? null : platforms.where((p) => p.id == b.platformId).firstOrNull;
    final website = b.website ?? platform?.website;
    final repo = ref.read(financeRepositoryProvider);
    final archived = b.archivedAt != null;
    return AppCard(
      padding: const EdgeInsets.all(14),
      onTap: onTap ?? () => context.push(Routes.bank(b.id)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          platform != null ? PlatformLogo(platform: platform, size: 40) : MonogramAvatar(text: b.bankName, seed: b.bankName, size: 40, icon: Icons.account_balance_outlined),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(b.nickname, style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(b.bankName, style: context.text.bodySmall?.copyWith(color: c.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
          ])),
          PopupMenuButton<String>(
            tooltip: 'Actions',
            onSelected: (v) async {
              switch (v) {
                case 'web':
                  await openUrl(context, website);
                case 'edit':
                  await showBankAccountForm(context, ref, existing: b);
                case 'archive':
                  await repo.setBankArchived(b.id, true);
                  if (context.mounted) showToast(context, 'Bank account archived');
                case 'restore':
                  await repo.setBankArchived(b.id, false);
                case 'delete':
                  if (await confirmDestructive(context, title: 'Delete bank account?', message: 'Removes "${b.nickname}" permanently. Linked cards and payment methods are kept but detached.')) {
                    await repo.deleteBankAccount(b.id);
                  }
              }
            },
            itemBuilder: (_) => [
              if (website != null) const PopupMenuItem(value: 'web', child: ListTile(dense: true, leading: Icon(Icons.open_in_new, size: 18), title: Text('Open bank website'))),
              const PopupMenuItem(value: 'edit', child: ListTile(dense: true, leading: Icon(Icons.edit_outlined, size: 18), title: Text('Edit'))),
              if (!archived) const PopupMenuItem(value: 'archive', child: ListTile(dense: true, leading: Icon(Icons.archive_outlined, size: 18), title: Text('Archive')))
              else const PopupMenuItem(value: 'restore', child: ListTile(dense: true, leading: Icon(Icons.unarchive_outlined, size: 18), title: Text('Restore'))),
              const PopupMenuItem(value: 'delete', child: ListTile(dense: true, leading: Icon(Icons.delete_outline, size: 18), title: Text('Delete'))),
            ],
          ),
        ]),
        const SizedBox(height: 12),
        Text(b.last4 == null ? 'Number not recorded' : '•••• ${b.last4}', style: context.text.titleMedium?.copyWith(letterSpacing: 1.5, fontFeatures: const [FontFeature.tabularFigures()])),
        const SizedBox(height: 6),
        Text([if (b.accountType != null) b.accountType!, if (b.ifsc != null) 'IFSC ${b.ifsc}', b.currency].join(' · '), style: context.text.bodySmall?.copyWith(color: c.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 10),
        Wrap(spacing: 6, runSpacing: 6, children: [
          ClassificationChip(b.classification),
          if (org != null) StatusChip(org.name, icon: Icons.business_outlined, color: c.accentPink),
          if (b.fullNumberVaultId != null) StatusChip('Full number in Vault', icon: Icons.lock_outline, color: c.success),
          if (archived) StatusChip('Archived', color: c.textMuted),
        ]),
      ]),
    );
  }
}

// ---------------------------------------------------------------- Cards

class _CardsTab extends ConsumerWidget {
  const _CardsTab({required this.cards, required this.banks, required this.showArchived});
  final List<PaymentCard> cards;
  final List<BankAccount> banks;
  final bool showArchived;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archived = showArchived ? (ref.watch(archivedCardsProvider).value ?? const <PaymentCard>[]) : const <PaymentCard>[];
    if (cards.isEmpty && archived.isEmpty) {
      return AppCard(
        child: EmptyState(
          compact: true,
          icon: Icons.credit_card,
          title: 'No cards yet',
          message: 'Track which card pays for what. Only the nickname, network, last four digits and expiry are stored, never the full number, CVV or PIN.',
          actionLabel: 'Add card',
          onAction: () => showCardForm(context, ref),
        ),
      );
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      ResponsiveGrid(minTileWidth: 300, children: [for (final card in cards) PaymentCardTile(card: card, banks: banks)]),
      if (archived.isNotEmpty) ...[
        const SizedBox(height: 18),
        Text('Archived', style: context.text.titleMedium),
        const SizedBox(height: 8),
        ResponsiveGrid(minTileWidth: 300, children: [for (final card in archived) PaymentCardTile(card: card, banks: banks)]),
      ],
    ]);
  }
}

class PaymentCardTile extends ConsumerWidget {
  const PaymentCardTile({super.key, required this.card, required this.banks});
  final PaymentCard card;
  final List<BankAccount> banks;

  static String expiryLabel(PaymentCard c) => (c.expMonth == null || c.expYear == null) ? 'No expiry' : 'exp ${c.expMonth.toString().padLeft(2, '0')}/${(c.expYear! % 100).toString().padLeft(2, '0')}';

  /// null = no expiry, otherwise days until the end of the expiry month.
  static int? daysToExpiry(PaymentCard c, DateTime now) {
    if (c.expMonth == null || c.expYear == null) return null;
    final end = DateTime(c.expYear!, c.expMonth! + 1, 0);
    return end.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final k = card;
    final bank = k.bankAccountId == null ? null : banks.where((b) => b.id == k.bankAccountId).firstOrNull;
    final repo = ref.read(financeRepositoryProvider);
    final archived = k.archivedAt != null;
    final days = daysToExpiry(k, DateTime.now());
    final kind = enumFromName(CardKind.values, k.kind, CardKind.debit);
    final gradient = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color.alphaBlend(colorForKey(k.id).withValues(alpha: 0.35), c.surface), c.surface]);
    return AppCard(
      padding: const EdgeInsets.all(14),
      gradient: gradient,
      onTap: () => showCardForm(context, ref, existing: k),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.credit_card, color: c.text),
          const SizedBox(width: 8),
          Expanded(child: Text(k.nickname, style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
          if (k.network != null) Text(k.network!, style: context.text.labelMedium?.copyWith(color: c.textMuted)),
          PopupMenuButton<String>(
            tooltip: 'Actions',
            onSelected: (v) async {
              switch (v) {
                case 'edit':
                  await showCardForm(context, ref, existing: k);
                case 'archive':
                  await repo.setCardArchived(k.id, true);
                  if (context.mounted) showToast(context, 'Card archived');
                case 'restore':
                  await repo.setCardArchived(k.id, false);
                case 'delete':
                  if (await confirmDestructive(context, title: 'Delete card?', message: 'Removes "${k.nickname}" permanently. Payment methods using it are detached.')) {
                    await repo.deleteCard(k.id);
                  }
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: ListTile(dense: true, leading: Icon(Icons.edit_outlined, size: 18), title: Text('Edit'))),
              if (!archived) const PopupMenuItem(value: 'archive', child: ListTile(dense: true, leading: Icon(Icons.archive_outlined, size: 18), title: Text('Archive')))
              else const PopupMenuItem(value: 'restore', child: ListTile(dense: true, leading: Icon(Icons.unarchive_outlined, size: 18), title: Text('Restore'))),
              const PopupMenuItem(value: 'delete', child: ListTile(dense: true, leading: Icon(Icons.delete_outline, size: 18), title: Text('Delete'))),
            ],
          ),
        ]),
        const SizedBox(height: 14),
        Text(k.last4 == null ? '•••• ••••' : '•••• •••• •••• ${k.last4}', style: context.text.titleMedium?.copyWith(letterSpacing: 2, fontFeatures: const [FontFeature.tabularFigures()])),
        const SizedBox(height: 6),
        Text([expiryLabel(k), kind.label, if (k.issuingBank != null) k.issuingBank!, if (bank != null) 'linked to ${bank.nickname}'].join(' · '), style: context.text.bodySmall?.copyWith(color: c.textMuted), maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 10),
        Wrap(spacing: 6, runSpacing: 6, children: [
          ClassificationChip(k.classification),
          if (days != null && days < 0) StatusChip('Expired', color: c.danger, icon: Icons.error_outline)
          else if (days != null && days <= 60) StatusChip('Expires soon', color: c.warning, icon: Icons.schedule),
          if (archived) StatusChip('Archived', color: c.textMuted),
        ]),
      ]),
    );
  }
}

// ---------------------------------------------------------------- Methods

class _MethodsTab extends ConsumerWidget {
  const _MethodsTab({required this.methods, required this.cards, required this.banks, required this.subs});
  final List<PaymentMethod> methods;
  final List<PaymentCard> cards;
  final List<BankAccount> banks;
  final List<SubscriptionView> subs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    if (methods.isEmpty) {
      return AppCard(
        child: EmptyState(
          compact: true,
          icon: Icons.payments_outlined,
          title: 'No payment methods yet',
          message: 'Payment methods are what subscriptions are paid with: a card, a bank account, a UPI ID, a wallet or app-store billing.',
          actionLabel: 'Add payment method',
          onAction: () => showPaymentMethodForm(context, ref),
        ),
      );
    }
    final platforms = ref.watch(allPlatformsProvider).value ?? const <Platform>[];
    final repo = ref.read(financeRepositoryProvider);
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(children: [
        for (final m in methods)
          Builder(builder: (context) {
            final kind = enumFromName(PaymentMethodKind.values, m.kind, PaymentMethodKind.other);
            final card = m.cardId == null ? null : cards.where((x) => x.id == m.cardId).firstOrNull;
            final bank = m.bankAccountId == null ? null : banks.where((x) => x.id == m.bankAccountId).firstOrNull;
            final platform = m.platformId == null ? null : platforms.where((p) => p.id == m.platformId).firstOrNull;
            final used = subs.where((s) => s.sub.paymentMethodId == m.id).length;
            final details = [
              kind.label,
              if (card != null) card.last4 == null ? card.nickname : '${card.nickname} •••• ${card.last4}',
              if (bank != null) '${bank.nickname} (${bank.bankName})',
              if (platform != null) platform.name,
              if (m.identifierHint != null) m.identifierHint!,
            ].join(' · ');
            return ListTile(
              leading: platform != null ? PlatformLogo(platform: platform, size: 36) : MonogramAvatar(text: m.label, seed: m.id, size: 36, icon: _iconFor(kind)),
              title: Row(children: [
                Flexible(child: Text(m.label, maxLines: 1, overflow: TextOverflow.ellipsis)),
                if (m.isDefault) Padding(padding: const EdgeInsets.only(left: 6), child: Icon(Icons.star_rounded, size: 16, color: c.warning)),
              ]),
              subtitle: Text(details, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                if (used > 0) StatusChip('$used subscription${used == 1 ? '' : 's'}', color: c.accent),
                PopupMenuButton<String>(
                  tooltip: 'Actions',
                  onSelected: (v) async {
                    switch (v) {
                      case 'edit':
                        await showPaymentMethodForm(context, ref, existing: m);
                      case 'default':
                        await repo.upsertPaymentMethod(id: m.id, label: m.label, kind: kind, cardId: m.cardId, bankAccountId: m.bankAccountId, platformId: m.platformId, identifierHint: m.identifierHint, isDefault: true, notes: m.notes);
                      case 'delete':
                        if (await confirmDestructive(context, title: 'Delete payment method?', message: used > 0 ? '$used subscription(s) use "${m.label}"; they are kept but lose their payment method.' : 'Removes "${m.label}" permanently.')) {
                          await repo.deletePaymentMethod(m.id);
                        }
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: ListTile(dense: true, leading: Icon(Icons.edit_outlined, size: 18), title: Text('Edit'))),
                    if (!m.isDefault) const PopupMenuItem(value: 'default', child: ListTile(dense: true, leading: Icon(Icons.star_outline, size: 18), title: Text('Make default'))),
                    const PopupMenuItem(value: 'delete', child: ListTile(dense: true, leading: Icon(Icons.delete_outline, size: 18), title: Text('Delete'))),
                  ],
                ),
              ]),
              onTap: () => showPaymentMethodForm(context, ref, existing: m),
            );
          }),
      ]),
    );
  }

  static IconData _iconFor(PaymentMethodKind k) => switch (k) {
        PaymentMethodKind.card => Icons.credit_card,
        PaymentMethodKind.bankAccount => Icons.account_balance_outlined,
        PaymentMethodKind.upi => Icons.qr_code_2,
        PaymentMethodKind.wallet => Icons.account_balance_wallet_outlined,
        PaymentMethodKind.paypal => Icons.paid_outlined,
        PaymentMethodKind.appStore => Icons.apple,
        PaymentMethodKind.playStore => Icons.play_arrow_rounded,
        PaymentMethodKind.cash => Icons.money,
        PaymentMethodKind.other => Icons.payments_outlined,
      };
}
