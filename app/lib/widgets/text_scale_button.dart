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
      barrierColor: Colors.black38,
      barrierDismissible: true,
      builder: (ctx) {
        final scheme = Theme.of(ctx).colorScheme;
        return Dialog(
          alignment: Alignment.center,
          insetPadding: const EdgeInsets.all(40),
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (ctx, setState) {
              return Material(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(6),
                elevation: 4,
                child: IntrinsicHeight(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 44),
                    constraints: const BoxConstraints(maxWidth: 220, maxHeight: 140),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.text_fields, color: scheme.primary, size: 28),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 130,
                          child: SliderTheme(
                            data: SliderTheme.of(ctx).copyWith(
                              trackHeight: 4,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                            ),
                            child: Slider(
                              value: scale,
                              min: 0.8,
                              max: 1.8,
                              divisions: 10,
                              onChanged: (v) {
                                setState(() => scale = v);
                                TextScaleProvider.setScale(ctx, v);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        InkWell(
                          onTap: () => Navigator.of(ctx).pop(),
                          borderRadius: BorderRadius.circular(4),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(Icons.close, size: 22, color: scheme.onSurface),
                          ),
                        ),
                    ],
                  ),
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
