import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import 'push_notification_service.dart';
import 'storage_service.dart';

class AuthService {
  final StorageService _storage = StorageService();

  Future<LoginResponse> login(LoginRequest request) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final loginResponse = LoginResponse.fromJson(json);
      await _storage.saveToken(loginResponse.token);
      await _storage.saveUser(jsonEncode(json));

      // Enregistrer le token FCM (délai initial + plusieurs essais : le token n'est pas toujours prêt tout de suite)
      try {
        final push = PushNotificationService();
        debugPrint('FCM: après login, tentative d\'enregistrement du token dans 1s...');
        await Future.delayed(const Duration(seconds: 1));
        var registered = await push.registerTokenWithBackend();
        if (!registered) {
          debugPrint('FCM: 1ère tentative échouée, retries à 3s, 6s, 12s...');
          for (final delay in [3, 6, 12]) {
            await Future.delayed(Duration(seconds: delay));
            registered = await push.registerTokenWithBackend();
            if (registered) break;
          }
        }
        if (!registered) {
          debugPrint('FCM: échec après toutes les tentatives. Vérifiez les logs ci-dessus et que le téléphone atteint le backend (${ApiConfig.baseUrl}).');
        }
      } catch (e, st) {
        debugPrint('FCM: exception lors de l\'enregistrement: $e');
        debugPrint('FCM: $st');
      }

      return loginResponse;
    } else {
      final body = response.body;
      final msg = body.isNotEmpty ? jsonDecode(body) : null;
      final err = msg is Map ? (msg['message'] ?? msg['error'] ?? body) : body;
      throw Exception(err.toString());
    }
  }

  Future<String?> getToken() => _storage.getToken();

  Future<bool> isLoggedIn() async {
    final token = await _storage.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    await _storage.clearAuth();
  }
}
