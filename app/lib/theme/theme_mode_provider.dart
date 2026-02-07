import 'package:flutter/material.dart';

/// Modes de thème : Clair, Sombre, Contraste élevé
enum AppThemeMode { light, dark, highContrast }

/// Fournit le mode de thème actuel à toute l'app
class ThemeModeProvider extends InheritedNotifier<ValueNotifier<AppThemeMode>> {
  const ThemeModeProvider({
    super.key,
    required ValueNotifier<AppThemeMode> notifier,
    required super.child,
  }) : super(notifier: notifier);

  static AppThemeMode of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ThemeModeProvider>()!
        .notifier!
        .value;
  }

  static void setThemeMode(BuildContext context, AppThemeMode mode) {
    final provider = context.dependOnInheritedWidgetOfExactType<ThemeModeProvider>();
    if (provider?.notifier != null) {
      provider!.notifier!.value = mode;
    }
  }
}
