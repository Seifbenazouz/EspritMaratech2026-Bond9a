/// Partenaire de running proposé par le matching IA.
class PartnerMatch {
  final String id;
  final String nom;
  final String? prenom;
  final String? email;
  final double? paceMoyenMinPerKm;
  final String? groupeNom;
  final String? groupeNiveau;
  final int score;
  final String? scoreDetail;

  PartnerMatch({
    required this.id,
    required this.nom,
    this.prenom,
    this.email,
    this.paceMoyenMinPerKm,
    this.groupeNom,
    this.groupeNiveau,
    required this.score,
    this.scoreDetail,
  });

  String get displayName =>
      [prenom, nom].where((e) => e != null && e.isNotEmpty).join(' ').trim();

  String get paceFormatted =>
      paceMoyenMinPerKm != null
          ? '${paceMoyenMinPerKm!.toStringAsFixed(1)} min/km'
          : '—';

  factory PartnerMatch.fromJson(Map<String, dynamic> json) {
    return PartnerMatch(
      id: json['id']?.toString() ?? '',
      nom: json['nom'] as String? ?? '',
      prenom: json['prenom'] as String?,
      email: json['email'] as String?,
      paceMoyenMinPerKm: json['paceMoyenMinPerKm'] != null
          ? (json['paceMoyenMinPerKm'] as num).toDouble()
          : null,
      groupeNom: json['groupeNom'] as String?,
      groupeNiveau: json['groupeNiveau'] as String?,
      score: json['score'] as int? ?? 0,
      scoreDetail: json['scoreDetail'] as String?,
    );
  }
}
