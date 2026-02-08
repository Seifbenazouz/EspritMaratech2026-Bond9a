import 'dart:convert';

import '../models/partner_match.dart';
import 'api_client.dart';

class MatchingService {
  final ApiClient _client = ApiClient();

  /// Récupère les partenaires de running proposés par l'IA (adhérent uniquement).
  Future<List<PartnerMatch>> getPartners() async {
    final response = await _client.get('/api/matching/partenaires');
    _client.checkResponse(response);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => PartnerMatch.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Envoie une invitation à courir au partenaire (notification push).
  Future<void> inviterPartenaire(String targetUserId) async {
    final response =
        await _client.post('/api/matching/inviter/$targetUserId');
    _client.checkResponse(response);
  }
}
