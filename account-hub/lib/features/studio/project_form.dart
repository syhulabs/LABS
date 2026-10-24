import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../data/db/app_database.dart';
import '../../domain/enums.dart';
import '../../shared/widgets/form_sheet.dart';
import '../../shared/widgets/toast.dart';
import 'studio_providers.dart';

/// Create / edit a creative project (song, release, app, game, comic…).
Future<String?> showProjectForm(BuildContext context, WidgetRef ref, {Project? existing, String? presetOrganizationId, String? presetArtistId}) async {
  final name = TextEditingController(text: existing?.name ?? '');
  final desc = TextEditingController(text: existing?.description ?? '');
  final url = TextEditingController(text: existing?.url ?? '');
  final notes = TextEditingController(text: existing?.notes ?? '');
  final tags = TextEditingController(
    text: existing == null ? '' : (await ref.read(tagRepositoryProvider).watchTagsFor(EntityType.project, existing.id).first).map((t) => t.name).join(', '),
  );
  var kind = enumFromName(ProjectKind.values, existing?.kind, ProjectKind.app);
  var status = enumFromName(ProjectStatus.values, existing?.status, ProjectStatus.inProgress);
  var classification = enumFromName(Classification.values, existing?.classification, Classification.personal);
  String? orgId = existing?.organizationId ?? presetOrganizationId;
  String? artistId = existing?.artistId ?? presetArtistId;
  final formKey = GlobalKey<FormState>();
  final suggestions = (ref.read(tagsProvider).value ?? []).map((t) => t.name).toList();
  if (!context.mounted) return null;
  return showFormSheet<String>(context, title: existing == null ? 'Add project' : 'Edit ${existing.name}', builder: (ctx, close) {
    return StatefulBuilder(builder: (ctx, setState) {
      final orgs = ref.watch(organizationsProvider).value ?? const <Organization>[];
      final artists = ref.watch(artistsProvider).value ?? const <Artist>[];
      return Form(
        key: formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          AppTextField(controller: name, label: 'Project name', autofocus: existing == null, validator: (v) => requiredValidator(v, 'Project name'), prefixIcon: Icons.folder_outlined),
          Row(children: [
            Expanded(child: AppDropdown<ProjectKind>(label: 'Kind', value: kind, items: [for (final k in ProjectKind.values) (k, k.label)], onChanged: (v) => setState(() => kind = v ?? kind))),
            const SizedBox(width: 10),
            Expanded(child: AppDropdown<ProjectStatus>(label: 'Status', value: status, items: [for (final s in ProjectStatus.values) (s, s.label)], onChanged: (v) => setState(() => status = v ?? status))),
          ]),
          ClassificationToggle(value: classification, onChanged: (v) => setState(() => classification = v)),
          AppTextField(controller: desc, label: 'Description', maxLines: 2),
          AppTextField(controller: url, label: 'URL', hint: 'Store page, repository, site…', validator: urlValidator, keyboardType: TextInputType.url, prefixIcon: Icons.link),
          FormSectionTitle('Belongs to'),
          Row(children: [
            Expanded(child: AppDropdown<String>(label: 'Studio / business / label', value: orgId, allowNull: true, items: [for (final o in orgs) (o.id, o.name)], onChanged: (v) => setState(() => orgId = v))),
            const SizedBox(width: 10),
            Expanded(child: AppDropdown<String>(label: 'Artist', value: artistId, allowNull: true, items: [for (final a in artists) (a.id, a.name)], onChanged: (v) => setState(() => artistId = v))),
          ]),
          TagsField(controller: tags, suggestions: suggestions),
          AppTextField(controller: notes, label: 'Notes', maxLines: 3),
          FormActions(
            onCancel: close,
            onSave: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                final saved = await ref.read(projectRepositoryProvider).upsertProject(
                      id: existing?.id, name: name.text, kind: kind, status: status, description: desc.text, url: url.text,
                      organizationId: orgId, artistId: artistId, classification: classification, notes: notes.text,
                    );
                await ref.read(tagRepositoryProvider).setTags(EntityType.project, saved.id, TagsField.parse(tags.text));
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

/// Create / edit a document reference (URL or local file path).
Future<String?> showDocumentForm(BuildContext context, WidgetRef ref, {DocumentReference? existing}) {
  final title = TextEditingController(text: existing?.title ?? '');
  final locator = TextEditingController(text: existing?.locator ?? '');
  final notes = TextEditingController(text: existing?.notes ?? '');
  String? kind = existing?.kind;
  final formKey = GlobalKey<FormState>();
  return showFormSheet<String>(context, title: existing == null ? 'Add document' : 'Edit ${existing.title}', maxWidth: 500, builder: (ctx, close) {
    return StatefulBuilder(builder: (ctx, setState) {
      return Form(
        key: formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          AppTextField(controller: title, label: 'Title', autofocus: existing == null, validator: (v) => requiredValidator(v, 'Title'), prefixIcon: Icons.description_outlined),
          AppTextField(controller: locator, label: 'Link or file path', hint: 'https://… or /Users/you/Documents/contract.pdf', validator: (v) => requiredValidator(v, 'Link or file path'), prefixIcon: Icons.attach_file),
          AppDropdown<String>(label: 'Kind', value: kind, allowNull: true, nullLabel: 'Not set', items: [for (final k in documentKinds) (k, k)], onChanged: (v) => setState(() => kind = v)),
          AppTextField(controller: notes, label: 'Notes', maxLines: 2),
          FormActions(
            onCancel: close,
            onSave: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                final saved = await ref.read(projectRepositoryProvider).upsertDocument(id: existing?.id, title: title.text, locator: locator.text, kind: kind, notes: notes.text);
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
