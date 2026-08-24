// ============================================================================
// НАЗВА ФАЙЛУ: meal_header_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Заголовок (шапка) картки прийому їжі з drag-іконкою, емодзі, підсумком ФА/ккал та кнопкою видалення
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/models/meal_model.dart';
import 'package:my_diet/services/date_service.dart';
import 'package:my_diet/services/mock_diet_repository.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: ГОЛОВНИЙ ВІДЖЕТ ШАПКИ КАРТКИ (MealHeaderWidget)
// ----------------------------------------------------------------------------
class MealHeaderWidget extends StatelessWidget {
  final MealModel meal;
  final int index; // Індекс елемента для ReorderableDragStartListener

  const MealHeaderWidget({super.key, required this.meal, required this.index});

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.1]: ВИЗНАЧЕННЯ ЕМОДЗІ ПРИЙОМУ ЇЖІ (_mealEmoji)
  // --------------------------------------------------------------------------
  String get _mealEmoji {
    final titleUpper = meal.title.toUpperCase();
    if (titleUpper.contains('СНІДАНОК')) return '🌅';
    if (titleUpper.contains('ОБІД')) return '☀️';
    if (titleUpper.contains('ВЕЧЕРЯ')) return '🌙';
    return '🍎';
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.2]: ДІАЛОГ ПІДТВЕРДЖЕННЯ ВИДАЛЕННЯ (_confirmDelete)
  // --------------------------------------------------------------------------
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Видалити "${meal.title}"?'),
        content: const Text('Цей прийом їжі та всі додані до нього продукти будуть видалені.'),
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

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.3]: ВІЗУАЛЬНИЙ КАРКАС ТА ЕЛЕМЕНТИ ШАПКИ (BUILD)
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final totalPhe = meal.totalPhe.toStringAsFixed(0);
    final totalKcal = meal.totalCalories.toStringAsFixed(0);

    return Row(
      children: [
        // [ВУЗОЛ 1.3.1]: ІКОНКА ПЕРЕТЯГУВАННЯ (Drag Indicator)
        // Дозволяє затискати та перетягувати картку у ReorderableListView
        ReorderableDragStartListener(
          index: index,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.drag_indicator_rounded, color: Colors.grey.shade400, size: 22),
          ),
        ),

        // [ВУЗОЛ 1.3.2]: ЕМОДЗІ ТА НАЗВА ПРИЙОМУ ЇЖІ
        Text(_mealEmoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 8.0),
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

        // [ВУЗОЛ 1.3.3]: БЛОК ЗАГАЛЬНОГО ПІДСУМКУ (ФА та ккал)
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

        // [ВУЗОЛ 1.3.4]: КНОПКА ВИДАЛЕННЯ ПРИЙОМУ ЇЖІ (Хрестик)
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
