import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/theme_mode_provider.dart';
import '../widgets/language_switch_button.dart';
import '../widgets/text_scale_button.dart';
import '../widgets/theme_switch_button.dart';
import 'login_screen.dart';
import 'visitor_main_screen.dart';

/// Écran d'accueil : choix entre visiteur (sans login) ou connexion
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const radius = 28.0;
    return Semantics(
      label: AppLocalizations.of(context).welcomeLabel,
      child: Scaffold(
        backgroundColor: scheme.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              scheme.primaryContainer.withOpacity(0.5),
              scheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: const [
                  LanguageSwitchButton(),
                  TextScaleButton(),
                  ThemeSwitchButton(),
                ],
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Builder(
                        builder: (context) {
                          final isHighContrast = ThemeModeProvider.of(context) == AppThemeMode.highContrast;
                          return Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: scheme.surface,
                              shape: BoxShape.circle,
                              border: isHighContrast ? Border.all(color: scheme.outline, width: 2) : null,
                              boxShadow: isHighContrast
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: Colors.white,
                                        blurRadius: 24,
                                        offset: const Offset(-6, -6),
                                      ),
                                      BoxShadow(
                                        color: scheme.outline.withOpacity(0.08),
                                        blurRadius: 24,
                                        offset: const Offset(6, 6),
                                      ),
                                    ],
                            ),
                            child: Icon(
                              Icons.directions_run,
                              size: 72,
                              color: scheme.primary,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 28),
                      Text(
                        AppLocalizations.of(context).appName,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: scheme.primary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${AppLocalizations.of(context).news} • ${AppLocalizations.of(context).presentation}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 48),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const VisitorMainScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.visibility, size: 28),
                          label: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Text(AppLocalizations.of(context).continueVisitor),
                          ),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(56),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.login, size: 28),
                          label: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Text(AppLocalizations.of(context).connect),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(56),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
