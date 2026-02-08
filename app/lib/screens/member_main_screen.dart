import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/login_response.dart';
import '../widgets/app_drawer.dart';
import '../widgets/language_switch_button.dart';
import '../widgets/text_scale_button.dart';
import '../widgets/theme_switch_button.dart';
import '../services/auth_service.dart';
import 'actualites_screen.dart';
import 'administration_screen.dart';
import 'evenements_screen.dart';
import 'groupes_screen.dart';
import 'mon_groupe_screen.dart';
import 'historique_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'presentation_screen.dart';
import 'programmes_screen.dart';
import 'sessions_screen.dart';
import 'welcome_screen.dart';

/// Écran principal : Accueil, Événements, [Groupes], [Administration], [Programmes], Actualités, Historique, Présentation (selon rôle)
class MemberMainScreen extends StatefulWidget {
  final LoginResponse user;

  const MemberMainScreen({super.key, required this.user});

  @override
  State<MemberMainScreen> createState() => _MemberMainScreenState();
}

class _MemberMainScreenState extends State<MemberMainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;
  late final bool _showGroupes;
  late final bool _showAdministration;
  late final bool _showProgrammes;
  late final bool _showMonGroupe;

  @override
  void initState() {
    super.initState();
    _showGroupes = GroupesScreen.canManageGroupes(widget.user);
    _showAdministration = widget.user.role == Role.ADMIN_PRINCIPAL;
    _showProgrammes = widget.user.role == Role.ADMIN_PRINCIPAL ||
        widget.user.role == Role.ADMIN_COACH ||
        widget.user.role == Role.ADHERENT;
    _showMonGroupe = widget.user.role == Role.ADHERENT;
    if (_showGroupes && _showAdministration) {
      _screens = [
        HomeScreen(user: widget.user),
        EvenementsScreen(user: widget.user),
        SessionsScreen(user: widget.user),
        GroupesScreen(user: widget.user),
        AdministrationScreen(user: widget.user),
        ProgrammesScreen(user: widget.user),
        const ActualitesScreen(),
        const HistoriqueScreen(),
        const PresentationScreen(),
      ];
    } else if (_showGroupes) {
      _screens = [
        HomeScreen(user: widget.user),
        EvenementsScreen(user: widget.user),
        SessionsScreen(user: widget.user),
        GroupesScreen(user: widget.user),
        const ActualitesScreen(),
        const HistoriqueScreen(),
        const PresentationScreen(),
      ];
    } else if (_showMonGroupe) {
      _screens = [
        HomeScreen(user: widget.user),
        EvenementsScreen(user: widget.user),
        SessionsScreen(user: widget.user),
        ProgrammesScreen(user: widget.user),
        MonGroupeScreen(user: widget.user),
        const ActualitesScreen(),
        const HistoriqueScreen(),
        const PresentationScreen(),
      ];
    } else if (_showProgrammes) {
      _screens = [
        HomeScreen(user: widget.user),
        EvenementsScreen(user: widget.user),
        SessionsScreen(user: widget.user),
        ProgrammesScreen(user: widget.user),
        const ActualitesScreen(),
        const HistoriqueScreen(),
        const PresentationScreen(),
      ];
    } else {
      _screens = [
        HomeScreen(user: widget.user),
        EvenementsScreen(user: widget.user),
        SessionsScreen(user: widget.user),
        const ActualitesScreen(),
        const HistoriqueScreen(),
        const PresentationScreen(),
      ];
    }
  }

  List<({IconData icon, IconData selectedIcon, String label})> _buildDrawerItems(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_showGroupes && _showAdministration) {
      return [
        (icon: Icons.home_outlined, selectedIcon: Icons.home, label: l10n.home),
        (icon: Icons.event_outlined, selectedIcon: Icons.event, label: l10n.events),
        (icon: Icons.directions_run_outlined, selectedIcon: Icons.directions_run, label: l10n.trainingProgrammes),
        (icon: Icons.groups_outlined, selectedIcon: Icons.groups, label: l10n.groups),
        (icon: Icons.admin_panel_settings_outlined, selectedIcon: Icons.admin_panel_settings, label: l10n.administration),
        (icon: Icons.fitness_center_outlined, selectedIcon: Icons.fitness_center, label: l10n.programmes),
        (icon: Icons.article_outlined, selectedIcon: Icons.article, label: l10n.news),
        (icon: Icons.history, selectedIcon: Icons.history, label: l10n.history),
        (icon: Icons.info_outline, selectedIcon: Icons.info, label: l10n.presentation),
      ];
    } else if (_showGroupes) {
      return [
        (icon: Icons.home_outlined, selectedIcon: Icons.home, label: l10n.home),
        (icon: Icons.event_outlined, selectedIcon: Icons.event, label: l10n.events),
        (icon: Icons.directions_run_outlined, selectedIcon: Icons.directions_run, label: l10n.trainingProgrammes),
        (icon: Icons.groups_outlined, selectedIcon: Icons.groups, label: l10n.groups),
        (icon: Icons.article_outlined, selectedIcon: Icons.article, label: l10n.news),
        (icon: Icons.history, selectedIcon: Icons.history, label: l10n.history),
        (icon: Icons.info_outline, selectedIcon: Icons.info, label: l10n.presentation),
      ];
    } else if (_showMonGroupe) {
      return [
        (icon: Icons.home_outlined, selectedIcon: Icons.home, label: l10n.home),
        (icon: Icons.event_outlined, selectedIcon: Icons.event, label: l10n.events),
        (icon: Icons.directions_run_outlined, selectedIcon: Icons.directions_run, label: l10n.trainingProgrammes),
        (icon: Icons.fitness_center_outlined, selectedIcon: Icons.fitness_center, label: l10n.programmes),
        (icon: Icons.groups_outlined, selectedIcon: Icons.groups, label: l10n.monGroupe),
        (icon: Icons.article_outlined, selectedIcon: Icons.article, label: l10n.news),
        (icon: Icons.history, selectedIcon: Icons.history, label: l10n.history),
        (icon: Icons.info_outline, selectedIcon: Icons.info, label: l10n.presentation),
      ];
    } else if (_showProgrammes) {
      return [
        (icon: Icons.home_outlined, selectedIcon: Icons.home, label: l10n.home),
        (icon: Icons.event_outlined, selectedIcon: Icons.event, label: l10n.events),
        (icon: Icons.directions_run_outlined, selectedIcon: Icons.directions_run, label: l10n.trainingProgrammes),
        (icon: Icons.fitness_center_outlined, selectedIcon: Icons.fitness_center, label: l10n.programmes),
        (icon: Icons.article_outlined, selectedIcon: Icons.article, label: l10n.news),
        (icon: Icons.history, selectedIcon: Icons.history, label: l10n.history),
        (icon: Icons.info_outline, selectedIcon: Icons.info, label: l10n.presentation),
      ];
    } else {
      return [
        (icon: Icons.home_outlined, selectedIcon: Icons.home, label: l10n.home),
        (icon: Icons.event_outlined, selectedIcon: Icons.event, label: l10n.events),
        (icon: Icons.directions_run_outlined, selectedIcon: Icons.directions_run, label: l10n.trainingProgrammes),
        (icon: Icons.article_outlined, selectedIcon: Icons.article, label: l10n.news),
        (icon: Icons.history, selectedIcon: Icons.history, label: l10n.history),
        (icon: Icons.info_outline, selectedIcon: Icons.info, label: l10n.presentation),
      ];
    }
  }

  Future<void> _logout() async {
    await AuthService().logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      label: l10n.mainScreenLabel,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.appName),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          const LanguageSwitchButton(),
          const TextScaleButton(),
          const ThemeSwitchButton(),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: l10n.logoutTooltip,
          ),
        ],
      ),
      drawer: AppDrawer(
        currentIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        items: _buildDrawerItems(context),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
    ),
    );
  }
}
