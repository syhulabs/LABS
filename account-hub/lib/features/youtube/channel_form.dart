import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme/app_theme.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/youtube_repository.dart';
import '../../domain/enums.dart';
import '../../shared/widgets/form_sheet.dart';
import '../../shared/widgets/pickers.dart';
import '../../shared/widgets/toast.dart';
import 'youtube_providers.dart';

/// Create / edit a YouTube channel. Returns the saved channel id.
Future<String?> showChannelForm(BuildContext context, WidgetRef ref, {ChannelView? existing, String? presetOwnerEmailId}) async {
  final ch = existing?.channel;
  final name = TextEditingController(text: ch?.name ?? '');
  final handle = TextEditingController(text: ch?.handle ?? '');
  final channelId = TextEditingController(text: ch?.channelId ?? '');
  final url = TextEditingController(text: ch?.url ?? '');
  final purpose = TextEditingController(text: ch?.purpose ?? '');
  final branding = TextEditingController(text: ch?.brandingNotes ?? '');
  final notes = TextEditingController(text: ch?.notes ?? '');
  final tags = TextEditingController(
    text: ch == null ? '' : (await ref.read(tagRepositoryProvider).watchTagsFor(EntityType.youtubeChannel, ch.id).first).map((t) => t.name).join(', '),
  );
  String? channelType = ch?.channelType;
  var status = enumFromName(AccountStatus.values, ch?.status, AccountStatus.active);
  String? ownerEmailId = ch?.ownerEmailId ?? presetOwnerEmailId;
  String? artistId = ch?.artistId;
  String? organizationId = ch?.organizationId;
  final managers = <String, ChannelRole>{for (final (e, r) in existing?.managers ?? const <(EmailIdentity, ChannelRole)>[]) e.id: r};
  final formKey = GlobalKey<FormState>();
  final tagSuggestions = (ref.read(tagsProvider).value ?? []).map((t) => t.name).toList();

  if (!context.mounted) return null;
  return showFormSheet<String>(context, title: existing == null ? 'Add YouTube channel' : 'Edit ${ch!.name}', builder: (ctx, close) {
    return StatefulBuilder(builder: (ctx, setState) {
      final emails = ref.watch(emailsProvider).value ?? const <EmailIdentity>[];
      final artists = ref.watch(artistsProvider).value ?? const <Artist>[];
      final orgs = ref.watch(organizationsProvider).value ?? const <Organization>[];
      final managerCandidates = emails.where((e) => e.id != ownerEmailId).toList();
      return Form(
        key: formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          AppTextField(controller: name, label: 'Channel name', autofocus: existing == null, validator: (v) => requiredValidator(v, 'Channel name'), prefixIcon: Icons.play_circle_outline),
          Row(children: [
            Expanded(child: AppTextField(controller: handle, label: 'Handle', hint: '@yourchannel', prefixIcon: Icons.alternate_email)),
            const SizedBox(width: 10),
            Expanded(child: AppTextField(controller: channelId, label: 'Channel ID', hint: 'UC…')),
          ]),
          AppTextField(controller: url, label: 'Channel URL', hint: 'https://youtube.com/@…', validator: urlValidator, keyboardType: TextInputType.url, prefixIcon: Icons.link),
          Row(children: [
            Expanded(child: AppDropdown<String>(label: 'Channel type', value: channelType, allowNull: true, nullLabel: 'Not set', items: [for (final t in channelTypes) (t, t)], onChanged: (v) => setState(() => channelType = v))),
            const SizedBox(width: 10),
            Expanded(child: AppDropdown<AccountStatus>(label: 'Status', value: status, items: [for (final s in AccountStatus.values) (s, s.label)], onChanged: (v) => setState(() => status = v ?? status))),
          ]),
          AppTextField(controller: purpose, label: 'Purpose', hint: 'What this channel is for'),
          FormSectionTitle('Ownership & access', hint: 'One Google account can own many channels. Add other identities that manage this channel.'),
          EmailPicker(label: 'Owning Google account', value: ownerEmailId, onChanged: (v) => setState(() { ownerEmailId = v; managers.remove(v); })),
          if (managerCandidates.isEmpty)
            Padding(padding: const EdgeInsets.only(bottom: 12), child: Text('Add more email identities to assign managers.', style: ctx.text.bodySmall?.copyWith(color: ctx.colors.textMuted)))
          else
            Container(
              decoration: BoxDecoration(border: Border.all(color: ctx.colors.border), borderRadius: BorderRadius.circular(AppTheme.radiusSmall)),
              child: Column(children: [
                for (final e in managerCandidates)
                  CheckboxListTile(
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(e.address, maxLines: 1, overflow: TextOverflow.ellipsis),
                    value: managers.containsKey(e.id),
                    secondary: managers.containsKey(e.id)
                        ? DropdownButton<ChannelRole>(
                            value: managers[e.id],
                            underline: const SizedBox.shrink(),
                            dropdownColor: ctx.colors.surfaceAlt,
                            items: [for (final r in ChannelRole.values.where((r) => r != ChannelRole.owner)) DropdownMenuItem(value: r, child: Text(r.label))],
                            onChanged: (r) => setState(() => managers[e.id] = r ?? ChannelRole.manager),
                          )
                        : null,
                    onChanged: (v) => setState(() => v == true ? managers[e.id] = ChannelRole.manager : managers.remove(e.id)),
                  ),
              ]),
            ),
          const SizedBox(height: 12),
          FormSectionTitle('Associations'),
          Row(children: [
            Expanded(child: AppDropdown<String>(label: 'Artist', value: artistId, allowNull: true, items: [for (final a in artists) (a.id, a.name)], onChanged: (v) => setState(() => artistId = v))),
            const SizedBox(width: 10),
            Expanded(child: AppDropdown<String>(label: 'Studio / business / label', value: organizationId, allowNull: true, items: [for (final o in orgs) (o.id, o.name)], onChanged: (v) => setState(() => organizationId = v))),
          ]),
          AppTextField(controller: branding, label: 'Branding notes', maxLines: 2, hint: 'Colors, intro, thumbnail style…'),
          TagsField(controller: tags, suggestions: tagSuggestions),
          AppTextField(controller: notes, label: 'Notes', maxLines: 3),
          FormActions(
            onCancel: close,
            onSave: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                final saved = await ref.read(youtubeRepositoryProvider).upsert(
                      id: ch?.id,
                      name: name.text,
                      handle: handle.text,
                      channelId: channelId.text,
                      url: url.text,
                      channelType: channelType,
                      purpose: purpose.text,
                      brandingNotes: branding.text,
                      status: status,
                      ownerEmailId: ownerEmailId,
                      artistId: artistId,
                      organizationId: organizationId,
                      notes: notes.text,
                      managers: [for (final e in managers.entries) (e.key, e.value)],
                    );
                await ref.read(tagRepositoryProvider).setTags(EntityType.youtubeChannel, saved.id, TagsField.parse(tags.text));
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

String channelLink(YoutubeChannel c) {
  if (c.url != null && c.url!.isNotEmpty) return c.url!;
  if (c.handle != null && c.handle!.isNotEmpty) return 'https://www.youtube.com/${c.handle}';
  if (c.channelId != null && c.channelId!.isNotEmpty) return 'https://www.youtube.com/channel/${c.channelId}';
  return 'https://www.youtube.com';
}
