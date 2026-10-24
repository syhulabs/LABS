import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme/app_theme.dart';
import '../../data/db/app_database.dart';
import '../brand/brand_icons.g.dart';

/// Logo tile for a platform. Resolution order:
///  1. an original logo file in `assets/logos/<id>.(png|svg)` (SYHU logo library),
///  2. the Simple Icons brand glyph tinted with the official brand color,
///  3. a monogram on a deterministic color: never an invented "look-alike".
class PlatformLogo extends StatelessWidget {
  const PlatformLogo({super.key, required this.platform, this.size = 44, this.radius});
  final Platform platform;
  final double size;
  final double? radius;

  static Set<String>? _availableLogos;
  static Map<String, String> _tones = const {};

  /// Called once at startup with the asset manifest so missing files never
  /// trigger image errors.
  static void setAvailableLogos(Iterable<String> assetKeys) {
    _availableLogos = assetKeys.where((k) => k.startsWith('assets/logos/') && !k.endsWith('.json') && !k.endsWith('.md')).toSet();
  }

  /// Loads assets/logos/manifest.json (written by tool/fetch_logos.py): the
  /// tone of each mark decides the tile behind it so dark marks stay visible
  /// in dark mode and white marks stay visible in light mode.
  static void setToneManifest(Map<String, dynamic> manifest) {
    _tones = {
      for (final e in manifest.entries)
        if (e.value is Map && (e.value as Map)['tone'] is String) e.key: (e.value as Map)['tone'] as String,
    };
  }

  String? get _logoPath {
    final explicit = platform.logoAsset;
    final candidates = [
      ?explicit,
      'assets/logos/${platform.id}.svg',
      'assets/logos/${platform.id}.png',
    ];
    final available = _availableLogos;
    for (final c in candidates) {
      if (available == null ? c == explicit : available.contains(c)) return c;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(radius ?? size * 0.28);
    final logo = _logoPath;
    final glyph = platform.iconSlug == null ? null : brandGlyphs[platform.iconSlug!];
    final colors = context.colors;

    Widget child;
    Color bg;
    if (logo != null) {
      final tone = _tones[platform.id];
      final isDark = Theme.of(context).brightness == Brightness.dark;
      // Dark monochrome marks sit on a light tile in dark mode; white marks on a dark tile in light mode.
      bg = tone == 'dark' && isDark
          ? const Color(0xFFF3F4F8)
          : tone == 'light' && !isDark
              ? const Color(0xFF1F2430)
              : colors.surfaceAlt;
      final inner = logo.endsWith('.svg')
          ? SvgPicture.asset(logo, width: size * 0.62, height: size * 0.62)
          : Image.asset(logo, width: size * 0.62, height: size * 0.62, fit: BoxFit.contain, errorBuilder: (_, _, _) => _monogram(size));
      child = Center(child: inner);
    } else if (glyph != null) {
      final brand = glyph.color;
      final tooDark = brand.computeLuminance() < 0.08;
      final tooLight = brand.computeLuminance() > 0.85;
      final isDark = Theme.of(context).brightness == Brightness.dark;
      bg = isDark ? Color.alphaBlend(brand.withValues(alpha: 0.18), colors.surfaceAlt) : Color.alphaBlend(brand.withValues(alpha: 0.12), colors.surfaceAlt);
      final fg = isDark ? (tooDark ? Colors.white : brand) : (tooLight ? colors.text : brand);
      child = Center(child: Icon(glyph.icon, size: size * 0.52, color: fg));
    } else {
      bg = colors.surfaceAlt;
      child = _monogram(size);
    }
    return Semantics(
      label: '${platform.name} logo',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: bg, borderRadius: r, border: Border.all(color: colors.border.withValues(alpha: 0.6))),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }

  Widget _monogram(double size) {
    final c = colorForKey(platform.id);
    final letters = platform.name.trim().split(RegExp(r'\s+')).take(2).map((w) => w.isEmpty ? '' : w[0].toUpperCase()).join();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [c.withValues(alpha: 0.95), c.withValues(alpha: 0.55)]),
      ),
      alignment: Alignment.center,
      child: Text(letters, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: size * 0.38, letterSpacing: -0.5)),
    );
  }
}

/// Small avatar for a generic entity (email, project, artist...).
class MonogramAvatar extends StatelessWidget {
  const MonogramAvatar({super.key, required this.text, required this.seed, this.size = 40, this.icon});
  final String text;
  final String seed;
  final double size;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = colorForKey(seed);
    final letters = text.trim().split(RegExp(r'[\s@._-]+')).where((w) => w.isNotEmpty).take(2).map((w) => w[0].toUpperCase()).join();
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [c.withValues(alpha: 0.9), c.withValues(alpha: 0.5)]),
      ),
      child: icon != null
          ? Icon(icon, color: Colors.white, size: size * 0.5)
          : Text(letters.isEmpty ? '?' : letters, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: size * 0.36)),
    );
  }
}
