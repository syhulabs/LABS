import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme/app_theme.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/secure/vault_repository.dart';
import '../../domain/enums.dart';
import '../../domain/money.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/form_sheet.dart';
import '../../shared/widgets/pickers.dart';
import '../../shared/widgets/toast.dart';
import 'banking_providers.dart';
import 'secret_reveal.dart';

/// Create / edit a bank account. Only metadata is stored in the database; the
/// optional full account number is encrypted into the Vault.
Future<String?> showBankAccountForm(BuildContext context, WidgetRef ref, {BankAccount? existing}) async {
  final e = existing;
  final bankName = TextEditingController(text: e?.bankName ?? '');
  final nickname = TextEditingController(text: e?.nickname ?? '');
  final holder = TextEditingController(text: e?.holderName ?? '');
  final number = TextEditingController();
  final ifsc = TextEditingController(text: e?.ifsc ?? '');
  final branch = TextEditingController(text: e?.branch ?? '');
  final swift = TextEditingController(text: e?.swift ?? '');
  final routing = TextEditingController(text: e?.routing ?? '');
  final netbanking = TextEditingController(text: e?.netbankingUsername ?? '');
  final website = TextEditingController(text: e?.website ?? '');
  final notes = TextEditingController(text: e?.notes ?? '');
  final fullNumber = TextEditingController();
  String? platformId = e?.platformId;
  String? accountType = e?.accountType;
  var currency = e?.currency ?? (ref.read(settingsProvider).value?.defaultCurrency ?? 'INR');
  String? organizationId = e?.organizationId;
  var classification = enumFromName(Classification.values, e?.classification, Classification.personal);
  String? vaultId = e?.fullNumberVaultId;
  var storeFull = false;
  final formKey = GlobalKey<FormState>();

  return showFormSheet<String>(context, title: e == null ? 'Add bank account' : 'Edit bank account', maxWidth: 600, builder: (ctx, close) {
    return StatefulBuilder(builder: (ctx, setState) {
      final orgs = ref.watch(organizationsProvider).value ?? const <Organization>[];
      return Form(
        key: formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Metadata only. This app never connects to your bank or moves money.', style: ctx.text.bodySmall?.copyWith(color: ctx.colors.textMuted)),
          const SizedBox(height: 12),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: AppTextField(controller: bankName, label: 'Bank name', prefixIcon: Icons.account_balance_outlined, validator: (v) => requiredValidator(v, 'Bank name'))),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: OutlinedButton.icon(
                onPressed: () async {
                  final p = await showPlatformPicker(ctx, ref, category: 'banking', title: 'Pick your bank');
                  if (p == null) return;
                  setState(() {
                    bankName.text = p.name;
                    platformId = p.id;
                    if (website.text.trim().isEmpty && p.website != null) website.text = p.website!;
                  });
                },
                icon: const Icon(Icons.search, size: 16),
                label: const Text('Catalog'),
              ),
            ),
          ]),
          AppTextField(controller: nickname, label: 'Account nickname', hint: 'Main savings, Studio current…', validator: (v) => requiredValidator(v, 'Nickname')),
          AppTextField(controller: holder, label: 'Account holder name'),
          AppDropdown<String>(label: 'Account type', value: accountType, allowNull: true, nullLabel: 'Not set', items: [for (final t in bankAccountTypes) (t, t)], onChanged: (v) => setState(() => accountType = v)),
          AppTextField(
            controller: number,
            label: e?.last4 == null ? 'Account number (only last 4 digits are kept here)' : 'Account number (currently •••• ${e!.last4}; only last 4 digits are kept here)',
            helper: 'Everything except the last four digits is discarded before saving. Use the protected field below to keep the full number encrypted.',
            keyboardType: TextInputType.number,
          ),
          Row(children: [
            Expanded(child: AppTextField(controller: ifsc, label: 'IFSC')),
            const SizedBox(width: 10),
            Expanded(child: AppTextField(controller: branch, label: 'Branch')),
          ]),
          Row(children: [
            Expanded(child: AppTextField(controller: swift, label: 'SWIFT / BIC')),
            const SizedBox(width: 10),
            Expanded(child: AppTextField(controller: routing, label: 'Routing number')),
          ]),
          AppTextField(controller: netbanking, label: 'Netbanking username', helper: 'Username only, never the password.', prefixIcon: Icons.person_outline),
          AppTextField(controller: website, label: 'Bank website', hint: 'https://…', validator: urlValidator, keyboardType: TextInputType.url, prefixIcon: Icons.link),
          Row(children: [
            Expanded(child: AppDropdown<String>(label: 'Currency', value: supportedCurrencies.contains(currency) ? currency : 'INR', items: [for (final c in supportedCurrencies) (c, '${Money.currencySymbol(c).trim()} $c')], onChanged: (v) => setState(() => currency = v ?? currency))),
            const SizedBox(width: 10),
            Expanded(child: AppDropdown<String>(label: 'Related business', value: organizationId, allowNull: true, nullLabel: 'None', items: [for (final o in orgs) (o.id, o.name)], onChanged: (v) => setState(() => organizationId = v))),
          ]),
          ClassificationToggle(value: classification, onChanged: (v) => setState(() => classification = v)),
          AppTextField(controller: notes, label: 'Notes', maxLines: 3),
          FormSectionTitle('Protected full account number', hint: 'Optional. Encrypted with AES-GCM in the Vault; never searchable, never exported in plain backups.'),
          if (vaultId != null)
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Row(children: [
                Icon(Icons.lock_outline, size: 16, color: ctx.colors.success),
                const SizedBox(width: 6),
                Text('Stored in Vault', style: ctx.text.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                const Spacer(),
                TextButton.icon(
                  onPressed: () async {
                    if (!await confirmDestructive(ctx, title: 'Remove stored number?', message: 'The encrypted full account number is deleted from the Vault. The last 4 digits stay.', confirmLabel: 'Remove')) return;
                    final id = vaultId!;
                    await ref.read(vaultRepositoryProvider).delete(id);
                    await ref.read(financeRepositoryProvider).upsertBankAccount(
                          id: e!.id, bankName: e.bankName, platformId: e.platformId, nickname: e.nickname, holderName: e.holderName, accountType: e.accountType, last4: e.last4, ifsc: e.ifsc, branch: e.branch, swift: e.swift, routing: e.routing,
                          netbankingUsername: e.netbankingUsername, website: e.website, currency: e.currency, organizationId: e.organizationId,
                          classification: enumFromName(Classification.values, e.classification, Classification.personal), notes: e.notes, fullNumberVaultId: null,
                        );
                    setState(() => vaultId = null);
                  },
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('Remove'),
                ),
              ]),
              SecretReveal(vaultItemId: vaultId!, label: 'Full account number'),
              const SizedBox(height: 8),
            ])
          else ...[
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Store full account number in the Vault (encrypted)'),
              value: storeFull,
              onChanged: (v) => setState(() => storeFull = v),
            ),
            if (storeFull)
              AppTextField(
                controller: fullNumber,
                label: 'Full account number',
                obscure: true,
                keyboardType: TextInputType.number,
                helper: 'Saved only inside the encrypted Vault, keyed by your device keychain.',
              ),
          ],
          FormActions(
            onCancel: close,
            onSave: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                var vid = vaultId;
                final full = fullNumber.text.trim();
                if (vid == null && storeFull && full.isNotEmpty) {
                  final item = await ref.read(vaultRepositoryProvider).create(
                        title: '${nickname.text.trim()} account number',
                        kind: SecureItemKind.bankAccountNumber,
                        secret: VaultSecret(value: full, notes: bankName.text.trim()),
                      );
                  vid = item.id;
                }
                final last4 = number.text.trim().isEmpty ? (full.isNotEmpty ? full : e?.last4) : number.text;
                final saved = await ref.read(financeRepositoryProvider).upsertBankAccount(
                      id: e?.id,
                      bankName: bankName.text,
                      platformId: platformId,
                      nickname: nickname.text,
                      holderName: holder.text,
                      accountType: accountType,
                      last4: last4,
                      ifsc: ifsc.text,
                      branch: branch.text,
                      swift: swift.text,
                      routing: routing.text,
                      netbankingUsername: netbanking.text,
                      website: website.text,
                      currency: currency,
                      organizationId: organizationId,
                      classification: classification,
                      notes: notes.text,
                      fullNumberVaultId: vid,
                    );
                close(saved.id);
              } catch (err) {
                if (ctx.mounted) showToast(ctx, friendlyError(err), error: true);
              }
            },
          ),
        ]),
      );
    });
  });
}

