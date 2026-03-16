import 'package:flutter/material.dart';

class DietaTab extends StatefulWidget {
  final double progresoEjercicio;

  const DietaTab({
    super.key,
    required this.progresoEjercicio,
  });

  @override
  State<DietaTab> createState() => _EstadoDietaTab();
}

class _EstadoDietaTab extends State<DietaTab> {
  final Map<String, bool> _comidasCompletadas = {
    'Desayuno': false,
    'Comida': false,
    'Cena': false,
  };

  final Map<String, String> _detallesDieta = {
    'Desayuno': 'Tortilla de 3 claras y 1 huevo entero + 50g de avena.',
    'Comida': '200g de Pollo a la plancha + 100g de Arroz integral + Ensalada.',
    'Cena': '150g de Salmón al horno + Verduras al vapor (Brócoli/Espárragos).',
  };

  final TextEditingController _controladorPeso = TextEditingController();
  final TextEditingController _controladorAltura = TextEditingController();
  double? _imc;

  void _calcularIMC() {
    double? peso = double.tryParse(_controladorPeso.text);
    double? altura = double.tryParse(_controladorAltura.text);

    if (peso != null && altura != null && altura > 0) {
      double alturaEnMetros = altura / 100;
      setState(() {
        _imc = peso / (alturaEnMetros * alturaEnMetros);
      });
    }
  }

  Color _obtenerColorIMC(double imc) {
    if (imc < 18.5 || imc > 30) return Colors.red;
    if (imc >= 18.5 && imc < 25) return Colors.green;
    return Colors.orange;
  }

  void _mostrarDialogoIMC() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            const estiloSombraTexto = [
              Shadow(offset: Offset(-1.5, -1.5), color: Colors.black),
              Shadow(offset: Offset(1.5, -1.5), color: Colors.black),
              Shadow(offset: Offset(1.5, 1.5), color: Colors.black),
              Shadow(offset: Offset(-1.5, 1.5), color: Colors.black),
            ];

            return AlertDialog(
              backgroundColor: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Colors.green, width: 2),
              ),
              title: Text(
                'Calculadora de IMC',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, shadows: estiloSombraTexto),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _construirCampoTextoDialogo(_controladorPeso, 'Peso (kg)', estiloSombraTexto),
                    const SizedBox(height: 15),
                    _construirCampoTextoDialogo(_controladorAltura, 'Altura (cm)', estiloSombraTexto),
                    if (_imc != null) ...[
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _construirProgresoCircularIMC('Tu IMC', _imc!, _obtenerColorIMC(_imc!), estiloSombraTexto),
                          _construirProgresoCircularIMC('Objetivo', 22.0, Colors.blueAccent, estiloSombraTexto),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        _imc! < 18.5 ? 'Bajo peso' : (_imc! < 25 ? 'Peso ideal' : (_imc! < 30 ? 'Sobrepeso' : 'Obesidad')),
                        style: TextStyle(color: _obtenerColorIMC(_imc!), fontWeight: FontWeight.bold, shadows: estiloSombraTexto, fontSize: 18),
                      ),
                    ],
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _calcularIMC();
                              setDialogState(() {}); 
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              side: const BorderSide(color: Colors.black, width: 2),
                            ),
                            child: const Text('Enviar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, shadows: estiloSombraTexto)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                _imc = null;
                                _controladorPeso.clear();
                                _controladorAltura.clear();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              side: const BorderSide(color: Colors.black, width: 2),
                            ),
                            child: const Text('Volver', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, shadows: estiloSombraTexto)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _construirProgresoCircularIMC(String etiqueta, double valor, Color color, List<Shadow> sombras) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: valor / 40,
                strokeWidth: 8,
                backgroundColor: Colors.white10,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              Center(
                child: Text(
                  valor.toStringAsFixed(1),
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, shadows: sombras),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(etiqueta, style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, shadows: sombras)),
      ],
    );
  }

  Widget _construirCampoTextoDialogo(TextEditingController controlador, String etiqueta, List<Shadow> sombras) {
    return TextField(
      controller: controlador,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: etiqueta,
        labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, shadows: sombras),
        filled: true,
        fillColor: Colors.black45,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.green)),
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

    int comidasHechas = _comidasCompletadas.values.where((hecho) => hecho).length;
    double progresoComida = comidasHechas / _comidasCompletadas.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 20),
      child: Column(
        children: [
          Text(
            'MI DIETA',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, shadows: estiloSombraTexto),
          ),
          const SizedBox(height: 20),
          
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.orange, width: 2),
            ),
            child: Column(
              children: _comidasCompletadas.keys.map((comida) {
                bool estaHecho = _comidasCompletadas[comida]!;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: estaHecho ? Colors.green.withOpacity(0.2) : Colors.white10,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(comida, style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, shadows: estiloSombraTexto)),
                    subtitle: Text(_detallesDieta[comida]!, style: const TextStyle(color: Colors.white70)),
                    trailing: Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        value: estaHecho,
                        activeColor: Colors.white,
                        checkColor: Colors.black,
                        side: const BorderSide(color: Colors.black, width: 2),
                        fillColor: WidgetStateProperty.all(Colors.white),
                        onChanged: (bool? valor) {
                          setState(() {
                            _comidasCompletadas[comida] = valor ?? false;
                          });
                        },
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blueAccent, width: 2),
            ),
            child: Column(
              children: [
                Text('RESUMEN DIARIO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, shadows: estiloSombraTexto)),
                const Divider(color: Colors.blueAccent),
                const SizedBox(height: 10),
                _construirFilaInfo('Calorías Totales:', '2400 kcal', estiloSombraTexto),
                _construirFilaInfo('Calorías Ejercicio:', '-450 kcal', estiloSombraTexto),
                const SizedBox(height: 10),
                Text('Objetivo Neto: 1950 kcal', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 20, shadows: estiloSombraTexto)),
              ],
            ),
          ),

          const SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _construirProgresoCircular('Dieta', progresoComida, Colors.orange, estiloSombraTexto),
              _construirProgresoCircular('Ejercicio', widget.progresoEjercicio, Colors.greenAccent, estiloSombraTexto),
            ],
          ),

          const SizedBox(height: 40),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.5), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 3)),
              ],
            ),
            child: ElevatedButton(
              onPressed: _mostrarDialogoIMC,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
                side: const BorderSide(color: Colors.black, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text('CALCULAR IMC', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, shadows: estiloSombraTexto)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _construirFilaInfo(String etiqueta, String valor, List<Shadow> sombras) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(etiqueta, style: TextStyle(color: Colors.white, shadows: sombras)),
          Text(valor, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, shadows: sombras)),
        ],
      ),
    );
  }

  Widget _construirProgresoCircular(String etiqueta, double porcentaje, Color color, List<Shadow> sombras) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 3),
            color: Colors.black26,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: porcentaje,
                strokeWidth: 8,
                backgroundColor: Colors.white10,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              Center(
                child: Text(
                  '${(porcentaje * 100).toInt()}%',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, shadows: sombras),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(etiqueta, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, shadows: sombras)),
      ],
    );
  }
}
