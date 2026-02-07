import 'groupe_running.dart';

class ProgrammeEntrainement {
  final int id;
  final String titre;
  final String? description;
  final DateTime? dateDebut;
  final DateTime? dateFin;
  final GroupeRunning? groupe;

  ProgrammeEntrainement({
    required this.id,
    required this.titre,
    this.description,
    this.dateDebut,
    this.dateFin,
    this.groupe,
  });

  factory ProgrammeEntrainement.fromJson(Map<String, dynamic> json) {
    return ProgrammeEntrainement(
      id: json['id'] as int,
      titre: json['titre'] as String,
      description: json['description'] as String?,
      dateDebut: json['dateDebut'] != null
          ? DateTime.tryParse(json['dateDebut'].toString())
          : null,
      dateFin: json['dateFin'] != null
          ? DateTime.tryParse(json['dateFin'].toString())
          : null,
      groupe: json['groupe'] != null
          ? GroupeRunning.fromJson(json['groupe'] as Map<String, dynamic>)
          : null,
    );
  }
}
