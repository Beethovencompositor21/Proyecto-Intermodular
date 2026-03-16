import 'package:flutter/material.dart';
import '../pestanias/registro_pantalla.dart';
import 'pantalla_home.dart';
import 'recuperacion_pantalla.dart';
import '../services/mysql_helper.dart';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _EstadoPantallaLogin();
}

class _EstadoPantallaLogin extends State<PantallaLogin> {
  final TextEditingController _controladorCorreo = TextEditingController();
  final TextEditingController _controladorContrasena = TextEditingController();
  bool _estaCargando = false;

  void _iniciarSesion() async {
    String correo = _controladorCorreo.text;
    String contrasena = _controladorContrasena.text;

    if (correo.isEmpty || contrasena.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, rellena todos los campos')),
      );
      return;
    }

    setState(() {
      _estaCargando = true;
    });

    try {
      bool esValido = await MySqlHelper.validarUsuario(correo, contrasena);

      if (esValido) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PantallaPrincipal()),
          );
        }
      } else {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error de acceso'),
              content: const Text('Los datos introducidos no coinciden con nuestros registros.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Aceptar'),
                ),
              ],
            ),
          );
          _controladorCorreo.clear();
          _controladorContrasena.clear();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al conectar con MySQL: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _estaCargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const estiloSombraTexto = [
      Shadow(offset: Offset(-1.5, -1.5), color: Colors.black),
      Shadow(offset: Offset(1.5, -1.5), color: Colors.black),
      Shadow(offset: Offset(1.5, 1.5), color: Colors.black),
      Shadow(offset: Offset(-1.5, 1.5), color: Colors.black),
    ];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondoAPP.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Image.asset('assets/images/logotipo.png', height: 270),
              const SizedBox(height: 30),
              _construirCampoTexto(_controladorCorreo, 'Email', false, estiloSombraTexto, Colors.orange),
              const SizedBox(height: 15),
              _construirCampoTexto(_controladorContrasena, 'Contraseña', true, estiloSombraTexto, Colors.orange),
              const SizedBox(height: 35),
              _estaCargando
                  ? const CircularProgressIndicator(color: Colors.orange)
                  : Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _iniciarSesion,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                side: const BorderSide(color: Colors.black, width: 2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(vertical: 15),
                              ),
                              child: Text(
                                'Entrar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  shadows: estiloSombraTexto,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const PantallaRegistro()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                side: const BorderSide(color: Colors.black, width: 2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(vertical: 15),
                              ),
                              child: Text(
                                'Registrarse',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  shadows: estiloSombraTexto,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PantallaRecuperacion()),
                  );
                },
                child: Text(
                  '¿Has olvidado tu contraseña?',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    shadows: estiloSombraTexto,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirCampoTexto(TextEditingController controlador, String etiqueta, bool oculto, List<Shadow> sombras, Color colorFoco) {
    return TextField(
      controller: controlador,
      obscureText: oculto,
      style: TextStyle(
        color: Colors.white,
        shadows: sombras,
      ),
      decoration: InputDecoration(
        labelText: etiqueta,
        labelStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          shadows: sombras,
        ),
        floatingLabelStyle: TextStyle(
          color: Colors.white,
          shadows: sombras,
        ),
        filled: true,
        fillColor: Colors.black45,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorFoco, width: 2),
        ),
      ),
    );
  }
}
