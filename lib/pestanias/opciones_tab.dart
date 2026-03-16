import 'package:flutter/material.dart';

class OptionsTab extends StatelessWidget {
  const OptionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    const textBorderStyle = [
      Shadow(offset: Offset(-1.5, -1.5), color: Colors.black),
      Shadow(offset: Offset(1.5, -1.5), color: Colors.black),
      Shadow(offset: Offset(1.5, 1.5), color: Colors.black),
      Shadow(offset: Offset(-1.5, 1.5), color: Colors.black),
    ];

    return Center(
      child: Text(
        'Opciones y Ajustes',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: textBorderStyle,
        ),
      ),
    );
  }
}
