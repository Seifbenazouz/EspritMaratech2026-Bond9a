class LoginRequest {
  final String nom;
  final String password;

  LoginRequest({
    required this.nom,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'nom': nom,
        'password': password,
      };
}
