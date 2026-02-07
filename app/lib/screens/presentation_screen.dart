import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/theme_mode_provider.dart';

/// Présentation du Running Club Tunis : historique, valeurs, objectifs, charte
class PresentationScreen extends StatelessWidget {
  final Widget? drawer;
  final List<Widget>? extraActions;

  const PresentationScreen({super.key, this.drawer, this.extraActions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: drawer,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(AppLocalizations.of(context).presentationTitle),
        actions: extraActions ?? [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection(
              context,
              AppLocalizations.of(context).presentationHistorySection,
              Icons.history,
              AppLocalizations.of(context).presentationHistoryContent,
            ),
            _buildSection(
              context,
              AppLocalizations.of(context).presentationValuesSection,
              Icons.favorite,
              AppLocalizations.of(context).presentationValuesContent,
            ),
            _buildSection(
              context,
              AppLocalizations.of(context).presentationObjectivesSection,
              Icons.flag,
              AppLocalizations.of(context).presentationObjectivesContent,
            ),
            _buildSection(
              context,
              AppLocalizations.of(context).presentationCharterSection,
              Icons.description,
              AppLocalizations.of(context).presentationCharterContent,
            ),
            _buildSection(
              context,
              AppLocalizations.of(context).presentationGroupsSection,
              Icons.groups,
              AppLocalizations.of(context).presentationGroupsContent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    String content,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final isHighContrast = ThemeModeProvider.of(context) == AppThemeMode.highContrast;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: isHighContrast ? Border.all(color: scheme.outline, width: 2) : null,
        boxShadow: isHighContrast
            ? null
            : [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 20,
                  offset: const Offset(-6, -6),
                ),
                BoxShadow(
                  color: scheme.outline.withOpacity(0.06),
                  blurRadius: 24,
                  offset: const Offset(6, 6),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: scheme.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  color: scheme.onSurface,
                ),
          ),
        ],
      ),
    );
  }
}
