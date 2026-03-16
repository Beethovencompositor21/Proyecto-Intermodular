import 'dart:convert';
// import 'package:http/http.dart' as http; // Requiere la dependencia http en pubspec.yaml

class ApiService {
  static const String baseUrl = "https://tu-api-extrefit.com/api"; // URL de ejemplo

  // Simulación de registro en API
  Future<bool> registerUser(String username, String email, String password) async {
    try {
      // En una implementación real:
      // final response = await http.post(
      //   Uri.parse('$baseUrl/register'),
      //   body: jsonEncode({'username': username, 'email': email, 'password': password}),
      //   headers: {'Content-Type': 'application/json'},
      // );
      // return response.statusCode == 201;

      await Future.delayed(const Duration(seconds: 1)); // Simular latencia
      return true; // Éxito simulado
    } catch (e) {
      return false;
    }
  }

  // Simulación de login en API
  Future<String?> loginUser(String email, String password) async {
    try {
      // En una implementación real devolvería un token JWT
      await Future.delayed(const Duration(seconds: 1));
      if (email == "test@extrefit.com" && password == "123456") {
        return "token_de_acceso_simulado_12345";
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
