import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/screens/login_screen.dart';
import 'package:app/screens/welcome_screen.dart';
import 'package:app/theme/text_scale_provider.dart';
import 'package:app/theme/theme_mode_provider.dart';

Widget _wrapWithProviders(Widget child) {
  return ThemeModeProvider(
    notifier: ValueNotifier(AppThemeMode.light),
    child: TextScaleProvider(
      notifier: ValueNotifier(1.0),
      child: child,
    ),
  );
}

/// Tests TalkBack/accessibility: semantics, labels, tap targets
void main() {
  group('TalkBack / Accessibilité', () {
    testWidgets('WelcomeScreen a des semantics et des labels', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          MaterialApp(
            home: const WelcomeScreen(),
          ),
        ),
      );
      await tester.ensureSemantics();

      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(find.text('Running Club Tunis'), findsOneWidget);
      expect(find.text('Continuer en visiteur'), findsOneWidget);
      expect(find.text('Se connecter'), findsOneWidget);
    });

    testWidgets('LoginScreen a des semantics et champs accessibles', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          MaterialApp(
            home: const LoginScreen(),
          ),
        ),
      );
      await tester.ensureSemantics();

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.text('Connexion'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));

      final semantics = tester.getSemantics(find.byType(LoginScreen));
      expect(semantics, isNotNull);
    });

    testWidgets('Tous les boutons tappables ont des labels (labeledTapTargetGuideline)',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          MaterialApp(
            home: const WelcomeScreen(),
          ),
        ),
      );
      await tester.ensureSemantics();

      expect(tester, meetsGuideline(labeledTapTargetGuideline));
    });

    testWidgets('LoginScreen - tap targets respectent la taille minimale Android',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          MaterialApp(
            home: const LoginScreen(),
          ),
        ),
      );
      await tester.ensureSemantics();

      expect(tester, meetsGuideline(androidTapTargetGuideline));
    });

    testWidgets('WelcomeScreen - tap targets respectent la taille minimale',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          MaterialApp(
            home: const WelcomeScreen(),
          ),
        ),
      );
      await tester.ensureSemantics();

      expect(tester, meetsGuideline(androidTapTargetGuideline));
    });
  });
}
