import 'dart:convert';

import '../models/historique.dart';
import '../models/page_response.dart';
import 'api_client.dart';

class HistoriqueService {
  final ApiClient _client = ApiClient();

  /// Récupère l'historique (endpoint public - sans auth)
  Future<PageResponse<Historique>> getHistorique({
    int page = 0,
    int size = 20,
  }) async {
    final response = await _client.get(
      '/api/public/historique',
      queryParams: {'page': page.toString(), 'size': size.toString()},
      withAuth: false,
    );
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return PageResponse.fromJson(json, (m) => Historique.fromJson(m));
  }
}
