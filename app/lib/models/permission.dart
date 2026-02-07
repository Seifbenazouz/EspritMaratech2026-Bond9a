/// Permission (nom + phrase lisible) - gestion par ADMIN_PRINCIPAL.
class Permission {
  final int id;
  final String nom;
  final String? description;

  Permission({required this.id, required this.nom, this.description});

  /// Phrase affichée : description si présente, sinon nom.
  String get libelle => (description != null && description!.trim().isNotEmpty)
      ? description!
      : nom;

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'] as int,
      nom: json['nom'] as String,
      description: json['description'] as String?,
    );
  }
}
