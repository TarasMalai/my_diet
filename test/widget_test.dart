// ============================================================================
// НАЗВА ФАЙЛУ: widget_test.dart
// ПРИЗНАЧЕННЯ: Тест перевіряє, чи правильно запускається додаток "Моя дієта"
//              і чи відображається текст на заставці.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_diet/main.dart'; // Імпортуємо наш головний файл проєкту

void main() {
  testWidgets('Splash screen smoke test', (WidgetTester tester) async {
    // 1. Запускаємо наш додаток
    await tester.pumpWidget(const MyDietApp());

    // 2. Перевіряємо, чи є на екрані текст нашої заставки
    expect(find.text('Моя дієта'), findsOneWidget);

    // 3. Перевіряємо, чи присутній індикатор завантаження (крутілка)
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
