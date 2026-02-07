import 'dart:convert';

import '../models/actualite.dart';
import '../models/page_response.dart';
import 'api_client.dart';

class ActualiteService {
  final ApiClient _client = ApiClient();

  /// Récupère les actualités (endpoint public - sans auth)
  Future<PageResponse<Actualite>> getNews({int page = 0, int size = 20}) async {
    final response = await _client.get(
      '/api/public/news',
      queryParams: {'page': page.toString(), 'size': size.toString()},
      withAuth: false,
    );
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return PageResponse.fromJson(json, (m) => Actualite.fromJson(m));
  }

  /// Publie une actualité (réservé ADMIN_PRINCIPAL)
  Future<Actualite> createActualite({required String titre, String? contenu}) async {
    final body = <String, dynamic>{
      'titre': titre,
      'contenu': contenu ?? '',
    };
    final response = await _client.post(
      '/api/actualites',
      body: body,
      withAuth: true,
    );
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return Actualite.fromJson(json);
  }
}
