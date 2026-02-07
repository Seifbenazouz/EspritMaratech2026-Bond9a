import 'dart:convert';

import '../models/page_response.dart';
import '../models/session_course.dart';
import 'api_client.dart';

class SessionCourseService {
  final _api = ApiClient();

  /// Mes sessions (adhérent connecté).
  Future<PageResponse<SessionCourse>> getMySessions({
    int page = 0,
    int size = 20,
  }) async {
    final response = await _api.get(
      '/api/sessions-course/me',
      queryParams: {'page': page.toString(), 'size': size.toString()},
    );
    _api.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return PageResponse.fromJson(json, (m) => SessionCourse.fromJson(m));
  }

  Future<SessionCourse> create({
    required double distanceKm,
    required int durationSeconds,
    required DateTime startedAt,
    int? evenementId,
    String? track,
  }) async {
    final body = <String, dynamic>{
      'distanceKm': distanceKm,
      'durationSeconds': durationSeconds,
      'startedAt': startedAt.toUtc().toIso8601String(),
      if (evenementId != null) 'evenementId': evenementId,
      if (track != null && track.isNotEmpty) 'track': track,
    };
    final response = await _api.post('/api/sessions-course', body: body);
    _api.checkResponse(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return SessionCourse.fromJson(json);
  }

  Future<void> delete(int id) async {
    final response = await _api.delete('/api/sessions-course/$id');
    _api.checkResponse(response);
  }
}
