import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../domain/enums.dart';
import 'form_sheet.dart';
import 'pickers.dart';
import 'section_header.dart';
import 'toast.dart';

/// Shows links, tags and custom fields for an entity, with inline editing.
/// Reused by every detail view so relationships behave identically.
class RelationsPanel extends ConsumerWidget {
  const RelationsPanel({super.key, required this.type, required this.id, this.showLinks = true, this.showTags = true, this.showFields = true});
  final EntityType type;
  final String id;
  final bool showLinks;
  final bool showTags;
  final bool showFields;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final links = ref.watch(linksProvider((type, id))).value ?? const [];
    final tags = ref.watch(tagsForProvider((type, id))).value ?? const [];
    final fields = ref.watch(fieldsForProvider((type, id))).value ?? const [];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (showLinks) ...[
        SectionHeader(
          title: 'Related',
          padding: const EdgeInsets.only(top: 8, bottom: 6),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.link, size: 16),
              label: const Text('Link'),
              onPressed: () async {
                final picked = await showEntityPicker(context, ref);
                if (picked == null || !context.mounted) return;
                if (picked.$1 == type && picked.$2 == id) return;
                await guard(context, () => ref.read(projectRepositoryProvider).link(type, id, picked.$1, picked.$2));
              },
            ),
          ],
        ),
        if (links.isEmpty)
          Text('Nothing linked yet. Link projects, accounts, emails, subscriptions or documents.', style: context.text.bodySmall?.copyWith(color: c.textMuted))
        else
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final l in links)
              InputChip(
                avatar: Icon(iconForEntity(l.type), size: 16),
                label: Text(l.subtitle == null ? l.title : '${l.title} · ${l.subtitle}', overflow: TextOverflow.ellipsis),
                onPressed: () => context.push(routeForEntity(l.type, l.id)),
                onDeleted: () => ref.read(projectRepositoryProvider).unlink(l.link.id),
                deleteIcon: const Icon(Icons.close, size: 14),
              ),
          ]),
      ],
      if (showTags) ...[
        SectionHeader(
          title: 'Tags',
          padding: const EdgeInsets.only(top: 18, bottom: 6),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text('Edit'),
              onPressed: () => _editTags(context, ref, tags.map((t) => t.name).toList()),
            ),
          ],
        ),
        if (tags.isEmpty)
          Text('No tags.', style: context.text.bodySmall?.copyWith(color: c.textMuted))
        else
          Wrap(spacing: 6, runSpacing: 6, children: [for (final t in tags) Chip(label: Text('#${t.name}'))]),
      ],
      if (showFields) ...[
        SectionHeader(
          title: 'Custom fields',
          padding: const EdgeInsets.only(top: 18, bottom: 6),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text('Edit'),
              onPressed: () => _editFields(context, ref, [for (final f in fields) (f.label, f.value)]),
            ),
          ],
        ),
        if (fields.isEmpty)
          Text('No custom fields.', style: context.text.bodySmall?.copyWith(color: c.textMuted))
        else
          Column(children: [
            for (final f in fields)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [
                  SizedBox(width: 140, child: Text(f.label, style: context.text.bodySmall?.copyWith(color: c.textMuted))),
                  Expanded(child: SelectableText(f.value)),
                ]),
              ),
          ]),
      ],
    ]);
  }

  Future<void> _editTags(BuildContext context, WidgetRef ref, List<String> current) async {
    final ctrl = TextEditingController(text: current.join(', '));
    final all = (ref.read(tagsProvider).value ?? []).map((t) => t.name).toList();
    await showFormSheet<void>(context, title: 'Edit tags', maxWidth: 440, builder: (ctx, close) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        TagsField(controller: ctrl, suggestions: all),
        FormActions(onCancel: close, onSave: () async {
          await ref.read(tagRepositoryProvider).setTags(type, id, TagsField.parse(ctrl.text));
          close();
        }),
      ]);
    });
  }

  Future<void> _editFields(BuildContext context, WidgetRef ref, List<(String, String)> current) async {
    var rows = List.of(current);
    await showFormSheet<void>(context, title: 'Edit custom fields', maxWidth: 520, builder: (ctx, close) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        CustomFieldsEditor(initial: current, onChanged: (v) => rows = v),
        FormActions(onCancel: close, onSave: () async {
          await ref.read(tagRepositoryProvider).setFields(type, id, rows);
          close();
        }),
      ]);
    });
  }
}

IconData iconForEntity(EntityType t) => switch (t) {
      EntityType.platform => Icons.apps,
      EntityType.emailIdentity => Icons.alternate_email,
      EntityType.serviceAccount => Icons.person_outline,
      EntityType.youtubeChannel => Icons.play_circle_outline,
      EntityType.project => Icons.folder_outlined,
      EntityType.organization => Icons.business_outlined,
      EntityType.artist => Icons.mic_none,
      EntityType.bankAccount => Icons.account_balance_outlined,
      EntityType.paymentCard => Icons.credit_card,
      EntityType.paymentMethod => Icons.payments_outlined,
      EntityType.subscription => Icons.autorenew,
      EntityType.credentialReference => Icons.key_outlined,
      EntityType.documentReference => Icons.description_outlined,
      EntityType.secureItem => Icons.lock_outline,
    };
