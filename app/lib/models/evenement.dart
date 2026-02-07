import 'groupe_running.dart';

class Evenement {
  final int id;
  final String titre;
  final String? description;
  final DateTime? date;
  final String? type;
  /// Lieu de rencontre / localisation de l'événement.
  final String? lieu;
  final double? latitude;
  final double? longitude;
  final GroupeRunning? groupe;

  Evenement({
    required this.id,
    required this.titre,
    this.description,
    this.date,
    this.type,
    this.lieu,
    this.latitude,
    this.longitude,
    this.groupe,
  });

  factory Evenement.fromJson(Map<String, dynamic> json) {
    return Evenement(
      id: json['id'] as int,
      titre: json['titre'] as String,
      description: json['description'] as String?,
      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString())
          : null,
      type: json['type'] as String?,
      lieu: json['lieu'] as String?,
      latitude: json['latitude'] != null
          ? (json['latitude'] is int
              ? (json['latitude'] as int).toDouble()
              : json['latitude'] as double?)
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] is int
              ? (json['longitude'] as int).toDouble()
              : json['longitude'] as double?)
          : null,
      groupe: json['groupe'] != null
          ? GroupeRunning.fromJson(json['groupe'] as Map<String, dynamic>)
          : null,
    );
  }
}
