import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/text_scale_provider.dart';

/// Drawer style Noom/Lyft/Messenger : icône + label, en-tête avec fermeture
class AppDrawer extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<({IconData icon, IconData selectedIcon, String label})> items;
  final Widget? headerChild;
  final VoidCallback? onClose;

  const AppDrawer({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.items,
    this.headerChild,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final scale = TextScaleProvider.of(context);
    final iconSize = 36.0 * scale;

    return Drawer(
      backgroundColor: scheme.surface,
      width: MediaQuery.of(context).size.width * 0.85 * scale,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // En-tête avec bouton fermer (X) en haut à gauche
            Padding(
              padding: EdgeInsets.fromLTRB(12 * scale, 12 * scale, 16 * scale, 16 * scale),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close, size: 28 * scale, color: scheme.onSurface),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onClose?.call();
                    },
                    tooltip: AppLocalizations.of(context).close,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: headerChild ??
                        Text(
                          AppLocalizations.of(context).appName,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: scheme.onSurface,
                                fontSize: 20,
                              ),
                        ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Liste des éléments de navigation
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 12 * scale, horizontal: 8 * scale),
                children: [
                  for (int i = 0; i < items.length; i++)
                    Semantics(
                      label: '${items[i].label}${currentIndex == i ? ', sélectionné' : ''}',
                      child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 4 * scale),
                      leading: Icon(
                        currentIndex == i ? items[i].selectedIcon : items[i].icon,
                        size: iconSize,
                        color: currentIndex == i ? scheme.primary : scheme.onSurface.withOpacity(0.9),
                      ),
                      title: Text(
                        items[i].label,
                        style: TextStyle(
                          fontWeight: currentIndex == i ? FontWeight.w600 : FontWeight.w500,
                          color: currentIndex == i ? scheme.primary : scheme.onSurface,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                        onDestinationSelected(i);
                        Navigator.of(context).pop();
                      },
                    ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
