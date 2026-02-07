import 'package:flutter/material.dart';

/// Fournit le facteur d'échelle du texte à toute l'app (1.0 = 100%)
class TextScaleProvider extends InheritedNotifier<ValueNotifier<double>> {
  const TextScaleProvider({
    super.key,
    required ValueNotifier<double> notifier,
    required super.child,
  }) : super(notifier: notifier);

  static double of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TextScaleProvider>()!
        .notifier!
        .value;
  }

  static void setScale(BuildContext context, double scale) {
    final provider = context.dependOnInheritedWidgetOfExactType<TextScaleProvider>();
    if (provider?.notifier != null) {
      provider!.notifier!.value = scale.clamp(0.8, 1.8);
    }
  }
}
