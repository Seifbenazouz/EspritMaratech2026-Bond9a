import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'auth_service.dart';
import 'storage_service.dart';

/// Client HTTP avec support du token JWT pour les requêtes authentifiées
class ApiClient {
  static final ApiClient _instance = ApiClient._();
  factory ApiClient() => _instance;

  final AuthService _auth = AuthService();
  final StorageService _storage = StorageService();

  ApiClient._();

  Future<Map<String, String>> _headers({bool withAuth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (withAuth) {
      final token = await _auth.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Future<http.Response> get(
    String path, {
    Map<String, String>? queryParams,
    bool withAuth = true,
  }) async {
    var uri = Uri.parse('${ApiConfig.baseUrl}$path');
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }
    return http.get(uri, headers: await _headers(withAuth: withAuth));
  }

  Future<http.Response> post(
    String path, {
    Object? body,
    bool withAuth = true,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    return http.post(
      uri,
      headers: await _headers(withAuth: withAuth),
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> put(
    String path, {
    Object? body,
    bool withAuth = true,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    return http.put(
      uri,
      headers: await _headers(withAuth: withAuth),
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> delete(
    String path, {
    bool withAuth = true,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    return http.delete(uri, headers: await _headers(withAuth: withAuth));
  }

  /// Lance une exception avec le message d'erreur si statusCode >= 400
  void checkResponse(http.Response response) {
    if (response.statusCode >= 400) {
      String msg = response.body;
      try {
        final json = jsonDecode(response.body);
        if (json is Map && (json['message'] != null || json['error'] != null)) {
          msg = (json['message'] ?? json['error'] ?? response.body).toString();
        }
      } catch (_) {}
      throw Exception(msg);
    }
  }
}
