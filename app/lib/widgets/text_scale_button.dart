import 'package:flutter/material.dart';

import '../theme/text_scale_provider.dart';

/// Bouton pour régler la taille du texte, des icônes et des menus
class TextScaleButton extends StatelessWidget {
  const TextScaleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.text_fields),
      tooltip: 'Taille du texte et des icônes',
      onPressed: () => _showTextScaleDialog(context),
    );
  }

  void _showTextScaleDialog(BuildContext context) {
    double scale = TextScaleProvider.of(context);

    showDialog<void>(
      context: context,
      builder: (ctx) {
        final screenWidth = MediaQuery.of(ctx).size.width;
        final responsiveScale = (screenWidth / 400).clamp(0.85, 1.35);
        return MediaQuery(
          data: MediaQuery.of(ctx).copyWith(
            textScaler: TextScaler.linear(responsiveScale),
          ),
          child: StatefulBuilder(
            builder: (ctx, setState) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: AlertDialog(
                    insetPadding: const EdgeInsets.symmetric(horizontal: 24),
                    contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                    titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    actionsPadding: const EdgeInsets.only(bottom: 8, right: 8),
                    title: Icon(Icons.text_fields, color: Theme.of(context).colorScheme.primary, size: 32),
                    content: Slider(
                      value: scale,
                      min: 0.8,
                      max: 1.8,
                      divisions: 10,
                      onChanged: (v) {
                        setState(() => scale = v);
                        TextScaleProvider.setScale(ctx, v);
                      },
                    ),
                    actions: [
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.close),
                        tooltip: 'Fermer',
                      ),
                    ],
                  ),
                ),
              );
          },
        ),
        );
      },
    );
  }
}
