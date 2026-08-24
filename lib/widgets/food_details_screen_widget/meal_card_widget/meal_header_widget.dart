// ============================================================================
// НАЗВА ФАЙЛУ: meal_header_widget.dart
// ПРИЗНАЧЕННЯ: Шапка картки з іконкою перетягування зліва
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/models/meal_model.dart';
import 'package:my_diet/services/date_service.dart';
import 'package:my_diet/services/mock_diet_repository.dart';

class MealHeaderWidget extends StatelessWidget {
  final MealModel meal;
  final int index; // Індекс елемента для ReorderableDragStartListener

  const MealHeaderWidget({super.key, required this.meal, required this.index});

  String get _mealEmoji {
    final titleUpper = meal.title.toUpperCase();
    if (titleUpper.contains('СНІДАНОК')) return '🌅';
    if (titleUpper.contains('ОБІД')) return '☀️';
    if (titleUpper.contains('ВЕЧЕРЯ')) return '🌙';
    return '🍎';
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Видалити "${meal.title}"?'),
        content: const Text('Цей прийом їжі та всі додані до нього продукты будуть видалені.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Скасувати')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              final currentDate = DateService().selectedDate.value;
              MockDietRepository().deleteMeal(currentDate, meal.id);
              Navigator.of(context).pop();
            },
            child: const Text('Видалити', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPhe = meal.totalPhe.toStringAsFixed(0);
    final totalKcal = meal.totalCalories.toStringAsFixed(0);

    return Row(
      children: [
        // [ВУЗОЛ: ДРАГ-ІКОНКА ЗЛІВА]: Дозволяє затискати та перетягувати картку
        ReorderableDragStartListener(
          index: index,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.drag_indicator_rounded, // Або Icons.touch_app_rounded (ручка)
              color: Colors.grey.shade400,
              size: 22,
            ),
          ),
        ),

        // Емодзі прийому їжі
        Text(_mealEmoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 8.0),

        // Назва прийому
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

        // Числовий підсумок
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

        const SizedBox(width: 4.0),

        // Кнопка видалення картки
        IconButton(
          icon: Icon(Icons.close_rounded, color: Colors.grey.shade400, size: 20),
          onPressed: () => _confirmDelete(context),
          tooltip: 'Видалити прийом їжі',
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.all(4.0),
        ),
      ],
    );
  }
}
