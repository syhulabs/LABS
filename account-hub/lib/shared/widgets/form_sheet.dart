import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/theme/app_theme.dart';
import '../../domain/enums.dart';
import '../../domain/money.dart';

/// Shows an editing form. Dialog on desktop/tablet, full-screen page on phones.
/// The builder receives a `close(result)` callback.
Future<T?> showFormSheet<T>(
  BuildContext context, {
  required String title,
  required Widget Function(BuildContext ctx, void Function([T? result]) close) builder,
  double maxWidth = 560,
}) {
  if (context.isCompact) {
    return Navigator.of(context).push<T>(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (ctx) => Scaffold(
        appBar: AppBar(title: Text(title), backgroundColor: ctx.colors.surface),
        body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: builder(ctx, ([r]) => Navigator.of(ctx).pop(r)))),
      ),
    ));
  }
  return showDialog<T>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: MediaQuery.sizeOf(ctx).height - 80),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 12, 8),
            child: Row(children: [
              Expanded(child: Text(title, style: ctx.text.titleLarge)),
              IconButton(tooltip: 'Close', onPressed: () => Navigator.of(ctx).pop(), icon: const Icon(Icons.close)),
            ]),
          ),
          Flexible(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(24, 4, 24, 24), child: builder(ctx, ([r]) => Navigator.of(ctx).pop(r)))),
        ]),
      ),
    ),
  );
}

/// Standard Save / Cancel row with optional destructive action on the left.
class FormActions extends StatelessWidget {
  const FormActions({super.key, required this.onSave, required this.onCancel, this.saveLabel = 'Save', this.saving = false, this.destructiveLabel, this.onDestructive});
  final VoidCallback? onSave;
  final VoidCallback onCancel;
  final String saveLabel;
  final bool saving;
  final String? destructiveLabel;
  final VoidCallback? onDestructive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(children: [
        if (destructiveLabel != null)
          TextButton(onPressed: onDestructive, style: TextButton.styleFrom(foregroundColor: context.colors.danger), child: Text(destructiveLabel!)),
        const Spacer(),
        OutlinedButton(onPressed: onCancel, child: const Text('Cancel')),
        const SizedBox(width: 10),
        FilledButton(
          onPressed: saving ? null : onSave,
          child: saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(saveLabel),
        ),
      ]),
    );
  }
}

class FormSectionTitle extends StatelessWidget {
  const FormSectionTitle(this.title, {super.key, this.hint});
  final String title;
  final String? hint;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title.toUpperCase(), style: context.text.labelSmall?.copyWith(color: context.colors.textMuted, letterSpacing: 1.1, fontWeight: FontWeight.w700)),
          if (hint != null) Padding(padding: const EdgeInsets.only(top: 3), child: Text(hint!, style: context.text.bodySmall?.copyWith(color: context.colors.textMuted))),
        ]),
      );
}

class AppTextField extends StatelessWidget {
  const AppTextField({super.key, required this.controller, required this.label, this.hint, this.maxLines = 1, this.keyboardType, this.obscure = false, this.autofocus = false, this.validator, this.prefixIcon, this.suffix, this.helper, this.onChanged, this.enabled = true});
  final TextEditingController controller;
  final String label;
  final String? hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool obscure;
  final bool autofocus;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final Widget? suffix;
  final String? helper;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: obscure ? 1 : maxLines,
        keyboardType: keyboardType,
        obscureText: obscure,
        autofocus: autofocus,
        validator: validator,
        onChanged: onChanged,
        enabled: enabled,
        decoration: InputDecoration(labelText: label, hintText: hint, helperText: helper, prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, size: 18), suffixIcon: suffix),
      ),
    );
  }
}

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({super.key, required this.label, required this.value, required this.items, required this.onChanged, this.allowNull = false, this.nullLabel = 'None'});
  final String label;
  final T? value;
  final List<(T, String)> items;
  final ValueChanged<T?> onChanged;
  final bool allowNull;
  final String nullLabel;

  @override
  Widget build(BuildContext context) {
    final valid = value == null || items.any((i) => i.$1 == value);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<T?>(
        initialValue: valid ? value : null,
        decoration: InputDecoration(labelText: label),
        isExpanded: true,
        dropdownColor: context.colors.surfaceAlt,
        items: [
          if (allowNull) DropdownMenuItem<T?>(value: null, child: Text(nullLabel, style: TextStyle(color: context.colors.textMuted))),
          for (final (v, l) in items) DropdownMenuItem<T?>(value: v, child: Text(l, overflow: TextOverflow.ellipsis)),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

class ClassificationToggle extends StatelessWidget {
  const ClassificationToggle({super.key, required this.value, required this.onChanged});
  final Classification value;
  final ValueChanged<Classification> onChanged;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: SizedBox(
          width: double.infinity,
          child: SegmentedButton<Classification>(
            segments: const [
              ButtonSegment(value: Classification.personal, label: Text('Personal'), icon: Icon(Icons.person_outline, size: 16)),
              ButtonSegment(value: Classification.business, label: Text('Business'), icon: Icon(Icons.business_center_outlined, size: 16)),
            ],
            selected: {value},
            onSelectionChanged: (s) => onChanged(s.first),
          ),
        ),
      );
}

class DateField extends StatelessWidget {
  const DateField({super.key, required this.label, required this.value, required this.onChanged, this.clearable = true});
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final bool clearable;

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat.yMMMd();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        onTap: () async {
          final picked = await showDatePicker(context: context, initialDate: value ?? DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
          if (picked != null) onChanged(picked);
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: const Icon(Icons.event_outlined, size: 18),
            suffixIcon: clearable && value != null ? IconButton(icon: const Icon(Icons.clear, size: 16), onPressed: () => onChanged(null)) : null,
          ),
          child: Text(value == null ? 'Not set' : fmt.format(value!), style: TextStyle(color: value == null ? context.colors.textMuted : context.colors.text)),
        ),
      ),
    );
  }
}

