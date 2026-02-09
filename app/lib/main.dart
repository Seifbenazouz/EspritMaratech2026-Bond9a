import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'models/login_response.dart';
import 'theme/app_theme.dart';
import 'theme/locale_provider.dart';
import 'theme/text_scale_provider.dart';
import 'theme/theme_mode_provider.dart';
import 'screens/change_password_screen.dart';
import 'screens/member_main_screen.dart';
import 'screens/welcome_screen.dart';
import 'services/auth_service.dart';
import 'services/push_notification_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Log build errors (red screen) to console for debugging
  ErrorWidget.builder = (FlutterErrorDetails details) {
    debugPrint('═══ WIDGET BUILD ERROR ═══');
    debugPrint(details.exception.toString());
    debugPrint(details.stack?.toString() ?? '');
    return ErrorWidget(details.exception);
  };

  // Initialisation Firebase FCM (sans bloquer si non configuré)
  try {
    await PushNotificationService().initialize();
  } catch (_) {}

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final ValueNotifier<AppThemeMode> _themeMode = ValueNotifier(AppThemeMode.light);
  final ValueNotifier<double> _textScale = ValueNotifier(1.0);
  final ValueNotifier<Locale> _locale = ValueNotifier(const Locale('fr'));
  final StorageService _storage = StorageService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadLocale();
    _locale.addListener(_onLocaleChanged);
  }

  void _onLocaleChanged() {
    _storage.saveLocale(_locale.value.languageCode);
  }

  Future<void> _loadLocale() async {
    final code = await _storage.getLocale();
    if (code != null && ['fr', 'en', 'ar', 'it', 'de'].contains(code)) {
      _locale.value = Locale(code);
    }
  }

  @override
  void dispose() {
    _locale.removeListener(_onLocaleChanged);
    WidgetsBinding.instance.removeObserver(this);
    _themeMode.dispose();
    _textScale.dispose();
    _locale.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      PushNotificationService().registerTokenWithBackend();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LocaleController(
      setLocale: (locale) => _locale.value = locale,
      child: ThemeModeProvider(
        notifier: _themeMode,
        child: TextScaleProvider(
          notifier: _textScale,
          child: LocaleProvider(
            notifier: _locale,
            child: ValueListenableBuilder<Locale>(
              valueListenable: _locale,
              builder: (context, locale, _) {
                return ValueListenableBuilder<AppThemeMode>(
                  valueListenable: _themeMode,
                  builder: (context, mode, _) {
                    return ValueListenableBuilder<double>(
                      valueListenable: _textScale,
                      builder: (context, scale, _) {
                        return MaterialApp(
                          title: 'Running Club Tunis',
                          showSemanticsDebugger: false,
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
                          theme: AppTheme.fromMode(mode, scale: scale),
                          builder: (context, child) {
                            return MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                textScaler: TextScaler.linear(scale),
                              ),
                              child: Semantics(
                                label: 'Running Club Tunis',
                                child: child ?? const SizedBox.shrink(),
                              ),
                            );
                          },
                          home: const AuthWrapper(),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Vérifie si l'utilisateur est connecté au démarrage
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _auth = AuthService();
  final StorageService _storage = StorageService();

  bool _isChecking = true;
  Widget? _initialScreen;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final token = await _auth.getToken();
    LoginResponse? user;
    if (token != null && token.isNotEmpty) {
      final userJson = await _storage.getUser();
      if (userJson != null && userJson.isNotEmpty) {
        try {
          final map = jsonDecode(userJson) as Map<String, dynamic>;
          user = LoginResponse.fromJson(map);
        } catch (_) {}
      }
    }

    if (!mounted) return;
    setState(() {
      if (user != null && user!.passwordChangeRequired) {
        _initialScreen = ChangePasswordScreen(user: user!);
      } else if (user != null) {
        _initialScreen = MemberMainScreen(user: user!);
      } else {
        _initialScreen = const WelcomeScreen();
      }
      _isChecking = false;
    });

    // Enregistrer le token FCM si l'utilisateur est connecté (plusieurs essais : token parfois pas prêt au démarrage)
    if (user != null) {
      try {
        final push = PushNotificationService();
        var registered = await push.registerTokenWithBackend();
        if (!registered) {
          for (final delay in [2, 5, 10]) {
            await Future.delayed(Duration(seconds: delay));
            registered = await push.registerTokenWithBackend();
            if (registered) break;
          }
        }
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return _initialScreen ?? const WelcomeScreen();
  }
}
