import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/login_response.dart';
import '../theme/theme_mode_provider.dart';

/// Contenu de l'onglet Accueil : score bien-être, profil utilisateur
class HomeScreen extends StatelessWidget {
  final LoginResponse user;

  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;
    final accent = scheme.secondary; // Cyan en mode contraste (daltonien), vert en clair

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User profile greeting section
              _buildNeumorphicCard(
                context,
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    // Avatar with soft shadow
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primary.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: primary.withOpacity(0.12),
                        child: Text(
                          (user.nom.isNotEmpty ? user.nom[0] : '?').toUpperCase(),
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).hello,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${user.nom}${user.prenom != null ? ' ${user.prenom}' : ''}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (user.role != null) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: accent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: accent.withOpacity(0.5), width: 1),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.badge_outlined, size: 18, color: accent),
                                  const SizedBox(width: 6),
                                  Text(
                                    user.role!.name,
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                          color: accent,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Wellness score circular progress chart
              _buildNeumorphicCard(
                context,
                padding: const EdgeInsets.all(28),
                child: Column(
                  children: [
                    Text(
                      'Score Bien-être',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: CustomPaint(
                        painter: _WellnessCircularProgress(
                          progress: 0.78,
                          backgroundColor: scheme.surfaceContainerHighest,
                          progressColor: primary,
                          accentColor: accent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '78%',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Engagement du mois',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              if (user.email != null && user.email!.isNotEmpty) ...[
                const SizedBox(height: 24),
                _buildNeumorphicCard(
                  context,
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(Icons.email_outlined, color: scheme.onSurface, size: 28),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          user.email!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNeumorphicCard(
    BuildContext context, {
    required EdgeInsets padding,
    required Widget child,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final isHighContrast = ThemeModeProvider.of(context) == AppThemeMode.highContrast;
    return Container(
      padding: padding,
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
                  color: scheme.outline.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(6, 6),
                ),
              ],
      ),
      child: child,
    );
  }
}

class _WellnessCircularProgress extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final Color accentColor;

  _WellnessCircularProgress({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 14.0;

    // Background arc
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [progressColor, accentColor],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
