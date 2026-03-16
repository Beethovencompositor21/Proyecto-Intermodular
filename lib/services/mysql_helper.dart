import 'package:mysql_client/mysql_client.dart';

class MySqlHelper {
  static const String _servidor = '127.0.0.1';
  static const int _puerto = 3306;
  static const String _usuario = 'fitapp';
  static const String _contrasena = 'AppFit123';
  static const String _baseDeDatos = 'extrefit';

  static Future<MySQLConnection> obtenerConexion() async {
    final conexion = await MySQLConnection.createConnection(
      host: _servidor,
      port: _puerto,
      userName: _usuario,
      password: _contrasena,
      databaseName: _baseDeDatos,
    );

    await conexion.connect();
    return conexion;
  }

  static Future<bool> existeUsuario(String nombreUsuario) async {
    final conexion = await obtenerConexion();
    try {
      final resultado = await conexion.execute(
        "SELECT * FROM users WHERE username = :username",
        {"username": nombreUsuario},
      );
      return resultado.rows.isNotEmpty;
    } finally {
      await conexion.close();
    }
  }

  static Future<bool> existeEmail(String correo) async {
    final conexion = await obtenerConexion();
    try {
      final resultado = await conexion.execute(
        "SELECT * FROM users WHERE email = :email",
        {"email": correo},
      );
      return resultado.rows.isNotEmpty;
    } finally {
      await conexion.close();
    }
  }

  static Future<void> registrarUsuario(String nombreUsuario, String correo, String contrasena) async {
    final conexion = await obtenerConexion();
    try {
      await conexion.execute(
        "INSERT INTO users (username, email, password) VALUES (:username, :email, :password)",
        {
          "username": nombreUsuario,
          "email": correo,
          "password": contrasena,
        },
      );
    } catch (e) {
      print('Error al registrar usuario en MySQL: $e');
      rethrow;
    } finally {
      await conexion.close();
    }
  }

  static Future<bool> validarUsuario(String correo, String contrasena) async {
    final conexion = await obtenerConexion();
    try {
      final resultado = await conexion.execute(
        "SELECT * FROM users WHERE email = :email AND password = :password",
        {
          "email": correo,
          "password": contrasena,
        },
      );
      return resultado.rows.isNotEmpty;
    } catch (e) {
      print('Error al validar usuario en MySQL: $e');
      rethrow;
    } finally {
      await conexion.close();
    }
  }
}
