// ============================================================================
// НАЗВА ФАЙЛУ: nutrient_item_data.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Модель даних окремого нутрієнта (капсулює інформацію,
//              необхідну для рендерингу однієї картки показника).
// ============================================================================

import 'package:flutter/material.dart';

// ----------------------------------------------------------------------------
// ГОЛОВНИЙ КЛАС МОДЕЛІ (NutrientItemData)
// ----------------------------------------------------------------------------
/// Допоміжний клас-контейнер, що містить значення, ліміти, іконки та кольори
/// для кожної окремої метрики харчування.
class NutrientItemData {
  final String id; // Унікальний ідентифікатор нутрієнта ('fa', 'protein', тощо)
  final String label; // Текстова назва для виводу користувачу
  final String valueText; // Відформатований рядок значень ('350 / 300 мг')
  final IconData icon; // Іконка Material Icons для візуалізації
  final Color color; // Базовий колір оформлення картки та прогресу
  final double currentVal; // Поточне введене користувачем значення
  final double maxVal; // Максимально допустиме значення (ліміт / норма)
  final bool isExceeded; // Прапорець: чи перевищує поточне значення ліміт

  const NutrientItemData({
    required this.id,
    required this.label,
    required this.valueText,
    required this.icon,
    required this.color,
    required this.currentVal,
    required this.maxVal,
    this.isExceeded = false,
  });
}
