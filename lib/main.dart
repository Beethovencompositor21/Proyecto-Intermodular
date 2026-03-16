import 'package:flutter/material.dart';
import 'pantallas/splash_pantalla.dart';

void main() {
  runApp(const AplicacionExtreFit());
}

class AplicacionExtreFit extends StatelessWidget {
  const AplicacionExtreFit({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExtreFit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.orange,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const PantallaSplash(),
    );
  }
}
