import 'package:flutter/material.dart';

class ConfiguracionTab extends StatefulWidget {
  const ConfiguracionTab({super.key});

  @override
  State<ConfiguracionTab> createState() => _EstadoConfiguracionTab();
}

class _EstadoConfiguracionTab extends State<ConfiguracionTab> {
  // Estado "real" (guardado)
  final Map<String, bool> _ajustesActuales = {
    'Notificaciones': true,
    'Modo Oscuro': false,
    'Recordatorios': true,
    'Sonido': true,
    'Vibración': false,
    'Ubicación': false,
  };

  // Estado temporal (lo que el usuario ve mientras edita)
  late Map<String, bool> _ajustesTemporales;

  @override
  void initState() {
    super.initState();
    // Inicializamos el estado temporal como una copia del actual
    _ajustesTemporales = Map.from(_ajustesActuales);
  }

  void _guardarAjustes() {
    setState(() {
      // Al guardar, el estado temporal pasa a ser el estado real
      _ajustesActuales.addAll(_ajustesTemporales);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuración guardada correctamente'),
        backgroundColor: Colors.purple,
      ),
    );
  }

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
            'CONFIGURACIÓN',
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
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: ListView(
                children: _ajustesTemporales.keys.map((String clave) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CheckboxListTile(
                      title: Text(
                        clave,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: estiloSombraTexto,
                        ),
                      ),
                      value: _ajustesTemporales[clave],
                      activeColor: Colors.white,
                      checkColor: Colors.black,
                      side: const BorderSide(color: Colors.black, width: 2),
                      onChanged: (bool? valor) {
                        setState(() {
                          // Modificamos solo el estado temporal
                          _ajustesTemporales[clave] = valor ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Botón Guardar
          Container(
            width: double.infinity,
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
              onPressed: _guardarAjustes,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                side: const BorderSide(color: Colors.black, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                'GUARDAR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: estiloSombraTexto,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
