class Actualite {
  final int id;
  final String titre;
  final String? contenu;
  final DateTime? datePublication;

  Actualite({
    required this.id,
    required this.titre,
    this.contenu,
    this.datePublication,
  });

  factory Actualite.fromJson(Map<String, dynamic> json) {
    return Actualite(
      id: json['id'] as int,
      titre: json['titre'] as String,
      contenu: json['contenu'] as String?,
      datePublication: json['datePublication'] != null
          ? DateTime.tryParse(json['datePublication'].toString())
          : null,
    );
  }
}
