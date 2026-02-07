/// Configuration de l'API backend Spring (port 8081)
///
/// - Android Emulator : 'http://10.0.2.2:8081'
/// - Windows / Web / iOS : 'http://localhost:8081'
/// - Téléphone et PC sur le même Wi‑Fi : 'http://IP_DU_PC:8081' (ex. http://10.93.108.156:8081)
/// - Partage de connexion (téléphone en hotspot, PC connecté au téléphone) :
///   Sur le PC faire ipconfig et noter l'IPv4 de la carte Wi‑Fi (souvent 192.168.43.xxx).
///   Mettre : 'http://192.168.43.XXX:8081'
class ApiConfig {
  static const String baseUrl = 'http://10.93.108.83:8081';
}
