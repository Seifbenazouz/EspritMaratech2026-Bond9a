enum Role {
  ADMIN_PRINCIPAL,
  ADMIN_COACH,
  ADMIN_GROUPE,
  ADHERENT,
}

class LoginResponse {
  final String token;
  final String type;
  final String id;
  final String nom;
  final String? prenom;
  final String? email;
  final Role? role;

  LoginResponse({
    required this.token,
    this.type = 'Bearer',
    required this.id,
    required this.nom,
    this.prenom,
    this.email,
    this.role,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      type: json['type'] as String? ?? 'Bearer',
      id: json['id']?.toString() ?? '',
      nom: json['nom'] as String,
      prenom: json['prenom'] as String?,
      email: json['email'] as String?,
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
