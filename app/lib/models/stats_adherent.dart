/// Statistiques de course d'un adhérent.
class StatsAdherent {
  final double totalDistanceKm;
  final int nbSorties;
  final double? paceMoyenMinPerKm;
  final int nbEvenements;
  final double? plusLongueSortieKm;
  final double? meilleurPaceMinPerKm;

  const StatsAdherent({
    required this.totalDistanceKm,
    required this.nbSorties,
    this.paceMoyenMinPerKm,
    required this.nbEvenements,
    this.plusLongueSortieKm,
    this.meilleurPaceMinPerKm,
  });

  factory StatsAdherent.fromJson(Map<String, dynamic> json) {
    return StatsAdherent(
      totalDistanceKm: (json['totalDistanceKm'] as num?)?.toDouble() ?? 0,
      nbSorties: json['nbSorties'] as int? ?? 0,
      paceMoyenMinPerKm: json['paceMoyenMinPerKm'] != null
          ? (json['paceMoyenMinPerKm'] as num).toDouble()
          : null,
      nbEvenements: json['nbEvenements'] as int? ?? 0,
      plusLongueSortieKm: json['plusLongueSortieKm'] != null
          ? (json['plusLongueSortieKm'] as num).toDouble()
          : null,
      meilleurPaceMinPerKm: json['meilleurPaceMinPerKm'] != null
          ? (json['meilleurPaceMinPerKm'] as num).toDouble()
          : null,
    );
  }
}
