import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/theme_mode_provider.dart';

/// Bouton de bascule thème : icône + couleur + texte (accessibilité)
class ThemeSwitchButton extends StatelessWidget {
  const ThemeSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = ThemeModeProvider.of(context);
    final l10n = AppLocalizations.of(context);
    return PopupMenuButton<AppThemeMode>(
      tooltip: l10n.themeTooltip,
      icon: _modeIcon(mode),
      offset: const Offset(0, 48),
      onSelected: (m) => ThemeModeProvider.setThemeMode(context, m),
      itemBuilder: (context) {
        final scheme = Theme.of(context).colorScheme;
        return [
          PopupMenuItem<AppThemeMode>(
            value: AppThemeMode.light,
            child: Row(
              children: [
                Icon(Icons.light_mode, color: scheme.primary, size: 24),
                const SizedBox(width: 12),
                Text(l10n.themeLight),
              ],
            ),
          ),
          PopupMenuItem<AppThemeMode>(
            value: AppThemeMode.dark,
            child: Row(
              children: [
                Icon(Icons.dark_mode, color: scheme.primary, size: 24),
                const SizedBox(width: 12),
                Text(l10n.themeDark),
              ],
            ),
          ),
          PopupMenuItem<AppThemeMode>(
            value: AppThemeMode.highContrast,
            child: Row(
              children: [
                Icon(Icons.contrast, color: scheme.primary, size: 24),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(l10n.themeHighContrast),
                ),
              ],
            ),
          ),
        ];
      },
    );
  }

  Icon _modeIcon(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return const Icon(Icons.light_mode);
      case AppThemeMode.dark:
        return const Icon(Icons.dark_mode);
      case AppThemeMode.highContrast:
        return const Icon(Icons.contrast);
    }
  }
}
