import 'package:flutter/material.dart';

/// Langues supportées : Français, Anglais, Arabe, Italien, Allemand
enum AppLocale {
  fr(Locale('fr'), 'Français'),
  en(Locale('en'), 'English'),
  ar(Locale('ar'), 'العربية'),
  it(Locale('it'), 'Italiano'),
  de(Locale('de'), 'Deutsch');

  const AppLocale(this.locale, this.label);
  final Locale locale;
  final String label;
}

/// Callback pour changer la locale - fourni au plus haut niveau pour éviter les soucis de contexte (overlay)
class LocaleController extends InheritedWidget {
  const LocaleController({
    super.key,
    required this.setLocale,
    required super.child,
  });

  final void Function(Locale locale) setLocale;

  @override
  bool updateShouldNotify(LocaleController oldWidget) => setLocale != oldWidget.setLocale;

  static LocaleController of(BuildContext context) {
    final controller = context.dependOnInheritedWidgetOfExactType<LocaleController>();
    assert(controller != null, 'LocaleController not found. Wrap app with LocaleController.');
    return controller!;
  }
}

/// Fournit la locale actuelle à toute l'app
class LocaleProvider extends InheritedNotifier<ValueNotifier<Locale>> {
  const LocaleProvider({
    super.key,
    required ValueNotifier<Locale> notifier,
    required super.child,
  }) : super(notifier: notifier);

  static Locale of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<LocaleProvider>()!
        .notifier!
        .value;
  }

  static void setLocale(BuildContext context, Locale locale) {
    LocaleController.of(context).setLocale(locale);
  }
}
