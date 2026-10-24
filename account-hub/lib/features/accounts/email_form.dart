import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme/app_theme.dart';
import '../../data/db/app_database.dart';
import '../../domain/enums.dart';
import '../../shared/widgets/form_sheet.dart';
import '../../shared/widgets/toast.dart';

/// Full create/edit form for a reusable email identity. Returns the saved id.
Future<String?> showEmailForm(BuildContext context, WidgetRef ref, {EmailIdentity? existing}) async {
  final e = existing;
  final address = TextEditingController(text: e?.address ?? '');
  final provider = TextEditingController(text: e?.provider ?? '');
  final display = TextEditingController(text: e?.displayName ?? '');
  final purpose = TextEditingController(text: e?.purpose ?? '');
  final recovery = TextEditingController(text: e?.recoveryNotes ?? '');
  final notes = TextEditingController(text: e?.notes ?? '');
  final tags = TextEditingController(
    text: e == null ? '' : (await ref.read(tagRepositoryProvider).watchTagsFor(EntityType.emailIdentity, e.id).first).map((t) => t.name).join(', '),
  );
  var classification = enumFromName(Classification.values, e?.classification, Classification.personal);
  var status = enumFromName(AccountStatus.values, e?.status, AccountStatus.active);
  final key = GlobalKey<FormState>();
  final suggestions = (ref.read(tagsProvider).value ?? []).map((t) => t.name).toList();
  if (!context.mounted) return null;
  return showFormSheet<String>(context, title: e == null ? 'New email identity' : 'Edit email identity', builder: (ctx, close) {
    return StatefulBuilder(builder: (ctx, setState) {
      Future<void> save() async {
        if (!key.currentState!.validate()) return;
        try {
          final saved = await ref.read(emailRepositoryProvider).upsert(
                id: e?.id,
                address: address.text,
                provider: provider.text.trim().isEmpty ? null : provider.text.trim(),
                displayName: display.text.trim().isEmpty ? null : display.text.trim(),
                purpose: purpose.text.trim().isEmpty ? null : purpose.text.trim(),
                classification: classification,
                recoveryNotes: recovery.text.trim().isEmpty ? null : recovery.text.trim(),
                notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
                status: status,
              );
          await ref.read(tagRepositoryProvider).setTags(EntityType.emailIdentity, saved.id, TagsField.parse(tags.text));
          close(saved.id);
        } catch (err) {
          if (ctx.mounted) showToast(ctx, friendlyError(err), error: true);
        }
      }

      return Form(
        key: key,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('One identity per address. Reuse it across any number of accounts and channels.', style: ctx.text.bodySmall?.copyWith(color: ctx.colors.textMuted)),
          const SizedBox(height: 12),
          AppTextField(
            controller: address,
            label: 'Email address',
            autofocus: e == null,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.alternate_email,
            validator: (v) => (v == null || !v.trim().contains('@')) ? 'Enter a valid email address' : null,
          ),
          Row(children: [
            Expanded(child: AppTextField(controller: provider, label: 'Provider', hint: 'Gmail, iCloud, Proton… (auto-detected if empty)')),
            const SizedBox(width: 10),
            Expanded(child: AppTextField(controller: display, label: 'Display name')),
          ]),
          AppTextField(controller: purpose, label: 'Purpose', hint: 'Studio, YouTube, banking, sign-ups…'),
          ClassificationToggle(value: classification, onChanged: (v) => setState(() => classification = v)),
          AppDropdown<AccountStatus>(label: 'Status', value: status, items: [for (final s in AccountStatus.values) (s, s.label)], onChanged: (v) => setState(() => status = v ?? status)),
          FormSectionTitle('Recovery', hint: 'Non-secret hints only (e.g. "recovery phone ends 42", "backup email: personal"). Recovery codes belong in the Secure Vault.'),
          AppTextField(controller: recovery, label: 'Recovery notes', maxLines: 2),
          TagsField(controller: tags, suggestions: suggestions),
          AppTextField(controller: notes, label: 'Notes', maxLines: 3),
          FormActions(onCancel: close, onSave: save),
        ]),
      );
    });
  });
}
