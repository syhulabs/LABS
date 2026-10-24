import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../data/db/app_database.dart';
import '../../domain/enums.dart';
import '../../shared/widgets/form_sheet.dart';
import '../../shared/widgets/pickers.dart';
import '../../shared/widgets/toast.dart';

/// Create / edit an artist identity. Returns the saved id.
Future<String?> showArtistForm(BuildContext context, WidgetRef ref, {Artist? existing, String? presetLabelId}) async {
  final name = TextEditingController(text: existing?.name ?? '');
  final genre = TextEditingController(text: existing?.genre ?? '');
  final bio = TextEditingController(text: existing?.bio ?? '');
  final notes = TextEditingController(text: existing?.notes ?? '');
  final tags = TextEditingController(
    text: existing == null ? '' : (await ref.read(tagRepositoryProvider).watchTagsFor(EntityType.artist, existing.id).first).map((t) => t.name).join(', '),
  );
  String? labelId = existing?.labelId ?? presetLabelId;
  String? emailId = existing?.primaryEmailId;
  final formKey = GlobalKey<FormState>();
  final suggestions = (ref.read(tagsProvider).value ?? []).map((t) => t.name).toList();
  if (!context.mounted) return null;
  return showFormSheet<String>(context, title: existing == null ? 'Add artist' : 'Edit ${existing.name}', builder: (ctx, close) {
    return StatefulBuilder(builder: (ctx, setState) {
      final labels = (ref.watch(organizationsProvider).value ?? const <Organization>[]).where((o) => o.kind == OrganizationKind.recordLabel.name).toList();
      return Form(
        key: formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          AppTextField(controller: name, label: 'Artist name', autofocus: existing == null, validator: (v) => requiredValidator(v, 'Artist name'), prefixIcon: Icons.mic_none),
          AppTextField(controller: genre, label: 'Genre', hint: 'Ambient, lo-fi, orchestral…'),
          AppTextField(controller: bio, label: 'Bio', maxLines: 3),
          AppDropdown<String>(label: 'Record label', value: labelId, allowNull: true, nullLabel: 'Independent / none', items: [for (final l in labels) (l.id, l.name)], onChanged: (v) => setState(() => labelId = v)),
          EmailPicker(label: 'Primary email', value: emailId, onChanged: (v) => setState(() => emailId = v)),
          TagsField(controller: tags, suggestions: suggestions),
          AppTextField(controller: notes, label: 'Notes', maxLines: 2),
          FormActions(
            onCancel: close,
            onSave: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                final saved = await ref.read(projectRepositoryProvider).upsertArtist(id: existing?.id, name: name.text, genre: genre.text, bio: bio.text, labelId: labelId, primaryEmailId: emailId, notes: notes.text);
                await ref.read(tagRepositoryProvider).setTags(EntityType.artist, saved.id, TagsField.parse(tags.text));
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
