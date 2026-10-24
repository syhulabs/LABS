import 'package:flutter/material.dart';

/// Design tokens for the SYHU Account Hub look: deep navy/charcoal surfaces,
/// purple-blue-pink accents, rounded cards. Exposed as a [ThemeExtension] so
/// widgets read semantic tokens instead of hard-coded colors.
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.surfaceHover,
    required this.border,
    required this.text,
    required this.textMuted,
    required this.accent,
    required this.accentBlue,
    required this.accentPink,
    required this.success,
    required this.warning,
    required this.danger,
    required this.sidebar,
    required this.heroGradient,
  });

  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color surfaceHover;
  final Color border;
  final Color text;
  final Color textMuted;
  final Color accent;
  final Color accentBlue;
  final Color accentPink;
  final Color success;
  final Color warning;
  final Color danger;
  final Color sidebar;
  final Gradient heroGradient;

  static const dark = AppColors(
    background: Color(0xFF0A0E1A),
    surface: Color(0xFF121829),
    surfaceAlt: Color(0xFF1A2138),
    surfaceHover: Color(0xFF212A45),
    border: Color(0xFF26304D),
    text: Color(0xFFE8EBF5),
    textMuted: Color(0xFF8B94B0),
    accent: Color(0xFF8B5CF6),
    accentBlue: Color(0xFF3B82F6),
    accentPink: Color(0xFFEC4899),
    success: Color(0xFF22C55E),
    warning: Color(0xFFF59E0B),
    danger: Color(0xFFEF4444),
    sidebar: Color(0xFF0D1222),
    heroGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF4C1D95), Color(0xFF831843)],
    ),
  );

  static const light = AppColors(
    background: Color(0xFFF4F5FA),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFF0F2F8),
    surfaceHover: Color(0xFFE8EBF4),
    border: Color(0xFFDDE1EC),
    text: Color(0xFF14192B),
    textMuted: Color(0xFF626B85),
    accent: Color(0xFF7C3AED),
    accentBlue: Color(0xFF2563EB),
    accentPink: Color(0xFFDB2777),
    success: Color(0xFF16A34A),
    warning: Color(0xFFD97706),
    danger: Color(0xFFDC2626),
    sidebar: Color(0xFFEDEFF6),
    heroGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFFDB2777)],
    ),
  );

  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      surfaceHover: Color.lerp(surfaceHover, other.surfaceHover, t)!,
      border: Color.lerp(border, other.border, t)!,
      text: Color.lerp(text, other.text, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentBlue: Color.lerp(accentBlue, other.accentBlue, t)!,
      accentPink: Color.lerp(accentPink, other.accentPink, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      sidebar: Color.lerp(sidebar, other.sidebar, t)!,
      heroGradient: t < 0.5 ? heroGradient : other.heroGradient,
    );
  }
}

extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
  TextTheme get text => Theme.of(this).textTheme;
  bool get isCompact => MediaQuery.sizeOf(this).width < 760;
  bool get isWide => MediaQuery.sizeOf(this).width >= 1180;
}

class AppTheme {
  static const radius = 16.0;
  static const radiusSmall = 10.0;

  static ThemeData dark() => _build(AppColors.dark, Brightness.dark);
  static ThemeData light() => _build(AppColors.light, Brightness.light);

  static ThemeData _build(AppColors c, Brightness b) {
    final scheme = ColorScheme.fromSeed(
      seedColor: c.accent,
      brightness: b,
      primary: c.accent,
      secondary: c.accentBlue,
      tertiary: c.accentPink,
      surface: c.surface,
      error: c.danger,
    );
    final base = ThemeData(brightness: b, colorScheme: scheme, useMaterial3: true);
    final textTheme = base.textTheme.apply(bodyColor: c.text, displayColor: c.text);
    return base.copyWith(
      scaffoldBackgroundColor: c.background,
      canvasColor: c.background,
      textTheme: textTheme.copyWith(
        headlineMedium: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.5),
        headlineSmall: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.3),
        titleLarge: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        titleMedium: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        bodyMedium: textTheme.bodyMedium?.copyWith(height: 1.4),
        labelLarge: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      extensions: [c],
      dividerColor: c.border,
      splashFactory: InkSparkle.splashFactory,
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius), side: BorderSide(color: c.border)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius + 4)),
      ),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: c.surface, surfaceTintColor: Colors.transparent, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20)))),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surfaceAlt,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        hintStyle: TextStyle(color: c.textMuted),
        labelStyle: TextStyle(color: c.textMuted),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(radiusSmall), borderSide: BorderSide(color: c.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radiusSmall), borderSide: BorderSide(color: c.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radiusSmall), borderSide: BorderSide(color: c.accent, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radiusSmall), borderSide: BorderSide(color: c.danger)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.accent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSmall)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.text,
          side: BorderSide(color: c.border),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSmall)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: c.accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSmall))),
      ),
      iconButtonTheme: IconButtonThemeData(style: IconButton.styleFrom(foregroundColor: c.textMuted)),
      chipTheme: ChipThemeData(
        backgroundColor: c.surfaceAlt,
        selectedColor: c.accent.withValues(alpha: 0.25),
        side: BorderSide(color: c.border),
        labelStyle: TextStyle(color: c.text, fontSize: 12.5, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        showCheckmark: false,
      ),
      listTileTheme: ListTileThemeData(iconColor: c.textMuted, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSmall))),
      popupMenuTheme: PopupMenuThemeData(color: c.surfaceAlt, surfaceTintColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: c.border))),
      snackBarTheme: SnackBarThemeData(backgroundColor: c.surfaceAlt, contentTextStyle: TextStyle(color: c.text), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: c.border))),
      dividerTheme: DividerThemeData(color: c.border, thickness: 1, space: 1),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: c.accent.withValues(alpha: 0.25),
          selectedForegroundColor: c.text,
          foregroundColor: c.textMuted,
          side: BorderSide(color: c.border),
          visualDensity: VisualDensity.compact,
        ),
      ),
      tooltipTheme: TooltipThemeData(decoration: BoxDecoration(color: c.surfaceHover, borderRadius: BorderRadius.circular(8)), textStyle: TextStyle(color: c.text, fontSize: 12)),
      navigationBarTheme: NavigationBarThemeData(backgroundColor: c.sidebar, indicatorColor: c.accent.withValues(alpha: 0.25), labelTextStyle: WidgetStatePropertyAll(TextStyle(color: c.text, fontSize: 11))),
      switchTheme: SwitchThemeData(thumbColor: WidgetStatePropertyAll(Colors.white), trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.accent : c.surfaceHover)),
    );
  }
}

/// Deterministic accent for an id (monogram tiles, project colors).
Color colorForKey(String key, {Brightness brightness = Brightness.dark}) {
  const palette = [
    Color(0xFF8B5CF6), Color(0xFF3B82F6), Color(0xFFEC4899), Color(0xFF06B6D4), Color(0xFF10B981),
    Color(0xFFF59E0B), Color(0xFFEF4444), Color(0xFF6366F1), Color(0xFF14B8A6), Color(0xFFF97316),
  ];
  var h = 0;
  for (final c in key.codeUnits) {
    h = (h * 31 + c) & 0x7fffffff;
  }
  return palette[h % palette.length];
}
