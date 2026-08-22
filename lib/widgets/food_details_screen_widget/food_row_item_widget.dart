// ============================================================================
// ВУЗОЛ: РЯДОК ОКРЕМОГО ПРОДУКТУ/СТРАВИ (FOOD ROW ITEM WIDGET)
// Файл: lib/widgets/food_details_screen/food_row_item_widget.dart
// ============================================================================

import 'package:flutter/material.dart';

/// Віджет відображення інформації про один спожитий продукт або страву.
/// Виводить назву, вагу/об'єм, кількість фенілаланіну (ФА) та калорійність.
class FoodRowItemWidget extends StatelessWidget {
  /// Назва продукту (наприклад, "Яблуко печене")
  final String name;

  /// Вага або об'єм (наприклад, "100 г" або "200 мл")
  final String weight;

  /// Вміст фенілаланіну (наприклад, "10 ФА")
  final String fa;

  /// Калорійність (наприклад, "52 ккал")
  final String kcal;

  const FoodRowItemWidget({super.key, required this.name, required this.weight, required this.fa, required this.kcal});

  // --------------------------------------------------------------------------
  // МЕТОД ПОБУДОВИ ВІДЖЕТА (build)
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Padding(
      // Внутрішні відступи зверху та знизу для візуального розділення рядків
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ------------------------------------------------------------------
          // ВУЗОЛ 1: НАЗВА ТА ВАГА ПРОДУКТУ (Ліва частина)
          // ------------------------------------------------------------------
          // Expanded змушує текст займати весь доступний простір зліва,
          // застерігаючи від виходу за межі екрана (Overflow error).
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
                  // Обрізаємо текст трикрапкою, якщо назва занадто довга
                  overflow: TextOverflow.ellipsis,
                ),
                Text(weight, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ------------------------------------------------------------------
          // ВУЗОЛ 2: ПОКАЗНИКИ ФА ТА КАЛОРІЙ (Права частина)
          // ------------------------------------------------------------------
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Виділяємо ФА напівжирним шрифтом, оскільки це критичний показник
              Text(
                fa,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.brown),
              ),
              Text(kcal, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),
        ],
      ),
    );
  }
}
