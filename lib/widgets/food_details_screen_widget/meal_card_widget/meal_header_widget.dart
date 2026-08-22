// ============================================================================
// НАЗВА ФАЙЛУ: meal_header_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Шапка прийому їжі з авто-підрахунком нутрієнтів
// ============================================================================

import 'package:flutter/material.dart';
import '../../../../models/meal_model.dart';

/// [ВУЗОЛ 1]: ШАПКА КАРТКИ ПРИЙОМУ ЇЖІ
class MealHeaderWidget extends StatelessWidget {
  final MealModel meal;

  const MealHeaderWidget({super.key, required this.meal});

  // [ВУЗОЛ 1.1]: Допоміжний геттер для автоматичного підбору емодзі
  String get _mealEmoji {
    final titleUpper = meal.title.toUpperCase();
    if (titleUpper.contains('СНІДАНОК')) return '🌅';
    if (titleUpper.contains('ОБІД')) return '☀️';
    if (titleUpper.contains('ВЕЧЕРЯ')) return '🌙';
    return '🍎'; // Для перекусів
  }

  @override
  Widget build(BuildContext context) {
    // Підраховуємо сумарний ФА та Калорії за допомогою геттерів з MealModel
    final totalPhe = meal.totalPhe.toStringAsFixed(0);
    final totalKcal = meal.totalCalories.toStringAsFixed(0);

    return Row(
      children: [
        // Емодзі прийому їжі
        Text(_mealEmoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 12.0),

        // Назва прийому (СНІДАНОК, ОБІД тощо)
        Expanded(
          child: Text(
            meal.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 15,
              letterSpacing: 0.5,
            ),
          ),
        ),

        // Компактний числовий підсумок нутрієнтів
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Text(
            '$totalPhe ФА | $totalKcal ккал',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade800, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
