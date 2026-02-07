import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/l10n/app_localizations.dart';
import 'package:app/screens/welcome_screen.dart';
import 'package:app/theme/locale_provider.dart';
import 'package:app/theme/text_scale_provider.dart';
import 'package:app/theme/theme_mode_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Test du bouton de changement de langue (FR / EN / AR / IT / DE)
void main() {
  final localeNotifier = ValueNotifier(const Locale('fr'));

  Widget wrapApp(Widget child, Locale locale) {
    localeNotifier.value = locale;
    return LocaleController(
      setLocale: (l) => localeNotifier.value = l,
      child: ThemeModeProvider(
        notifier: ValueNotifier(AppThemeMode.light),
        child: TextScaleProvider(
          notifier: ValueNotifier(1.0),
          child: LocaleProvider(
            notifier: localeNotifier,
            child: MaterialApp(
            locale: locale,
            supportedLocales: const [
              Locale('fr'),
              Locale('en'),
              Locale('ar'),
              Locale('it'),
              Locale('de'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: child,
          ),
        ),
      ),
    ),
    );
  }

  group('Bouton de langue', () {
    testWidgets('Le bouton langue est visible sur WelcomeScreen', (tester) async {
      await tester.pumpWidget(wrapApp(const WelcomeScreen(), const Locale('fr')));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.language), findsOneWidget);
    });

    testWidgets('Le menu affiche les 5 langues (FR, EN, AR, IT, DE)',
        (tester) async {
      await tester.pumpWidget(wrapApp(const WelcomeScreen(), const Locale('fr')));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.language));
      await tester.pumpAndSettle();

      expect(find.text('Français'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('العربية'), findsOneWidget);
      expect(find.text('Italiano'), findsOneWidget);
      expect(find.text('Deutsch'), findsOneWidget);
    });

    testWidgets('Changement vers anglais met à jour les textes', (tester) async {
      await tester.pumpWidget(wrapApp(const WelcomeScreen(), const Locale('en')));
      await tester.pumpAndSettle();

      expect(find.text('Continue as visitor'), findsOneWidget);
      expect(find.text('Sign in'), findsOneWidget);
    });

    testWidgets('Changement vers italien met à jour les textes', (tester) async {
      await tester.pumpWidget(wrapApp(const WelcomeScreen(), const Locale('it')));
      await tester.pumpAndSettle();

      expect(find.text('Continua come visitatore'), findsOneWidget);
      expect(find.text('Accedi'), findsOneWidget);
    });

    testWidgets('Changement vers allemand met à jour les textes', (tester) async {
      await tester.pumpWidget(wrapApp(const WelcomeScreen(), const Locale('de')));
      await tester.pumpAndSettle();

      expect(find.text('Als Besucher fortfahren'), findsOneWidget);
      expect(find.text('Anmelden'), findsOneWidget);
    });

    testWidgets('AppLocalizations.of retourne la bonne locale', (tester) async {
      await tester.pumpWidget(wrapApp(const WelcomeScreen(), const Locale('fr')));
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(tester.element(find.byType(WelcomeScreen)));
      expect(l10n.continueVisitor, 'Continuer en visiteur');
      expect(l10n.connect, 'Se connecter');
    });
  });
}
