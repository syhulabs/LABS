import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme/app_theme.dart';
import '../../data/catalog/catalog_service.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/account_repository.dart';
import '../../domain/enums.dart';
import '../../shared/widgets/form_sheet.dart';
import '../../shared/widgets/pickers.dart';
import '../../shared/widgets/platform_logo.dart';
import '../../shared/widgets/toast.dart';

/// Create/edit a service account. If [platform] is null the user picks one.
/// Returns the saved account id.
Future<String?> showAccountForm(BuildContext context, WidgetRef ref, {Platform? platform, AccountView? existing, String? presetEmailId, Classification? presetClassification}) async {
  var chosen = platform ?? existing?.platform;
  if (chosen == null) {
    chosen = await showPlatformPicker(context, ref, title: 'Which platform is this account on?');
    if (chosen == null || !context.mounted) return null;
  }
  final p = chosen;
  final a = existing?.account;
  final name = TextEditingController(text: a?.accountName ?? (presetClassification == Classification.business ? 'Business' : 'Personal'));
  final username = TextEditingController(text: a?.username ?? '');
  final display = TextEditingController(text: a?.displayName ?? '');
  final url = TextEditingController(text: a?.profileUrl ?? '');
  final purpose = TextEditingController(text: a?.purpose ?? '');
  final plan = TextEditingController(text: a?.plan ?? '');
  final notes = TextEditingController(text: a?.notes ?? '');
  final tags = TextEditingController(text: existing == null ? '' : (await ref.read(tagRepositoryProvider).watchTagsFor(EntityType.serviceAccount, a!.id).first).map((t) => t.name).join(', '));
  String? emailId = a?.emailIdentityId ?? presetEmailId;
  var status = enumFromName(AccountStatus.values, a?.status, AccountStatus.active);
  var classification = enumFromName(Classification.values, a?.classification, presetClassification ?? Classification.personal);
  BillingCycle? cycle = a?.billingCycle == null ? null : enumFromName(BillingCycle.values, a!.billingCycle, BillingCycle.monthly);
  var isApi = a?.isApiAccount ?? false;
  String? credentialRefId = a?.credentialRefId;
  final formKey = GlobalKey<FormState>();
  final existingTagNames = (ref.read(tagsProvider).value ?? []).map((t) => t.name).toList();
  final isAi = p.categoryIds.any((c) => c.startsWith('ai_'));

  if (!context.mounted) return null;
  return showFormSheet<String>(context, title: existing == null ? 'Add ${p.name} account' : 'Edit ${p.name} account', builder: (ctx, close) {
    return StatefulBuilder(builder: (ctx, setState) {
      final refs = ref.watch(credentialRefsProvider).value ?? const <CredentialReference>[];
      return Form(
        key: formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            PlatformLogo(platform: p, size: 40),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.name, style: ctx.text.titleMedium),
              Text('You can have several accounts on the same platform.', style: ctx.text.bodySmall?.copyWith(color: ctx.colors.textMuted)),
            ])),
          ]),
          const SizedBox(height: 16),
          AppTextField(controller: name, label: 'Account label', hint: 'Personal, Studio, Business…', autofocus: existing == null, validator: (v) => requiredValidator(v, 'Account label')),
          EmailPicker(value: emailId, onChanged: (v) => setState(() => emailId = v)),
          ClassificationToggle(value: classification, onChanged: (v) => setState(() => classification = v)),
          Row(children: [
            Expanded(child: AppTextField(controller: username, label: 'Username / handle', prefixIcon: Icons.person_outline)),
            const SizedBox(width: 10),
            Expanded(child: AppTextField(controller: display, label: 'Display name')),
          ]),
          AppTextField(controller: url, label: 'Profile URL', hint: 'https://…', prefixIcon: Icons.link, validator: urlValidator, keyboardType: TextInputType.url),
          AppTextField(controller: purpose, label: 'Purpose', hint: 'What this account is for'),
          AppDropdown<AccountStatus>(label: 'Status', value: status, items: [for (final s in AccountStatus.values) (s, s.label)], onChanged: (v) => setState(() => status = v ?? status)),
          FormSectionTitle('Plan & billing', hint: 'Track the paid plan here; add the actual cost under Subscriptions.'),
          Row(children: [
            Expanded(child: AppTextField(controller: plan, label: 'Plan', hint: isAi ? 'Plus, Pro, Team, API…' : 'Free, Premium…')),
            const SizedBox(width: 10),
            Expanded(child: AppDropdown<BillingCycle>(label: 'Billing cycle', value: cycle, allowNull: true, nullLabel: 'Not set', items: [for (final c in BillingCycle.values) (c, c.label)], onChanged: (v) => setState(() => cycle = v))),
          ]),
          if (isAi)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('API / developer account'),
              subtitle: Text('Keys never go here: store them in the Secure Vault.', style: TextStyle(color: ctx.colors.textMuted, fontSize: 12)),
              value: isApi,
              onChanged: (v) => setState(() => isApi = v),
            ),
          FormSectionTitle('Credential reference', hint: 'Point to where the password lives (1Password, Bitwarden, iCloud Keychain…). The password itself is not stored here.'),
          AppDropdown<String>(label: 'Credential reference', value: credentialRefId, allowNull: true, nullLabel: 'None', items: [for (final r in refs) (r.id, r.manager == null ? r.label : '${r.label} · ${r.manager}')], onChanged: (v) => setState(() => credentialRefId = v)),
          TagsField(controller: tags, suggestions: existingTagNames),
          AppTextField(controller: notes, label: 'Notes', maxLines: 3),
          FormActions(
            onCancel: close,
            destructiveLabel: existing != null && existing.account.archivedAt == null ? 'Archive' : null,
            onDestructive: existing == null ? null : () async {
              await ref.read(accountRepositoryProvider).setArchived(existing.account.id, true);
              close(existing.account.id);
            },
            onSave: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                final saved = await ref.read(accountRepositoryProvider).upsert(
                      id: a?.id,
                      platformId: p.id,
                      emailIdentityId: emailId,
                      accountName: name.text,
                      username: username.text,
                      displayName: display.text,
                      profileUrl: url.text,
                      purpose: purpose.text,
                      status: status,
                      classification: classification,
                      plan: plan.text,
                      billingCycle: cycle,
                      isApiAccount: isApi,
                      notes: notes.text,
                      credentialRefId: credentialRefId,
                    );
                await ref.read(tagRepositoryProvider).setTags(EntityType.serviceAccount, saved.id, TagsField.parse(tags.text));
                close(saved.id);
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
