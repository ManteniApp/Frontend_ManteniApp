// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:frontend_manteniapp/main.dart';

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
