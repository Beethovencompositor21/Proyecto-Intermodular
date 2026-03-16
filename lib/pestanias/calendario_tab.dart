import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CalendarioTab extends StatefulWidget {
  final Map<String, bool> ejerciciosCompletados;
  final Function(String, bool) alCambiarEjercicio;

  const CalendarioTab({
    super.key,
    required this.ejerciciosCompletados,
    required this.alCambiarEjercicio,
  });

  @override
  State<CalendarioTab> createState() => _EstadoCalendarioTab();
}

class _EstadoCalendarioTab extends State<CalendarioTab> {
  final Map<String, List<Map<String, String>>> rutina = {
    'Lunes (Pecho/Tríceps)': [
      {'nombre': 'Press de Banca', 'url': 'https://www.youtube.com/watch?v=077idmXjWTo'},
      {'nombre': 'Aperturas con Mancuernas', 'url': 'https://www.youtube.com/watch?v=680XhOshh_U'},
      {'nombre': 'Press Inclinado', 'url': 'https://www.youtube.com/watch?v=XAtF05uV1p4'},
      {'nombre': 'Extensiones Tríceps Polea', 'url': 'https://www.youtube.com/watch?v=vB5OHsJ3EME'},
      {'nombre': 'Fondos en Paralelas', 'url': 'https://www.youtube.com/watch?v=sM6XUdt1rmU'},
    ],
    'Martes (Espalda/Bíceps)': [
      {'nombre': 'Dominadas', 'url': 'https://www.youtube.com/watch?v=eGo4IYlbE5g'},
      {'nombre': 'Remo con Barra', 'url': 'https://www.youtube.com/watch?v=680XhOshh_U'},
      {'nombre': 'Jalón al Pecho', 'url': 'https://www.youtube.com/watch?v=680XhOshh_U'},
      {'nombre': 'Curl de Bíceps Barra', 'url': 'https://www.youtube.com/watch?v=680XhOshh_U'},
      {'nombre': 'Martillo con Mancuernas', 'url': 'https://www.youtube.com/watch?v=680XhOshh_U'},
    ],
    'Miércoles (Piernas)': [
      {'nombre': 'Sentadillas', 'url': 'https://www.youtube.com/watch?v=680XhOshh_U'},
      {'nombre': 'Prensa de Piernas', 'url': 'https://www.youtube.com/watch?v=680XhOshh_U'},
      {'nombre': 'Extensiones de Cuádriceps', 'url': 'https://www.youtube.com/watch?v=680XhOshh_U'},
      {'nombre': 'Curl Femoral Máquina', 'url': 'https://www.youtube.com/watch?v=680XhOshh_U'},
      {'nombre': 'Elevación de Gemelos', 'url': 'https://www.youtube.com/watch?v=680XhOshh_U'},
    ],
    'Jueves (Hombros)': [
      {'nombre': 'Press Militar', 'url': 'https://www.youtube.com/watch?v=680XhOshh_U'},
      {'nombre': 'Elevaciones Laterales', 'url': 'https://www.youtube.com/watch?v=680XhOshh_U'},
      {'nombre': 'Pájaro con Mancuernas', 'url': 'https://www.youtube.com/watch?v=680XhOshh_U'},
      {'nombre': 'Frontales con Disco', 'url': 'https://www.youtube.com/watch?v=680XhOshh_U'},
      {'nombre': 'Encogimientos Trapecio', 'url': 'https://www.youtube.com/watch?v=680XhOshh_U'},
    ],
    'Viernes (Full Body/Core)': [
      {'nombre': 'Peso Muerto', 'url': 'https://www.youtube.com/watch?v=680XhOshh_U'},
      {'nombre': 'Zancadas', 'url': 'https://www.youtube.com/watch?v=680XhOshh_U'},
      {'nombre': 'Plancha Abdominal', 'url': 'https://www.youtube.com/watch?v=680XhOshh_U'},
      {'nombre': 'Rueda Abdominal', 'url': 'https://www.youtube.com/watch?v=680XhOshh_U'},
      {'nombre': 'Flexiones', 'url': 'https://www.youtube.com/watch?v=680XhOshh_U'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    const estiloSombraTexto = [
      Shadow(offset: Offset(-1.5, -1.5), color: Colors.black),
      Shadow(offset: Offset(1.5, -1.5), color: Colors.black),
      Shadow(offset: Offset(1.5, 1.5), color: Colors.black),
      Shadow(offset: Offset(-1.5, 1.5), color: Colors.black),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 20),
      child: Column(
        children: [
          Text(
            'MI CALENDARIO',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: estiloSombraTexto,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: ListView.builder(
                itemCount: rutina.length,
                itemBuilder: (context, indice) {
                  String dia = rutina.keys.elementAt(indice);
                  List<Map<String, String>> ejercicios = rutina[dia]!;
                  
                  int cantidadCompletados = ejercicios.where((ej) => widget.ejerciciosCompletados['$dia-${ej['nombre']}'] == true).length;
                  bool metaLograda = cantidadCompletados == ejercicios.length;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              dia,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: metaLograda ? Colors.greenAccent : Colors.orange,
                                shadows: estiloSombraTexto,
                              ),
                            ),
                            Text(
                              '$cantidadCompletados/${ejercicios.length}',
                              style: TextStyle(
                                color: metaLograda ? Colors.greenAccent : Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: estiloSombraTexto,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...ejercicios.map((ej) {
                        String clave = '$dia-${ej['nombre']}';
                        bool estaHecho = widget.ejerciciosCompletados[clave] ?? false;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: estaHecho ? Colors.green.withOpacity(0.2) : Colors.white10,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              ej['nombre']!,
                              style: TextStyle(
                                color: estaHecho ? Colors.greenAccent : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                shadows: estiloSombraTexto,
                                decoration: estaHecho ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.play_circle_fill, color: Colors.orange, size: 30),
                                  onPressed: () async {
                                    final Uri url = Uri.parse(ej['url']!);
                                    if (!await launchUrl(url)) {
                                      throw Exception('No se pudo abrir $url');
                                    }
                                  },
                                ),
                                Transform.scale(
                                  scale: 1.2,
                                  child: Checkbox(
                                    value: estaHecho,
                                    activeColor: Colors.white,
                                    checkColor: Colors.black,
                                    side: const BorderSide(color: Colors.black, width: 2),
                                    fillColor: WidgetStateProperty.all(Colors.white),
                                    onChanged: (bool? valor) {
                                      widget.alCambiarEjercicio(clave, valor ?? false);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      const Divider(color: Colors.orange, thickness: 1),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
