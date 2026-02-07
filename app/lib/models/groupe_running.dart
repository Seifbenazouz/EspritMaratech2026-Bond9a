import 'user.dart';

class GroupeRunning {
  final int id;
  final String nom;
  final String? niveau;
  final String? description;
  final User? responsable;
  final List<User> membres;

  GroupeRunning({
    required this.id,
    required this.nom,
    this.niveau,
    this.description,
    this.responsable,
    List<User>? membres,
  }) : membres = membres ?? const [];

  factory GroupeRunning.fromJson(Map<String, dynamic> json) {
    List<User> membresList = const [];
    if (json['membres'] != null && json['membres'] is List) {
      membresList = (json['membres'] as List)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return GroupeRunning(
      id: json['id'] as int,
      nom: json['nom'] as String,
      niveau: json['niveau'] as String?,
      description: json['description'] as String?,
      responsable: json['responsable'] != null
          ? User.fromJson(json['responsable'] as Map<String, dynamic>)
          : null,
      membres: membresList,
    );
  }
}
