import 'login_response.dart';

/// Utilisateur (résumé ou complet) pour listes, groupes, formulaire.
class User {
  final String id;
  final String nom;
  final String? prenom;
  final String? email;
  final int? phone;
  final int? cin;
  final Role? role;

  User({
    required this.id,
    required this.nom,
    this.prenom,
    this.email,
    this.phone,
    this.cin,
    this.role,
  });

  String get displayName => [prenom, nom].where((e) => e != null && e.isNotEmpty).join(' ').trim().isEmpty ? nom : [prenom, nom].where((e) => e != null && e.isNotEmpty).join(' ').trim();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      nom: json['nom'] as String? ?? '',
      prenom: json['prenom'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as int?,
      cin: json['cin'] as int?,
      role: json['role'] != null ? _roleFromString(json['role']) : null,
    );
  }

  static Role? _roleFromString(dynamic role) {
    final s = role.toString().toUpperCase();
    for (final r in Role.values) {
      if (r.name == s) return r;
    }
    return null;
  }
}
