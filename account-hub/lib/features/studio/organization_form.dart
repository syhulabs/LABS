import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../data/db/app_database.dart';
import '../../domain/enums.dart';
import '../../shared/widgets/form_sheet.dart';
import '../../shared/widgets/pickers.dart';
import '../../shared/widgets/toast.dart';

/// Create / edit a business, studio or record label. Returns the saved id.
Future<String?> showOrganizationForm(BuildContext context, WidgetRef ref, {Organization? existing, OrganizationKind? presetKind, bool lockKind = false}) async {
  final name = TextEditingController(text: existing?.name ?? '');
  final desc = TextEditingController(text: existing?.description ?? '');
  final web = TextEditingController(text: existing?.website ?? '');
  final notes = TextEditingController(text: existing?.notes ?? '');
  final tags = TextEditingController(
    text: existing == null ? '' : (await ref.read(tagRepositoryProvider).watchTagsFor(EntityType.organization, existing.id).first).map((t) => t.name).join(', '),
  );
  var kind = existing == null ? (presetKind ?? OrganizationKind.business) : enumFromName(OrganizationKind.values, existing.kind, OrganizationKind.business);
  String? emailId = existing?.primaryEmailId;
  final formKey = GlobalKey<FormState>();
  final suggestions = (ref.read(tagsProvider).value ?? []).map((t) => t.name).toList();
  if (!context.mounted) return null;
  return showFormSheet<String>(context, title: existing == null ? 'Add ${kind.label.toLowerCase()}' : 'Edit ${existing.name}', builder: (ctx, close) {
    return StatefulBuilder(builder: (ctx, setState) {
      return Form(
        key: formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          AppTextField(controller: name, label: 'Name', autofocus: existing == null, validator: (v) => requiredValidator(v, 'Name'), prefixIcon: Icons.business_outlined),
          if (!lockKind)
            AppDropdown<OrganizationKind>(label: 'Kind', value: kind, items: [for (final k in OrganizationKind.values) (k, k.label)], onChanged: (v) => setState(() => kind = v ?? kind)),
          AppTextField(controller: desc, label: 'Description', maxLines: 2),
          AppTextField(controller: web, label: 'Website', hint: 'https://…', validator: urlValidator, keyboardType: TextInputType.url, prefixIcon: Icons.link),
          EmailPicker(label: 'Primary email', value: emailId, onChanged: (v) => setState(() => emailId = v)),
          TagsField(controller: tags, suggestions: suggestions),
          AppTextField(controller: notes, label: 'Notes', maxLines: 3),
          FormActions(
            onCancel: close,
            onSave: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                final saved = await ref.read(projectRepositoryProvider).upsertOrganization(
                      id: existing?.id, name: name.text, kind: kind, description: desc.text, website: web.text, primaryEmailId: emailId, notes: notes.text,
                    );
                await ref.read(tagRepositoryProvider).setTags(EntityType.organization, saved.id, TagsField.parse(tags.text));
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
