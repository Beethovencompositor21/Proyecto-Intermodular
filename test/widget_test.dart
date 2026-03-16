import 'package:flutter_test/flutter_test.dart';
import 'package:proyectoextrefit/main.dart';

void main() {
  testWidgets('Prueba de carga de LoginScreen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AplicacionExtreFit());

    // Verificamos que aparezca el texto de bienvenida
    expect(find.text('Bienvenido a ExtreFit'), findsOneWidget);
    
    // Verificamos que el botón de iniciar sesión esté presente
    expect(find.text('Iniciar Sesión'), findsOneWidget);

    // Verificamos que no estemos en la pantalla de Home todavía
    expect(find.text('Has iniciado sesión con éxito'), findsNothing);
  });
}
