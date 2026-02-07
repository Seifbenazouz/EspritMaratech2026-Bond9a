import 'evenement.dart';

class Historique {
  final int id;
  final DateTime? date;
  final Evenement? evenement;

  Historique({
    required this.id,
    this.date,
    this.evenement,
  });

  factory Historique.fromJson(Map<String, dynamic> json) {
    return Historique(
      id: json['id'] as int,
      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString())
          : null,
      evenement: json['evenement'] != null
          ? Evenement.fromJson(json['evenement'] as Map<String, dynamic>)
          : null,
    );
  }
}
