// ============================================================================
// НАЗВА ФАЙЛУ: meal_header_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Заголовок (шапка) картки прийому їжі з drag-іконкою, емодзі, підсумком ФА/ккал та кнопкою видалення
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/models/meal_model.dart';
import 'package:my_diet/services/date_service.dart';
import 'package:my_diet/repositories/diet_repository.dart';

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
              DietRepository().deleteMeal(currentDate, meal.id);
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // [ВУЗОЛ 1.3.1]: ІКОНКА ПЕРЕТЯГУВАННЯ (Drag Indicator)
        ReorderableDragStartListener(
          index: index,
          child: Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: Icon(Icons.drag_indicator_rounded, color: Colors.grey.shade400, size: 22),
          ),
        ),

        // [ВУЗОЛ 1.3.2]: ЕМОДЗІ ПРИЙОМУ ЇЖІ (По центру висоти двох рядків)
        Text(_mealEmoji, style: const TextStyle(fontSize: 26)),
        const SizedBox(width: 10.0),

        // [ВУЗОЛ 1.3.3]: ЦЕНТРАЛЬНИЙ БЛОК (Два рядки: Назва + Нутрієнти)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // РЯДОК 1: Назва прийому їжі
              Text(
                meal.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 15,
                  letterSpacing: 0.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3.0),

              // РЯДОК 2: Плашки/Чипи нутрієнтів (готово до розширення жирами/вуглеводами)
              Wrap(
                spacing: 6.0,
                runSpacing: 2.0,
                children: [
                  _buildNutrientBadge('$totalPhe ФА', Colors.purple.shade700, Colors.purple.shade50),
                  _buildNutrientBadge('$totalKcal ккал', Colors.orange.shade800, Colors.orange.shade50),
                  // Зауваження: Сюди легко додати БЖУ в майбутньому, наприклад:
                  // _buildNutrientBadge('12г Б', Colors.blue.shade800, Colors.blue.shade50),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 6.0),

        // [ВУЗОЛ 1.3.4]: КНОПКА ВИДАЛЕННЯ ПРИЙОМУ ЇЖІ (Хрестик по центру)
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

  // Допоміжний метод для створення компактних чипів нутрієнтів
  Widget _buildNutrientBadge(String text, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4.0)),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w600, color: textColor, fontSize: 11),
      ),
    );
  }
}
