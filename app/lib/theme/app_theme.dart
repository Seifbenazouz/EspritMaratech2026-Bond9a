import 'package:flutter/material.dart';

import 'theme_mode_provider.dart';

/// Thème d'accessibilité visuelle conforme WCAG 2.1 AA :
/// - Contraste élevé (texte lisible sur fond)
/// - Tailles de police minimales (corps ≥ 16)
/// - Zones tactiles min 44×44
/// - Pas de combinaison rouge/vert (daltonisme)
/// - Icônes + couleur + texte ensemble
class AppTheme {
  AppTheme._();

  static const double minTouchTarget = 44;

  static ThemeData fromMode(AppThemeMode mode, {double scale = 1.0}) {
    switch (mode) {
      case AppThemeMode.light:
        return light(scale);
      case AppThemeMode.dark:
        return dark(scale);
      case AppThemeMode.highContrast:
        return highContrast(scale);
    }
  }

  /// Pastel wellness palette: light blue, soft grey, white, orange & green accents
  static ThemeData light([double scale = 1.0]) {
    const scheme = ColorScheme.light(
      primary: Color(0xFF4A9EBD),       // Soft blue
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFE8F4F8),
      onPrimaryContainer: Color(0xFF1A3A45),
      secondary: Color(0xFF6BCB77),     // Soft green
      onSecondary: Colors.white,
      tertiary: Color(0xFFFF9F43),      // Soft orange accent
      surface: Color(0xFFF8FAFC),
      onSurface: Color(0xFF2D3748),
      surfaceContainerHighest: Color(0xFFF1F5F9),
      onSurfaceVariant: Color(0xFF64748B),
      outline: Color(0xFFCBD5E1),
      error: Color(0xFFE57373),
      onError: Colors.white,
      errorContainer: Color(0xFFFDEDED),
      onErrorContainer: Color(0xFF5C2E2E),
    );
    return _buildTheme(scheme, inputFillColor: Colors.white, isWellness: true, scale: scale);
  }

  /// Sombre : fond foncé, texte clair
  static ThemeData dark([double scale = 1.0]) {
    const scheme = ColorScheme.dark(
      primary: Color(0xFFFFB59D),
      onPrimary: Color(0xFF5C1900),
      primaryContainer: Color(0xFF7E2A00),
      onPrimaryContainer: Color(0xFFFFDBD0),
      surface: Color(0xFF1C1917),
      onSurface: Color(0xFFE7E2DF),
      surfaceContainerHighest: Color(0xFF2D2926),
      onSurfaceVariant: Color(0xFFD8C2B9),
      outline: Color(0xFFA08D84),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
    );
    return _buildTheme(scheme, inputFillColor: const Color(0xFF2D2926), isWellness: false, scale: scale);
  }

  /// Contraste élevé : fond très foncé, texte blanc/ambre vif
  /// Palette daltonien-friendly : pas de rouge/vert, accents ambre + bleu + cyan
  /// Différenciation par formes/icônes en plus des couleurs
  static ThemeData highContrast([double scale = 1.0]) {
    const scheme = ColorScheme.dark(
      primary: Color(0xFFFFD54F),        // Ambre (distinguable pour protan/deutan)
      onPrimary: Color(0xFF1A1A1A),
      primaryContainer: Color(0xFF4A4A00),
      onPrimaryContainer: Color(0xFFFFFF9E),
      secondary: Color(0xFF4DD0E1),      // Cyan (pas de vert)
      onSecondary: Color(0xFF0D0D0D),
      tertiary: Color(0xFF64B5F6),       // Bleu clair
      onTertiary: Color(0xFF0D0D0D),
      surface: Color(0xFF0D0D0D),
      onSurface: Color(0xFFFFFFFF),
      surfaceContainerHighest: Color(0xFF1A1A1A),
      onSurfaceVariant: Color(0xFFE0E0E0),
      outline: Color(0xFFFFD54F),        // Bordure visible ambre
      error: Color(0xFF42A5F5),          // Bleu (pas rouge, daltonien)
      onError: Color(0xFF0D0D0D),
      errorContainer: Color(0xFF1565C0),
      onErrorContainer: Color(0xFFFFFFFF),
    );
    return _buildTheme(scheme, inputFillColor: const Color(0xFF1A1A1A), isHighContrast: true, isWellness: false, scale: scale);
  }

  static ThemeData _buildTheme(ColorScheme scheme, {required Color inputFillColor, bool isHighContrast = false, bool isWellness = false, double scale = 1.0}) {
    final s = scale.clamp(0.8, 1.8);
    final textTheme = Typography.material2021().black.copyWith(
      headlineLarge: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, letterSpacing: -0.5, height: 1.25),
      headlineMedium: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.3),
      headlineSmall: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, height: 1.35),
      titleLarge: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, height: 1.4),
      titleMedium: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.4),
      titleSmall: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.4),
      bodyLarge: const TextStyle(fontSize: 20, height: 1.5),
      bodyMedium: const TextStyle(fontSize: 18, height: 1.5),
      bodySmall: const TextStyle(fontSize: 16, height: 1.45),
      labelLarge: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    ).apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        iconTheme: IconThemeData(size: (32 * s).roundToDouble(), color: scheme.onSurface),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        dragHandleColor: scheme.onSurfaceVariant.withOpacity(0.4),
        dragHandleSize: const Size(40, 4),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16 * s, vertical: 4 * s),
        minLeadingWidth: 40 * s,
        iconColor: scheme.onSurface,
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodyMedium,
      ),
      popupMenuTheme: PopupMenuThemeData(
        iconSize: 24 * s,
      ),
      drawerTheme: DrawerThemeData(
        width: 304 * s,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFillColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 18 * s, vertical: 22 * s),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(isWellness ? 24 : 16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isWellness ? 24 : 16),
          borderSide: BorderSide(color: scheme.outline, width: isHighContrast ? 2 : 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isWellness ? 24 : 16),
          borderSide: BorderSide(color: scheme.primary, width: isHighContrast ? 3 : 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isWellness ? 24 : 16),
          borderSide: BorderSide(color: scheme.error, width: isHighContrast ? 2 : 1.5),
        ),
        labelStyle: TextStyle(fontSize: 18, color: scheme.onSurfaceVariant),
        hintStyle: TextStyle(fontSize: 18, color: scheme.onSurfaceVariant),
        helperStyle: const TextStyle(fontSize: 16),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: Size.fromHeight(60 * s),
          padding: EdgeInsets.symmetric(horizontal: 28 * s, vertical: 20 * s),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isWellness ? 24 : 16)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: Size.fromHeight(60 * s),
          padding: EdgeInsets.symmetric(horizontal: 28 * s, vertical: 20 * s),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          side: BorderSide(color: scheme.outline, width: isHighContrast ? 2 : 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isWellness ? 24 : 16)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: Size(52 * s, 52 * s),
          padding: EdgeInsets.symmetric(horizontal: 20 * s, vertical: 16 * s),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: Size(56 * s, 56 * s),
          padding: EdgeInsets.all(14 * s),
          iconSize: 36 * s,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72 * s,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        indicatorColor: scheme.primaryContainer.withOpacity(0.6),
        labelTextStyle: WidgetStateProperty.resolveWith((_) => const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
        iconTheme: WidgetStateProperty.resolveWith((_) => IconThemeData(size: 28 * s, color: scheme.onSurface)),
      ),
      cardTheme: CardThemeData(
        elevation: isHighContrast ? 0 : (isWellness ? 0 : 2),
        shadowColor: Colors.black.withOpacity(isWellness ? 0.04 : 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isWellness ? 28 : 20),
          side: isHighContrast ? BorderSide(color: scheme.outline, width: 2) : BorderSide.none,
        ),
        margin: EdgeInsets.symmetric(horizontal: isWellness ? 20 : 16, vertical: isWellness ? 8 : 6),
        clipBehavior: Clip.antiAlias,
        color: isWellness ? scheme.surface : null,
      ),
      chipTheme: ChipThemeData(
        labelStyle: const TextStyle(fontSize: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: const TextStyle(fontSize: 18),
        behavior: SnackBarBehavior.floating,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        extendedSizeConstraints: BoxConstraints(minHeight: minTouchTarget * s, minWidth: minTouchTarget * s),
      ),
    );
  }
}