/// Create / edit a payment card. PAN, CVV and PINs are never collected.
Future<String?> showCardForm(BuildContext context, WidgetRef ref, {PaymentCard? existing}) {
  final e = existing;
  final nickname = TextEditingController(text: e?.nickname ?? '');
  final issuer = TextEditingController(text: e?.issuingBank ?? '');
  final last4 = TextEditingController(text: e?.last4 ?? '');
  final notes = TextEditingController(text: e?.notes ?? '');
  String? network = e?.network;
  var kind = enumFromName(CardKind.values, e?.kind, CardKind.debit);
  int? expMonth = e?.expMonth;
  int? expYear = e?.expYear;
  String? bankAccountId = e?.bankAccountId;
  var classification = enumFromName(Classification.values, e?.classification, Classification.personal);
  final formKey = GlobalKey<FormState>();
  final thisYear = DateTime.now().year;

  return showFormSheet<String>(context, title: e == null ? 'Add card' : 'Edit card', builder: (ctx, close) {
    return StatefulBuilder(builder: (ctx, setState) {
      final banks = ref.watch(bankAccountsProvider).value ?? const <BankAccount>[];
      final issuerSuggestions = banks.map((b) => b.bankName).toSet().toList();
      return Form(
        key: formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: ctx.colors.warning.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10), border: Border.all(color: ctx.colors.warning.withValues(alpha: 0.4))),
            child: Row(children: [
              Icon(Icons.shield_outlined, size: 16, color: ctx.colors.warning),
              const SizedBox(width: 8),
              Expanded(child: Text('Never enter the full card number, CVV or PIN. Only the last four digits and expiry are kept.', style: ctx.text.bodySmall)),
            ]),
          ),
          const SizedBox(height: 12),
          AppTextField(controller: nickname, label: 'Card nickname', hint: 'Travel card, Studio credit…', autofocus: e == null, validator: (v) => requiredValidator(v, 'Nickname')),
          AppTextField(controller: issuer, label: 'Issuing bank', prefixIcon: Icons.account_balance_outlined),
          if (issuerSuggestions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Wrap(spacing: 6, runSpacing: 6, children: [for (final s in issuerSuggestions.take(8)) ActionChip(label: Text(s), onPressed: () => setState(() => issuer.text = s))]),
            ),
          Row(children: [
            Expanded(child: AppDropdown<String>(label: 'Network', value: network, allowNull: true, nullLabel: 'Not set', items: [for (final n in cardNetworks) (n, n)], onChanged: (v) => setState(() => network = v))),
            const SizedBox(width: 10),
            Expanded(child: AppDropdown<CardKind>(label: 'Type', value: kind, items: [for (final k in CardKind.values) (k, k.label)], onChanged: (v) => setState(() => kind = v ?? kind))),
          ]),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextFormField(
              controller: last4,
              maxLength: 4,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'Last 4 digits', helperText: 'Never enter the full card number, CVV or PIN.', prefixIcon: Icon(Icons.credit_card, size: 18), counterText: ''),
              validator: (v) => (v != null && v.isNotEmpty && v.length != 4) ? 'Enter exactly 4 digits' : null,
            ),
          ),
          Row(children: [
            Expanded(child: AppDropdown<int>(label: 'Expiry month', value: expMonth, allowNull: true, nullLabel: 'MM', items: [for (var m = 1; m <= 12; m++) (m, m.toString().padLeft(2, '0'))], onChanged: (v) => setState(() => expMonth = v))),
            const SizedBox(width: 10),
            Expanded(child: AppDropdown<int>(label: 'Expiry year', value: expYear, allowNull: true, nullLabel: 'YYYY', items: [for (var y = thisYear - 1; y <= thisYear + 15; y++) (y, '$y')], onChanged: (v) => setState(() => expYear = v))),
          ]),
          AppDropdown<String>(label: 'Linked bank account', value: bankAccountId, allowNull: true, nullLabel: 'None', items: [for (final b in banks) (b.id, '${b.nickname} · ${b.bankName}')], onChanged: (v) => setState(() => bankAccountId = v)),
          ClassificationToggle(value: classification, onChanged: (v) => setState(() => classification = v)),
          AppTextField(controller: notes, label: 'Notes', maxLines: 2),
          FormActions(
            onCancel: close,
            onSave: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                final saved = await ref.read(financeRepositoryProvider).upsertCard(
                      id: e?.id,
                      nickname: nickname.text,
                      issuingBank: issuer.text,
                      network: network,
                      kind: kind,
                      last4: last4.text,
                      expMonth: expMonth,
                      expYear: expYear,
                      bankAccountId: bankAccountId,
                      classification: classification,
                      notes: notes.text,
                    );
                close(saved.id);
              } catch (err) {
                if (ctx.mounted) showToast(ctx, friendlyError(err), error: true);
              }
            },
          ),
        ]),
      );
    });
  });
}

