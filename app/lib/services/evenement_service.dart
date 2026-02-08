import 'dart:convert';

import '../models/evenement.dart';
import '../models/evenement_request.dart';
import '../models/page_response.dart';
import 'api_client.dart';

class EvenementService {
  final ApiClient _client = ApiClient();

  /// Liste tous les événements (auth requise)
  Future<PageResponse<Evenement>> getAll({
    int page = 0,
    int size = 50,
  }) async {
    final response = await _client.get(
      '/api/evenements',
      queryParams: {'page': page.toString(), 'size': size.toString()},
    );
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return PageResponse.fromJson(json, (m) => Evenement.fromJson(m));
  }

  /// Détail d'un événement
  Future<Evenement> getById(int id) async {
    final response = await _client.get('/api/evenements/$id');
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return Evenement.fromJson(json);
  }

  /// Créer un événement (admin)
  Future<Evenement> create(EvenementRequest request) async {
    final response = await _client.post(
      '/api/evenements',
      body: request.toJson(),
    );
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return Evenement.fromJson(json);
  }

  /// Modifier un événement (admin)
  Future<Evenement> update(int id, EvenementRequest request) async {
    final response = await _client.put(
      '/api/evenements/$id',
      body: request.toJson(),
    );
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return Evenement.fromJson(json);
  }

  /// Supprimer un événement (admin)
  Future<void> delete(int id) async {
    final response = await _client.delete('/api/evenements/$id');
    _client.checkResponse(response);
  }

  /// Événements passés (date < now) pour l'historique
  Future<PageResponse<Evenement>> getPastEvents({
    int page = 0,
    int size = 200,
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();
    final response = await _client.get(
      '/api/evenements/search',
      queryParams: {
        'debut': '1970-01-01T00:00:00Z',
        'fin': now,
        'page': page.toString(),
        'size': size.toString(),
      },
    );
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return PageResponse.fromJson(json, (m) => Evenement.fromJson(m));
  }

  /// Événements par groupe
  Future<PageResponse<Evenement>> getByGroupe(
    int groupeId, {
    int page = 0,
    int size = 20,
  }) async {
    final response = await _client.get(
      '/api/evenements/groupe/$groupeId',
      queryParams: {'page': page.toString(), 'size': size.toString()},
    );
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return PageResponse.fromJson(json, (m) => Evenement.fromJson(m));
  }
}
