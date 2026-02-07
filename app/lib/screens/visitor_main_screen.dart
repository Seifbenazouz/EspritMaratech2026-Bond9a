import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../widgets/app_drawer.dart';
import '../widgets/language_switch_button.dart';
import '../widgets/text_scale_button.dart';
import '../widgets/theme_switch_button.dart';
import 'actualites_screen.dart';
import 'historique_screen.dart';
import 'login_screen.dart';
import 'presentation_screen.dart';

/// Écran principal pour les visiteurs (sans login) : onglets Actualités, Historique, Présentation
class VisitorMainScreen extends StatefulWidget {
  const VisitorMainScreen({super.key});

  @override
  State<VisitorMainScreen> createState() => _VisitorMainScreenState();
}

class _VisitorMainScreenState extends State<VisitorMainScreen> {
  int _currentIndex = 0;

  List<Widget> _appBarActions(BuildContext context) {
    return [
      const LanguageSwitchButton(),
      const TextScaleButton(),
      const ThemeSwitchButton(),
      IconButton(
        icon: const Icon(Icons.login),
        tooltip: AppLocalizations.of(context).connectTooltip,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final drawer = AppDrawer(
      currentIndex: _currentIndex,
      onDestinationSelected: (i) => setState(() => _currentIndex = i),
      items: [
        (icon: Icons.article_outlined, selectedIcon: Icons.article, label: AppLocalizations.of(context).news),
        (icon: Icons.history, selectedIcon: Icons.history, label: AppLocalizations.of(context).history),
        (icon: Icons.info_outline, selectedIcon: Icons.info, label: AppLocalizations.of(context).presentation),
      ],
    );
    return Semantics(
      label: 'Mode visiteur - Actualités, Historique, Présentation',
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: IndexedStack(
        index: _currentIndex,
        children: [
          ActualitesScreen(drawer: drawer, extraActions: _appBarActions(context)),
          HistoriqueScreen(drawer: drawer, extraActions: _appBarActions(context)),
          PresentationScreen(drawer: drawer, extraActions: _appBarActions(context)),
        ],
      ),
    ),
    );
  }
}
