// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/vistas/pantalla_invertir.dart';
import 'package:flutter_app/vistas/pantalla_simular.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('Aplicación tiene las opciones principales', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    //  Verificar que nuestro saldo comienza en 3500 €
    final titleFinder = find.text('3500,00 €');
    final simuladorFinder = find.text('Simular\nInversión');
    final inversionesFinder = find.text('Invertir');
    final prestamoFinder = find.text('Pedir\nPréstamo');

    // Verificar las distintas opciones de los menús
    expect(titleFinder, findsOneWidget);
    expect(inversionesFinder, findsWidgets);
    expect(simuladorFinder, findsWidgets);
    expect(prestamoFinder, findsWidgets);

  });
  testWidgets('Rellenar campos obligatorios - Pantalla Simular', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(pantalla_simular());

    await tester.tap(find.byType(RaisedButton));
    await tester.pump();

    expect(find.text('Campo obligatorio'), findsWidgets);
  });
  testWidgets('Pantalla Principal tiene opcion a reiniciar', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    await tester.tapAt(const Offset(942.0, 332.0));
    await tester.pump();

    expect(find.byType(InkWell, skipOffstage: true), findsWidgets);
  });
}
