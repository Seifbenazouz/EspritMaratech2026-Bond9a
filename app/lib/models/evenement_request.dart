class EvenementRequest {
  final String titre;
  final String? description;
  final DateTime? date;
  final String? type;
  /// Lieu de rencontre / localisation (adresse ou nom du lieu).
  final String? lieu;
  final double? latitude;
  final double? longitude;
  final int groupeId;

  EvenementRequest({
    required this.titre,
    this.description,
    this.date,
    this.type,
    this.lieu,
    this.latitude,
    this.longitude,
    required this.groupeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'titre': titre,
      if (description != null && description!.isNotEmpty) 'description': description,
      if (date != null) 'date': date!.toUtc().toIso8601String(),
      if (type != null && type!.isNotEmpty) 'type': type,
      if (lieu != null && lieu!.isNotEmpty) 'lieu': lieu,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'groupeId': groupeId,
    };
  }
}
