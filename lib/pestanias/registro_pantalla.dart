import 'package:flutter/material.dart';
import '../services/mysql_helper.dart';

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _EstadoPantallaRegistro();
}

class _EstadoPantallaRegistro extends State<PantallaRegistro> {
  final TextEditingController _controladorUsuario = TextEditingController();
  final TextEditingController _controladorCorreo = TextEditingController();
  final TextEditingController _controladorContrasena = TextEditingController();
  final TextEditingController _controladorConfirmarContrasena = TextEditingController();
  bool _estaCargando = false;
  bool _aceptoTerminos = false;

  void _registrar() async {
    String nombreUsuario = _controladorUsuario.text.trim();
    String correo = _controladorCorreo.text.trim();
    String contrasena = _controladorContrasena.text;
    String confirmarContrasena = _controladorConfirmarContrasena.text;

    // Validación de campos vacíos
    if (nombreUsuario.isEmpty || correo.isEmpty || contrasena.isEmpty || confirmarContrasena.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, rellena todos los campos')),
      );
      return;
    }

    // Validación de mínimo 3 caracteres para el usuario
    if (nombreUsuario.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre de usuario debe tener al menos 3 caracteres')),
      );
      return;
    }

    // Validación de formato de correo
    final bool correoValido = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(correo);
    if (!correoValido) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, introduce un correo electrónico válido')),
      );
      return;
    }

    // Validación de mínimo 8 caracteres para la contraseña
    if (contrasena.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La contraseña debe tener al menos 8 caracteres')),
      );
      return;
    }

    // Validación de coincidencia de contraseñas
    if (contrasena != confirmarContrasena) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    // Validación de términos y condiciones
    if (!_aceptoTerminos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes aceptar los términos y condiciones')),
      );
      return;
    }

    setState(() {
      _estaCargando = true;
    });

    try {
      // Verificar si el usuario ya existe
      bool usuarioRepetido = await MySqlHelper.existeUsuario(nombreUsuario);
      if (usuarioRepetido) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('El nombre de usuario ya está en uso')),
          );
        }
        return;
      }

      // Verificar si el correo ya existe
      bool emailRepetido = await MySqlHelper.existeEmail(correo);
      if (emailRepetido) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('El correo electrónico ya está registrado')),
          );
        }
        return;
      }

      // Proceder con el registro si todo es correcto
      await MySqlHelper.registrarUsuario(nombreUsuario, correo, contrasena);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario registrado con éxito')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al conectar con el servidor')),
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
              const SizedBox(height: 60),
              Image.asset('assets/images/logotipo.png', height: 200),
              const SizedBox(height: 10),
              _construirCampoTexto(_controladorUsuario, 'Nombre de usuario', false, estiloSombraTexto, Colors.orange),
              const SizedBox(height: 15),
              _construirCampoTexto(_controladorCorreo, 'Email', false, estiloSombraTexto, Colors.orange),
              const SizedBox(height: 15),
              _construirCampoTexto(_controladorContrasena, 'Contraseña', true, estiloSombraTexto, Colors.orange),
              const SizedBox(height: 15),
              _construirCampoTexto(_controladorConfirmarContrasena, 'Confirmar contraseña', true, estiloSombraTexto, Colors.orange),
              const SizedBox(height: 5),
              Row(
                children: [
                  Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.white),
                    child: Checkbox(
                      value: _aceptoTerminos,
                      activeColor: Colors.orange,
                      checkColor: Colors.white,
                      onChanged: (bool? valor) {
                        setState(() {
                          _aceptoTerminos = valor ?? false;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Acepto los términos y condiciones',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: estiloSombraTexto,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _estaCargando
                  ? const CircularProgressIndicator(color: Colors.orange)
                  : SizedBox(
                      width: double.infinity,
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
                          onPressed: _registrar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            side: const BorderSide(color: Colors.black, width: 2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text(
                            'Registrarme',
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
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  '¿Ya tienes cuenta? Inicia sesión',
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
