import 'package:flutter/material.dart';

import '../theme/theme_mode_provider.dart';

/// Carte au style neumorphique, cohérente avec le design de l'application.
class NeumorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const NeumorphicCard({
    super.key,
    required this.child,
    required this.padding,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isHighContrast =
        ThemeModeProvider.of(context) == AppThemeMode.highContrast;

    final content = padding == EdgeInsets.zero
        ? child
        : Padding(padding: padding, child: child);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: isHighContrast
            ? Border.all(color: scheme.outline, width: 2)
            : null,
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
      child: onTap != null
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(28),
                child: content,
              ),
            )
          : content,
    );
  }
}
