import 'dart:convert';

import '../models/stats_adherent.dart';
import 'api_client.dart';

class StatsAdherentService {
  final ApiClient _client = ApiClient();

  /// Mes statistiques (adhérent connecté).
  Future<StatsAdherent> getMe() async {
    final response = await _client.get('/api/stats-adherent/me');
    _client.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return StatsAdherent.fromJson(json);
  }
}
