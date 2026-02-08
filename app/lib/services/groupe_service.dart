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

  /// Groupes accessibles : ADMIN_PRINCIPAL voit tous, ADMIN_GROUPE voit uniquement son groupe.
  Future<PageResponse<GroupeRunning>> getMesGroupes({
    int page = 0,
    int size = 50,
  }) async {
    final response = await _client.get(
      '/api/groupes-running/mes-groupes',
      queryParams: {'page': page.toString(), 'size': size.toString()},
    );
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return PageResponse.fromJson(json, (m) => GroupeRunning.fromJson(m));
  }

  /// Créer un groupe (ADMIN_PRINCIPAL uniquement)
  Future<GroupeRunning> create({
    required String nom,
    String? niveau,
    String? description,
    String? responsableId,
  }) async {
    final body = <String, dynamic>{
      'nom': nom,
      'niveau': niveau ?? '',
      'description': description ?? '',
    };
    if (responsableId != null && responsableId.isNotEmpty) {
      body['responsableId'] = responsableId;
    }
    final response = await _client.post('/api/groupes-running', body: body);
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return GroupeRunning.fromJson(json);
  }

  /// Modifier un groupe (ADMIN_PRINCIPAL uniquement)
  Future<GroupeRunning> update({
    required int id,
    required String nom,
    String? niveau,
    String? description,
    String? responsableId,
  }) async {
    final body = <String, dynamic>{
      'nom': nom,
      'niveau': niveau ?? '',
      'description': description ?? '',
    };
    if (responsableId != null && responsableId.isNotEmpty) {
      body['responsableId'] = responsableId;
    } else {
      body['responsableId'] = null;
    }
    final response = await _client.put('/api/groupes-running/$id', body: body);
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return GroupeRunning.fromJson(json);
  }

  /// Groupes auxquels appartient un adhérent (GET /api/groupes-running/membre/{adherentId})
  Future<PageResponse<GroupeRunning>> getGroupesByMembreId(
    String adherentId, {
    int page = 0,
    int size = 50,
  }) async {
    final response = await _client.get(
      '/api/groupes-running/membre/$adherentId',
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
