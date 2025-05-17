import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:proyecto_dam_2025/main.dart';

void main() {
  testWidgets('La app muestra la barra de navegación y título de inicio', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Bienvenido'), findsOneWidget);

    expect(find.byIcon(Icons.home), findsOneWidget);

    expect(find.byIcon(Icons.list), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });
}
