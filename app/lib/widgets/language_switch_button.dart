import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/locale_provider.dart';

/// Bouton pour changer la langue (FR / EN / AR / IT / DE) - affiché dans l'AppBar
class LanguageSwitchButton extends StatelessWidget {
  const LanguageSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      tooltip: AppLocalizations.of(context).language,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.language, size: 24, color: Theme.of(context).colorScheme.onSurface),
      ),
      offset: const Offset(0, -120),
      onSelected: (locale) => LocaleProvider.setLocale(context, locale),
      itemBuilder: (context) {
        final current = LocaleProvider.of(context);
        return AppLocale.values
            .map(
              (al) => PopupMenuItem<Locale>(
                value: al.locale,
                child: Row(
                  children: [
                    Icon(
                      Icons.check,
                      size: 20,
                      color: current.languageCode == al.locale.languageCode
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                    ),
                    const SizedBox(width: 12),
                    Text(al.label),
                  ],
                ),
              ),
            )
            .toList();
      },
    );
  }
}
