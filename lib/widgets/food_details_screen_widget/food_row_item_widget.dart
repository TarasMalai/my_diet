// ============================================================================
// ВУЗОЛ: РЯДОК ОКРЕМОГО ПРОДУКТУ/СТРАВИ (FOOD ROW ITEM WIDGET)
// Файл: lib/widgets/food_details_screen/food_row_item_widget.dart
// ============================================================================

import 'package:flutter/material.dart';

/// Віджет відображення інформації про один спожитий продукт або страву.
/// Виводит назву, вагу/об'єм, кількість фенілаланіну (ФА) та калорійність + кнопку видалення.
class FoodRowItemWidget extends StatelessWidget {
  /// Назва продукту (наприклад, "Яблуко печене")
  final String name;

  /// Вага або об'єм (наприклад, "100 г" або "200 мл")
  final String weight;

  /// Вміст фенілаланіну (наприклад, "10 ФА")
  final String fa;

  /// Калорійність (наприклад, "52 ккал")
  final String kcal;

  /// Колбек для видалення продукту
  final VoidCallback onDelete;

  const FoodRowItemWidget({
    super.key,
    required this.name,
    required this.weight,
    required this.fa,
    required this.kcal,
    required this.onDelete,
  });

  // --------------------------------------------------------------------------
  // МЕТОД ПОБУДОВИ ВІДЖЕТА (build)
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(10.0),
      // [ВУЗОЛ: ДИЗАЙН] Овальний прямокутник із закругленими кутами та оранжевим контуром
      decoration: BoxDecoration(
        color: Colors.orange.shade50.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.orange.shade200, width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ------------------------------------------------------------------
          // ВУЗОЛ 1: НАЗВА ТА ВАГА ПРОДУКТУ (Ліва частина)
          // ------------------------------------------------------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
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
              Text(
                fa,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.brown),
              ),
              Text(kcal, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),

          const SizedBox(width: 4),

          // ------------------------------------------------------------------
          // ВУЗОЛ 3: КНОПКА ВИДАЛЕННЯ (Смітник)
          // ------------------------------------------------------------------
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
            onPressed: onDelete,
            tooltip: 'Видалити',
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.only(left: 8.0),
          ),
        ],
      ),
    );
  }
}
