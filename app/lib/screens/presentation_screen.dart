import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../theme/theme_mode_provider.dart';

/// Présentation du Running Club Tunis : historique, valeurs, objectifs, charte
class PresentationScreen extends StatelessWidget {
  final Widget? drawer;
  final List<Widget>? extraActions;

  const PresentationScreen({super.key, this.drawer, this.extraActions});

  static const String _blogUrl = 'https://runningclubtunis.blogspot.com/';
  static const String _instagramUrl = 'https://www.instagram.com/running_club_tunis';
  static const String _facebookUrl = 'https://www.facebook.com/rctunis/';

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final isHighContrast = ThemeModeProvider.of(context) == AppThemeMode.highContrast;

    return Scaffold(
      backgroundColor: scheme.surface,
      drawer: drawer,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          l10n.presentationTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: extraActions ?? [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero — Qui sommes-nous
            _buildHeroSection(context, l10n.presentationWhoWeAre, l10n.presentationWhoWeAreContent),
            const SizedBox(height: 20),

            // Notre devise (citation mise en avant)
            _buildMottoSection(context, l10n.presentationMotto, isHighContrast, scheme),
            const SizedBox(height: 24),

            // Sections classiques
            _buildSection(
              context,
              l10n.presentationHistorySection,
              Icons.history_edu,
              l10n.presentationHistoryContent,
              isHighContrast,
            ),
            _buildSection(
              context,
              l10n.presentationValuesSection,
              Icons.favorite,
              l10n.presentationValuesContent,
              isHighContrast,
            ),
            _buildSection(
              context,
              l10n.presentationObjectivesSection,
              Icons.flag,
              l10n.presentationObjectivesContent,
              isHighContrast,
            ),
            _buildSection(
              context,
              l10n.presentationCharterSection,
              Icons.description,
              l10n.presentationCharterContent,
              isHighContrast,
            ),
            _buildSection(
              context,
              l10n.presentationGroupsSection,
              Icons.groups,
              l10n.presentationGroupsContent,
              isHighContrast,
            ),

            // Rejoignez-nous — liens cliquables
            _buildJoinUsSection(context, l10n, isHighContrast, scheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, String title, String content) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary.withOpacity(0.08),
            scheme.primaryContainer.withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.primary.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.primary,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.65,
                  color: scheme.onSurface,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMottoSection(
    BuildContext context,
    String motto,
    bool isHighContrast,
    ColorScheme scheme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: isHighContrast ? Border.all(color: scheme.outline, width: 2) : null,
        boxShadow: isHighContrast
            ? null
            : [
                BoxShadow(
                  color: scheme.primary.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          Icon(Icons.format_quote, color: scheme.primary, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              motto,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    String content,
    bool isHighContrast,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: isHighContrast ? Border.all(color: scheme.outline, width: 2) : null,
        boxShadow: isHighContrast
            ? null
            : [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 16,
                  offset: const Offset(-4, -4),
                ),
                BoxShadow(
                  color: scheme.outline.withOpacity(0.05),
                  blurRadius: 16,
                  offset: const Offset(4, 4),
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
                child: Icon(icon, color: scheme.primary, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
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

  Widget _buildJoinUsSection(
    BuildContext context,
    AppLocalizations l10n,
    bool isHighContrast,
    ColorScheme scheme,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary.withOpacity(0.06),
            scheme.tertiary.withOpacity(0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: isHighContrast ? Border.all(color: scheme.outline, width: 2) : null,
        boxShadow: isHighContrast
            ? null
            : [
                BoxShadow(
                  color: scheme.primary.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.link, color: scheme.primary, size: 28),
              const SizedBox(width: 12),
              Text(
                l10n.presentationJoinUs,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: scheme.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.presentationLearnMore,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: scheme.onSurface,
                ),
          ),
          const SizedBox(height: 20),
          _buildLinkTile(
            context,
            icon: Icons.article_outlined,
            label: l10n.presentationBlog,
            url: _blogUrl,
            scheme: scheme,
          ),
          const SizedBox(height: 12),
          _buildLinkTile(
            context,
            icon: Icons.camera_alt_outlined,
            label: l10n.presentationInstagram,
            url: _instagramUrl,
            scheme: scheme,
          ),
          const SizedBox(height: 12),
          _buildLinkTile(
            context,
            icon: Icons.facebook,
            label: l10n.presentationFacebook,
            url: _facebookUrl,
            scheme: scheme,
          ),
        ],
      ),
    );
  }

  Widget _buildLinkTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String url,
    required ColorScheme scheme,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _launchUrl(url),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: scheme.outline.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: scheme.outline.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: scheme.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: scheme.primary,
                      ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 14, color: scheme.primary.withOpacity(0.7)),
            ],
          ),
        ),
      ),
    );
  }
}
