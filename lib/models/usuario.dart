class Usuario {
  final int? id;
  final String nombreUsuario;
  final String correo;
  final String contrasena;

  Usuario({
    this.id,
    required this.nombreUsuario,
    required this.correo,
    required this.contrasena,
  });

  Map<String, dynamic> aMapa() {
    return {
      'id': id,
      'username': nombreUsuario,
      'email': correo,
      'password': contrasena,
    };
  }

  factory Usuario.desdeMapa(Map<String, dynamic> mapa) {
    return Usuario(
      id: mapa['id'],
      nombreUsuario: mapa['username'],
      correo: mapa['email'],
      contrasena: mapa['password'],
    );
  }
}
