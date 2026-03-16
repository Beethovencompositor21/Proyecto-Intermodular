import 'package:flutter/material.dart';
import '../pestanias/home_tab.dart';
import '../pestanias/calendario_tab.dart';
import '../pestanias/dieta_tab.dart';
import '../pestanias/mensajeria_tab.dart';
import '../pestanias/configuracion_tab.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _EstadoPantallaPrincipal();
}

class _EstadoPantallaPrincipal extends State<PantallaPrincipal> {
  int _indiceSeleccionado = 0;
  
  // Estado global para compartir el progreso de los ejercicios
  final Map<String, bool> _ejerciciosCompletados = {};

  void _alPulsarItem(int indice) {
    setState(() {
      _indiceSeleccionado = indice;
    });
  }

  // Método para calcular el progreso semanal de ejercicios
  double _obtenerProgresoSemanal() {
    final Map<String, List<String>> rutinaSemanal = {
      'Lunes (Pecho/Tríceps)': ['Press de Banca', 'Aperturas con Mancuernas', 'Press Inclinado', 'Extensiones Tríceps Polea', 'Fondos en Paralelas'],
      'Martes (Espalda/Bíceps)': ['Dominadas', 'Remo con Barra', 'Jalón al Pecho', 'Curl de Bíceps Barra', 'Martillo con Mancuernas'],
      'Miércoles (Piernas)': ['Sentadillas', 'Prensa de Piernas', 'Extensiones de Cuádriceps', 'Curl Femoral Máquina', 'Elevación de Gemelos'],
      'Jueves (Hombros)': ['Press Militar', 'Elevaciones Laterales', 'Pájaro con Mancuernas', 'Frontales con Disco', 'Encogimientos Trapecio'],
      'Viernes (Full Body/Core)': ['Peso Muerto', 'Zancadas', 'Plancha Abdominal', 'Rueda Abdominal', 'Flexiones'],
    };

    int ejerciciosTotales = 0;
    int ejerciciosCompletadosCount = 0;

    rutinaSemanal.forEach((dia, ejercicios) {
      for (var ej in ejercicios) {
        ejerciciosTotales++;
        if (_ejerciciosCompletados['$dia-$ej'] == true) {
          ejerciciosCompletadosCount++;
        }
      }
    });

    if (ejerciciosTotales == 0) return 0.0;
    return ejerciciosCompletadosCount / ejerciciosTotales;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pestanias = [
      const HomeTab(),
      CalendarioTab(
        ejerciciosCompletados: _ejerciciosCompletados,
        alCambiarEjercicio: (clave, valor) {
          setState(() {
            _ejerciciosCompletados[clave] = valor;
          });
        },
      ),
      DietaTab(progresoEjercicio: _obtenerProgresoSemanal()),
      const MensajeriaTab(),
      const ConfiguracionTab(),
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
        child: SafeArea(
          child: Stack(
            children: [
              IndexedStack(
                index: _indiceSeleccionado,
                children: _pestanias,
              ),
              Positioned(
                top: 20,
                right: 30,
                child: Image.asset(
                  'assets/images/logotipo.png',
                  height: 70,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/barrainferior.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/boton_home.png', width: 30, height: 30),
              activeIcon: Image.asset('assets/images/boton_home_activo.png', width: 30, height: 30),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/boton_calendario.png', width: 30, height: 30),
              activeIcon: Image.asset('assets/images/boton_calendario_activo.png', width: 30, height: 30),
              label: 'Calendario',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/boton_dieta.png', width: 30, height: 30),
              activeIcon: Image.asset('assets/images/boton_dieta_activo.png', width: 30, height: 30),
              label: 'Dieta',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/boton_mensajeria.png', width: 30, height: 30),
              activeIcon: Image.asset('assets/images/boton_mensajeria_activo.png', width: 30, height: 30),
              label: 'Mensajería',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/boton_opciones.png', width: 30, height: 30),
              activeIcon: Image.asset('assets/images/boton_opciones_activo.png', width: 30, height: 30),
              label: 'Config',
            ),
          ],
          currentIndex: _indiceSeleccionado,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          onTap: _alPulsarItem,
        ),
      ),
    );
  }
}