/// Create / edit a payment method (card, bank, UPI, wallet, store billing…).
Future<String?> showPaymentMethodForm(BuildContext context, WidgetRef ref, {PaymentMethod? existing}) {
  final e = existing;
  final label = TextEditingController(text: e?.label ?? '');
  final hint = TextEditingController(text: e?.identifierHint ?? '');
  final notes = TextEditingController(text: e?.notes ?? '');
  var kind = enumFromName(PaymentMethodKind.values, e?.kind, PaymentMethodKind.card);
  String? cardId = e?.cardId;
  String? bankAccountId = e?.bankAccountId;
  String? platformId = e?.platformId;
  String? platformName;
  var isDefault = e?.isDefault ?? false;
  final formKey = GlobalKey<FormState>();

  return showFormSheet<String>(context, title: e == null ? 'Add payment method' : 'Edit payment method', builder: (ctx, close) {
    return StatefulBuilder(builder: (ctx, setState) {
      final cards = ref.watch(cardsProvider).value ?? const <PaymentCard>[];
      final banks = ref.watch(bankAccountsProvider).value ?? const <BankAccount>[];
      final platforms = ref.watch(allPlatformsProvider).value ?? const <Platform>[];
      platformName ??= platformId == null ? null : platforms.where((p) => p.id == platformId).firstOrNull?.name;
      final wantsCard = kind == PaymentMethodKind.card;
      final wantsBank = kind == PaymentMethodKind.bankAccount || kind == PaymentMethodKind.upi;
      final wantsPlatform = kind == PaymentMethodKind.wallet || kind == PaymentMethodKind.paypal || kind == PaymentMethodKind.upi || kind == PaymentMethodKind.appStore || kind == PaymentMethodKind.playStore || kind == PaymentMethodKind.other;
      final wantsHint = kind == PaymentMethodKind.upi || kind == PaymentMethodKind.wallet || kind == PaymentMethodKind.paypal || kind == PaymentMethodKind.other;
      return Form(
        key: formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          AppTextField(controller: label, label: 'Label', hint: 'HDFC Visa, Studio UPI, Apple ID billing…', autofocus: e == null, validator: (v) => requiredValidator(v, 'Label')),
          AppDropdown<PaymentMethodKind>(label: 'Kind', value: kind, items: [for (final k in PaymentMethodKind.values) (k, k.label)], onChanged: (v) => setState(() => kind = v ?? kind)),
          if (wantsCard) AppDropdown<String>(label: 'Card', value: cardId, allowNull: true, nullLabel: 'Not linked', items: [for (final c in cards) (c.id, c.last4 == null ? c.nickname : '${c.nickname} · •••• ${c.last4}')], onChanged: (v) => setState(() => cardId = v)),
          if (wantsBank) AppDropdown<String>(label: 'Bank account', value: bankAccountId, allowNull: true, nullLabel: 'Not linked', items: [for (final b in banks) (b.id, '${b.nickname} · ${b.bankName}')], onChanged: (v) => setState(() => bankAccountId = v)),
          if (wantsPlatform)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(children: [
                Expanded(child: InputDecorator(decoration: const InputDecoration(labelText: 'Provider platform'), child: Text(platformName ?? 'Not linked', style: TextStyle(color: platformName == null ? ctx.colors.textMuted : ctx.colors.text)))),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () async {
                    final p = await showPlatformPicker(ctx, ref, category: 'payments', title: 'Choose provider');
                    if (p != null) setState(() { platformId = p.id; platformName = p.name; });
                  },
                  child: const Text('Pick'),
                ),
                if (platformId != null) IconButton(tooltip: 'Clear provider', icon: const Icon(Icons.clear, size: 16), onPressed: () => setState(() { platformId = null; platformName = null; })),
              ]),
            ),
          if (wantsHint) AppTextField(controller: hint, label: kind == PaymentMethodKind.upi ? 'UPI ID' : 'Identifier hint', hint: kind == PaymentMethodKind.upi ? 'name@bank' : 'Email or handle used for this method', helper: 'Non-secret identifier only.'),
          SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('Default payment method'), value: isDefault, onChanged: (v) => setState(() => isDefault = v)),
          AppTextField(controller: notes, label: 'Notes', maxLines: 2),
          FormActions(
            onCancel: close,
            onSave: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                final saved = await ref.read(financeRepositoryProvider).upsertPaymentMethod(
                      id: e?.id,
                      label: label.text,
                      kind: kind,
                      cardId: wantsCard ? cardId : null,
                      bankAccountId: wantsBank ? bankAccountId : null,
                      platformId: wantsPlatform ? platformId : null,
                      identifierHint: wantsHint ? hint.text : null,
                      isDefault: isDefault,
                      notes: notes.text,
                    );
                close(saved.id);
              } catch (err) {
                if (ctx.mounted) showToast(ctx, friendlyError(err), error: true);
              }
            },
          ),
        ]),
      );
    });
  });
}
