import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


class ManteniApp extends StatelessWidget {
  const ManteniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ManteniApp',
      home: Scaffold(
        appBar: AppBar(title: const Text('ManteniApp')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Registra Tu Moto'),
              SizedBox(height: 12),
              Text('Marca'),
              Text('Modelo'),
              Text('Año'),
              Text('Cilindraje'),
              Text('Kilometraje'),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('Motorcycle registration page loads correctly', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ManteniApp());

    // Verify that our motorcycle registration page loads
    expect(find.text('Registra Tu Moto'), findsOneWidget);
    expect(find.text('ManteniApp'), findsOneWidget);

    // Verify that form fields are present
    expect(find.text('Marca'), findsOneWidget);
    expect(find.text('Modelo'), findsOneWidget);
    expect(find.text('Año'), findsOneWidget);
    expect(find.text('Cilindraje'), findsOneWidget);
    expect(find.text('Kilometraje'), findsOneWidget);
  });
}
