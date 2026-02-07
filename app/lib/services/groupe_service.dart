import 'dart:convert';

import '../models/groupe_running.dart';
import '../models/page_response.dart';
import 'api_client.dart';

class GroupeService {
  final ApiClient _client = ApiClient();

  Future<PageResponse<GroupeRunning>> getAll({
    int page = 0,
    int size = 50,
  }) async {
    final response = await _client.get(
      '/api/groupes-running',
      queryParams: {'page': page.toString(), 'size': size.toString()},
    );
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return PageResponse.fromJson(json, (m) => GroupeRunning.fromJson(m));
  }

  Future<GroupeRunning> getById(int id) async {
    final response = await _client.get('/api/groupes-running/$id');
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return GroupeRunning.fromJson(json);
  }

  /// Ajouter un adhérent au groupe (ADMIN_PRINCIPAL, ADMIN_GROUPE)
  Future<GroupeRunning> addMembre(int groupeId, String adherentId) async {
    final response = await _client.post(
      '/api/groupes-running/$groupeId/membres/$adherentId',
    );
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return GroupeRunning.fromJson(json);
  }

  /// Retirer un adhérent du groupe (ADMIN_PRINCIPAL, ADMIN_GROUPE)
  Future<GroupeRunning> removeMembre(int groupeId, String adherentId) async {
    final response = await _client.delete(
      '/api/groupes-running/$groupeId/membres/$adherentId',
    );
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return GroupeRunning.fromJson(json);
  }
}