/// Amount + currency pair.
class MoneyField extends StatelessWidget {
  const MoneyField({super.key, required this.amountController, required this.currency, required this.onCurrencyChanged, this.label = 'Price'});
  final TextEditingController amountController;
  final String currency;
  final ValueChanged<String> onCurrencyChanged;
  final String label;

  static Money? parse(String text, String currency) {
    final v = double.tryParse(text.replaceAll(',', '').trim());
    if (v == null) return null;
    return Money.fromMajor(v, currency);
  }

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        flex: 3,
        child: AppTextField(
          controller: amountController,
          label: label,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (v) => (v == null || v.trim().isEmpty || double.tryParse(v.replaceAll(',', '')) == null) ? 'Enter an amount' : null,
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        flex: 2,
        child: AppDropdown<String>(
          label: 'Currency',
          value: supportedCurrencies.contains(currency) ? currency : supportedCurrencies.first,
          items: [for (final c in supportedCurrencies) (c, '${Money.currencySymbol(c).trim()} $c')],
          onChanged: (v) => onCurrencyChanged(v ?? currency),
        ),
      ),
    ]);
  }
}

/// Comma-separated tags input with suggestions.
class TagsField extends StatelessWidget {
  const TagsField({super.key, required this.controller, this.suggestions = const []});
  final TextEditingController controller;
  final List<String> suggestions;

  static List<String> parse(String text) => text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toSet().toList();

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      AppTextField(controller: controller, label: 'Tags', hint: 'studio, client, 2026', prefixIcon: Icons.tag),
      if (suggestions.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Wrap(spacing: 6, runSpacing: 6, children: [
            for (final s in suggestions.take(12))
              ActionChip(
                label: Text(s),
                onPressed: () {
                  final current = parse(controller.text);
                  if (!current.contains(s)) {
                    controller.text = [...current, s].join(', ');
                  }
                },
              ),
          ]),
        ),
    ]);
  }
}

/// Editable list of label/value pairs (non-secret custom fields).
class CustomFieldsEditor extends StatefulWidget {
  const CustomFieldsEditor({super.key, required this.initial, required this.onChanged});
  final List<(String, String)> initial;
  final ValueChanged<List<(String, String)>> onChanged;

  @override
  State<CustomFieldsEditor> createState() => _CustomFieldsEditorState();
}

class _CustomFieldsEditorState extends State<CustomFieldsEditor> {
  late List<(TextEditingController, TextEditingController)> _rows;

  @override
  void initState() {
    super.initState();
    _rows = [for (final (l, v) in widget.initial) (TextEditingController(text: l), TextEditingController(text: v))];
  }

  @override
  void dispose() {
    for (final (a, b) in _rows) {
      a.dispose();
      b.dispose();
    }
    super.dispose();
  }

  void _emit() => widget.onChanged([for (final (a, b) in _rows) (a.text, b.text)]);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      FormSectionTitle('Custom fields', hint: 'Extra non-secret details (e.g. Member ID). Use the Vault for secrets.'),
      for (var i = 0; i < _rows.length; i++)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(children: [
            Expanded(flex: 2, child: TextField(controller: _rows[i].$1, decoration: const InputDecoration(labelText: 'Label'), onChanged: (_) => _emit())),
            const SizedBox(width: 8),
            Expanded(flex: 3, child: TextField(controller: _rows[i].$2, decoration: const InputDecoration(labelText: 'Value'), onChanged: (_) => _emit())),
            IconButton(tooltip: 'Remove field', icon: const Icon(Icons.remove_circle_outline, size: 18), onPressed: () => setState(() { _rows.removeAt(i); _emit(); })),
          ]),
        ),
      TextButton.icon(onPressed: () => setState(() => _rows.add((TextEditingController(), TextEditingController()))), icon: const Icon(Icons.add, size: 16), label: const Text('Add field')),
    ]);
  }
}

String? requiredValidator(String? v, [String label = 'This field']) => (v == null || v.trim().isEmpty) ? '$label is required' : null;

String? urlValidator(String? v) {
  if (v == null || v.trim().isEmpty) return null;
  final u = Uri.tryParse(v.trim());
  if (u == null || !(u.isScheme('http') || u.isScheme('https'))) return 'Enter a full URL starting with https://';
  return null;
}
