import 'dart:convert';

import '../models/page_response.dart';
import '../models/user.dart';
import 'api_client.dart';

class UserService {
  final ApiClient _client = ApiClient();

  /// Liste paginée de tous les utilisateurs (ADMIN_PRINCIPAL)
  Future<PageResponse<User>> getAll({int page = 0, int size = 20}) async {
    final response = await _client.get(
      '/api/users',
      queryParams: {'page': page.toString(), 'size': size.toString()},
    );
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return PageResponse.fromJson(json, (m) => User.fromJson(m));
  }

  /// Détail d'un utilisateur
  Future<User> getById(String id) async {
    final response = await _client.get('/api/users/$id');
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return User.fromJson(json);
  }

  /// Liste des adhérents (pour affectation aux groupes)
  Future<List<User>> getAdherents() async {
    final response = await _client.get('/api/users/adherents');
    _client.checkResponse(response);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Création d'un utilisateur (ADMIN_PRINCIPAL)
  Future<User> create({
    required String nom,
    required String prenom,
    required String email,
    int? phone,
    required int cin,
    required String role,
  }) async {
    final body = <String, dynamic>{
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'cin': cin,
      'role': role,
    };
    if (phone != null) body['phone'] = phone;
    final response = await _client.post('/api/users', body: body);
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return User.fromJson(json);
  }

  /// Mise à jour d'un utilisateur (ADMIN_PRINCIPAL)
  Future<User> update({
    required String id,
    required String nom,
    required String prenom,
    required String email,
    int? phone,
    required String role,
  }) async {
    final body = <String, dynamic>{
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'role': role,
    };
    if (phone != null) body['phone'] = phone;
    final response = await _client.put('/api/users/$id', body: body);
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return User.fromJson(json);
  }

  /// Suppression d'un utilisateur (ADMIN_PRINCIPAL)
  Future<void> delete(String id) async {
    final response = await _client.delete('/api/users/$id');
    _client.checkResponse(response);
  }
}
