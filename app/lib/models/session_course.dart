import 'evenement.dart';

/// Session de course enregistrée (suivi GPS / sortie).
class SessionCourse {
  final int id;
  final double distanceKm;
  final int durationSeconds;
  final DateTime? startedAt;
  final String? track;
  final Evenement? evenement;

  SessionCourse({
    required this.id,
    required this.distanceKm,
    required this.durationSeconds,
    this.startedAt,
    this.track,
    this.evenement,
  });

  String get formattedDuration {
    final h = durationSeconds ~/ 3600;
    final m = (durationSeconds % 3600) ~/ 60;
    final s = durationSeconds % 60;
    if (h > 0) return '${h}h ${m}min';
    if (m > 0) return '${m}min ${s}s';
    return '${s}s';
  }

  /// Allure en min/km (si distance > 0).
  double? get allureMinPerKm {
    if (distanceKm <= 0) return null;
    return (durationSeconds / 60) / distanceKm;
  }

  factory SessionCourse.fromJson(Map<String, dynamic> json) {
    return SessionCourse(
      id: json['id'] as int,
      distanceKm: (json['distanceKm'] as num).toDouble(),
      durationSeconds: json['durationSeconds'] as int,
      startedAt: json['startedAt'] != null
          ? DateTime.tryParse(json['startedAt'].toString())
          : null,
      track: json['track'] as String?,
      evenement: json['evenement'] != null
          ? Evenement.fromJson(json['evenement'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'distanceKm': distanceKm,
        'durationSeconds': durationSeconds,
        'startedAt': startedAt?.toIso8601String(),
        'evenementId': evenement?.id,
        if (track != null && track!.isNotEmpty) 'track': track,
      };
}
