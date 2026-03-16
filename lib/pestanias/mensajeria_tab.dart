import 'package:flutter/material.dart';

class MensajeriaTab extends StatefulWidget {
  const MensajeriaTab({super.key});

  @override
  State<MensajeriaTab> createState() => _EstadoMensajeriaTab();
}

class _EstadoMensajeriaTab extends State<MensajeriaTab> {
  final PageController _controladorPagina = PageController();
  int _paginaActual = 0;

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
            'MIS MENSAJES',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: estiloSombraTexto,
            ),
          ),
          const SizedBox(height: 20),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _controladorPagina.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                child: Image.asset(
                  'assets/images/boton_mensajes_no_leidos.png',
                  height: 60,
                  color: _paginaActual == 0 ? null : Colors.grey.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () => _controladorPagina.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                child: Image.asset(
                  'assets/images/boton_mensajes.png',
                  height: 60,
                  color: _paginaActual == 1 ? null : Colors.grey.withOpacity(0.5),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),

          Expanded(
            child: PageView(
              controller: _controladorPagina,
              onPageChanged: (indice) {
                setState(() {
                  _paginaActual = indice;
                });
              },
              children: [
                _construirListaMensajes('Mensajes No Leídos', [
                  'Entrenador: ¡Recuerda beber agua!',
                  'Sistema: Tu dieta ha sido actualizada',
                ], Colors.orange, estiloSombraTexto),
                _construirListaMensajes('Mensajes Leídos', [
                  'Entrenador: Buen entrenamiento ayer',
                  'Sistema: Bienvenido a ExtreFit',
                ], Colors.blueAccent, estiloSombraTexto),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirListaMensajes(String titulo, List<String> mensajes, Color colorBorde, List<Shadow> sombras) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorBorde, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              shadows: sombras,
            ),
          ),
          const Divider(color: Colors.white24),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: mensajes.length,
              itemBuilder: (context, indice) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Text(
                    mensajes[indice],
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      shadows: sombras,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
