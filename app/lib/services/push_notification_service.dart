import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../config/api_config.dart';
import '../firebase_options.dart';
import 'api_client.dart';

/// Service pour les notifications push FCM.
/// Nécessite Firebase configuré (flutterfire configure).
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final title = message.notification?.title ?? message.data['title'];
  final body = message.notification?.body ?? message.data['body'];
  debugPrint('Background notification: $title - $body');
}

class PushNotificationService {
  static final PushNotificationService _instance = PushNotificationService._();
  factory PushNotificationService() => _instance;

  FirebaseMessaging? _messaging;
  final ApiClient _api = ApiClient();

  bool _initialized = false;
  String? _token;

  PushNotificationService._();

  bool get isInitialized => _initialized;
  String? get token => _token;

  /// Initialise Firebase et FCM. Retourne true si succès.
  Future<bool> initialize() async {
    if (_initialized) return true;

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _messaging = FirebaseMessaging.instance;

      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      final settings = await _messaging!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        debugPrint('FCM: Permission refusée');
        return false;
      }

      _token = await _messaging!.getToken();
      if (_token != null) {
        debugPrint('FCM Token: $_token');
      }

      FirebaseMessaging.onMessage.listen(_onForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

      final initialMessage = await _messaging!.getInitialMessage();
      if (initialMessage != null) {
        _onMessageOpenedApp(initialMessage);
      }

      _messaging!.onTokenRefresh.listen((newToken) {
        _token = newToken;
        debugPrint('FCM Token refresh: $newToken');
        registerTokenWithBackend();
      });

      _initialized = true;
      return true;
    } catch (e) {
      debugPrint('FCM init error: $e');
      return false;
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    final title = message.notification?.title ?? message.data['title'];
    final body = message.notification?.body ?? message.data['body'];
    debugPrint('Foreground: $title - $body');
    // En premier plan, la notification système n'apparaît pas toujours :
    // l'utilisateur voit le message ici en log ; pour l'afficher à l'écran
    // il faudrait utiliser flutter_local_notifications.
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint('Opened from notification: ${message.notification?.title}');
    // Navigation possible vers un écran spécifique selon message.data
  }

  /// Attend que le token FCM soit disponible (avec retries, max ~15 secondes)
  Future<String?> ensureTokenReady() async {
    if (!_initialized || _messaging == null) return null;
    if (_token != null && _token!.isNotEmpty) return _token;
    for (var i = 0; i < 5; i++) {
      await Future.delayed(Duration(seconds: 1 + i));
      _token = await _messaging!.getToken();
      if (_token != null && _token!.isNotEmpty) {
        debugPrint('FCM Token (obtenu après attente): $_token');
        return _token;
      }
    }
    debugPrint('FCM: token non disponible après plusieurs tentatives');
    return null;
  }

  /// Enregistre le token FCM sur le backend (utilisateur connecté)
  Future<bool> registerTokenWithBackend() async {
    if (!_initialized) {
      debugPrint('FCM: registerTokenWithBackend ignoré (non initialisé)');
      return false;
    }

    // Rafraîchir le token si pas encore disponible
    var token = _token ?? (_messaging != null ? await _messaging!.getToken() : null);
    if (token == null || token.isEmpty) {
      token = await ensureTokenReady();
    }
    if (token == null || token.isEmpty) {
      debugPrint('FCM: registerTokenWithBackend ignoré (token indisponible)');
      return false;
    }
    _token = token;

    try {
      debugPrint('FCM: envoi du token vers ${ApiConfig.baseUrl}/api/auth/fcm-token ...');
      final response = await _api.post(
        '/api/auth/fcm-token',
        body: {'token': token},
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('FCM: token enregistré sur le backend (${response.statusCode})');
        return true;
      }
      debugPrint('FCM: backend a refusé le token: ${response.statusCode} ${response.body}');
    } catch (e) {
      debugPrint('FCM register backend error: $e');
      debugPrint('FCM: vérifiez baseUrl (IP du PC) et que le téléphone peut joindre le backend (même réseau ou IP du PC quand le téléphone est en hotspot).');
    }
    return false;
  }
}
