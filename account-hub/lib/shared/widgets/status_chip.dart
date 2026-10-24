import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';
import '../../domain/enums.dart';

class StatusChip extends StatelessWidget {
  const StatusChip(this.label, {super.key, this.color, this.icon, this.dense = true});
  final String label;
  final Color? color;
  final IconData? icon;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.colors.textMuted;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: dense ? 8 : 10, vertical: dense ? 3 : 5),
      decoration: BoxDecoration(color: c.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(999), border: Border.all(color: c.withValues(alpha: 0.35))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[Icon(icon, size: 12, color: c), const SizedBox(width: 4)],
        Text(label, style: TextStyle(color: c, fontSize: dense ? 11 : 12, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

Color statusColor(BuildContext context, String status) {
  final c = context.colors;
  switch (status) {
    case 'active':
    case 'lifetime':
    case 'released':
      return c.success;
    case 'trial':
    case 'inProgress':
    case 'idea':
    case 'pendingVerification':
      return c.accentBlue;
    case 'paused':
    case 'inactive':
      return c.warning;
    case 'cancelled':
    case 'expired':
    case 'closed':
    case 'suspended':
    case 'archived':
      return c.danger;
    default:
      return c.textMuted;
  }
}

String statusLabel(String status) {
  for (final v in SubscriptionStatus.values) {
    if (v.name == status) return v.label;
  }
  for (final v in AccountStatus.values) {
    if (v.name == status) return v.label;
  }
  for (final v in ProjectStatus.values) {
    if (v.name == status) return v.label;
  }
  return status;
}

class ClassificationChip extends StatelessWidget {
  const ClassificationChip(this.classification, {super.key});
  final String classification;
  @override
  Widget build(BuildContext context) {
    final business = classification == Classification.business.name;
    return StatusChip(business ? 'Business' : 'Personal', color: business ? context.colors.accentPink : context.colors.accentBlue, icon: business ? Icons.business_center_outlined : Icons.person_outline);
  }
}
