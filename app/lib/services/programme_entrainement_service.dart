import 'dart:convert';

import '../models/page_response.dart';
import '../models/programme_entrainement.dart';
import 'api_client.dart';

class ProgrammeEntrainementService {
  final ApiClient _client = ApiClient();

  /// Envoie une date en ISO-8601 avec timezone (Z) pour que Java Instant puisse la parser.
  static String _toInstantString(DateTime date) {
    final utc = DateTime.utc(date.year, date.month, date.day, date.hour, date.minute, date.second, date.millisecond);
    return utc.toIso8601String();
  }

  Future<PageResponse<ProgrammeEntrainement>> getAll({
    int page = 0,
    int size = 50,
  }) async {
    final response = await _client.get(
      '/api/programmes-entrainement',
      queryParams: {'page': page.toString(), 'size': size.toString()},
    );
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return PageResponse.fromJson(json, (m) => ProgrammeEntrainement.fromJson(m));
  }

  Future<ProgrammeEntrainement> getById(int id) async {
    final response = await _client.get('/api/programmes-entrainement/$id');
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return ProgrammeEntrainement.fromJson(json);
  }

  Future<PageResponse<ProgrammeEntrainement>> getByGroupeId(
    int groupeId, {
    int page = 0,
    int size = 50,
  }) async {
    final response = await _client.get(
      '/api/programmes-entrainement/groupe/$groupeId',
      queryParams: {'page': page.toString(), 'size': size.toString()},
    );
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return PageResponse.fromJson(json, (m) => ProgrammeEntrainement.fromJson(m));
  }

  Future<ProgrammeEntrainement> create({
    required String titre,
    String? description,
    DateTime? dateDebut,
    DateTime? dateFin,
    required int groupeId,
  }) async {
    final body = <String, dynamic>{
      'titre': titre,
      'groupeId': groupeId,
    };
    if (description != null && description.isNotEmpty) body['description'] = description;
    if (dateDebut != null) body['dateDebut'] = _toInstantString(dateDebut);
    if (dateFin != null) body['dateFin'] = _toInstantString(dateFin);
    final response = await _client.post('/api/programmes-entrainement', body: body);
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return ProgrammeEntrainement.fromJson(json);
  }

  Future<ProgrammeEntrainement> update({
    required int id,
    required String titre,
    String? description,
    DateTime? dateDebut,
    DateTime? dateFin,
    required int groupeId,
  }) async {
    final body = <String, dynamic>{
      'titre': titre,
      'groupeId': groupeId,
    };
    if (description != null) body['description'] = description;
    if (dateDebut != null) body['dateDebut'] = _toInstantString(dateDebut);
    if (dateFin != null) body['dateFin'] = _toInstantString(dateFin);
    final response = await _client.put('/api/programmes-entrainement/$id', body: body);
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return ProgrammeEntrainement.fromJson(json);
  }

  Future<void> delete(int id) async {
    final response = await _client.delete('/api/programmes-entrainement/$id');
    _client.checkResponse(response);
  }
}
