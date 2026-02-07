import 'dart:convert';

import '../models/page_response.dart';
import '../models/permission.dart';
import 'api_client.dart';

class PermissionService {
  final ApiClient _client = ApiClient();

  Future<PageResponse<Permission>> getAll({int page = 0, int size = 50}) async {
    final response = await _client.get(
      '/api/permissions',
      queryParams: {'page': page.toString(), 'size': size.toString()},
    );
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return PageResponse.fromJson(json, (m) => Permission.fromJson(m));
  }

  Future<Permission> getById(int id) async {
    final response = await _client.get('/api/permissions/$id');
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return Permission.fromJson(json);
  }

  Future<Permission> create(String nom, {String? description}) async {
    final body = <String, dynamic>{'nom': nom.trim()};
    if (description != null && description.trim().isNotEmpty) {
      body['description'] = description.trim();
    }
    final response = await _client.post('/api/permissions', body: body);
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return Permission.fromJson(json);
  }

  Future<Permission> update(int id, String nom, {String? description}) async {
    final body = <String, dynamic>{'nom': nom.trim()};
    if (description != null) body['description'] = description.trim();
    final response = await _client.put('/api/permissions/$id', body: body);
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return Permission.fromJson(json);
  }

  Future<void> delete(int id) async {
    final response = await _client.delete('/api/permissions/$id');
    _client.checkResponse(response);
  }
}
