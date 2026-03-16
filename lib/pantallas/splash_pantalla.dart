import 'package:flutter/material.dart';
import 'pantalla_login.dart';

class PantallaSplash extends StatefulWidget {
  const PantallaSplash({super.key});

  @override
  State<PantallaSplash> createState() => _EstadoPantallaSplash();
}

class _EstadoPantallaSplash extends State<PantallaSplash> {
  double _opacidad = 0.0;

  @override
  void initState() {
    super.initState();
    // Iniciamos la animación de aparición del logo
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _opacidad = 1.0;
        });
      }
    });
    _navegarALogin();
  }

  void _navegarALogin() async {
    // Tiempo para que el logo aparezca y se mantenga un poco
    await Future.delayed(const Duration(milliseconds: 3000));
    
    // Desvanecemos el logo antes de la transición para mayor suavidad
    if (mounted) {
      setState(() {
        _opacidad = 0.0;
      });
    }

    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animacion, secundariaAnimacion) => const PantallaLogin(),
          transitionsBuilder: (context, animacion, secundariaAnimacion, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animacion,
                curve: Curves.easeInOutQuart,
              ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 1500), // Transición más lenta y suave
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: Center(
          child: AnimatedOpacity(
            opacity: _opacidad,
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeInOut,
            child: Image.asset(
              'assets/images/logotipo.png',
              width: 500, // Tamaño solicitado
            ),
          ),
        ),
      ),
    );
  }
}
