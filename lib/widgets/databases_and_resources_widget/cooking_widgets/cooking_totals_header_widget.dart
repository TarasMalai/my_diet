// ============================================================================
// НАЗВА ФАЙЛУ: cooking_totals_header_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Верхня панель з подвійними показниками нутрієнтів (Всього / На 100г)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/models/cooking_dish_model.dart';

class CookingTotalsHeaderWidget extends StatelessWidget {
  final CookingDishModel dish;
  final TextEditingController nameController;

  const CookingTotalsHeaderWidget({super.key, required this.dish, required this.nameController});

  // ==========================================================================
  // [ВУЗОЛ 1]: Форматування рядка "Всього / на 100г"
  // ==========================================================================
  String _formatDualValue(double total, double per100g) {
    return '${total.toStringAsFixed(0)} / ${per100g.toStringAsFixed(1)}';
  }

  @override
  Widget build(BuildContext context) {
    // Підготовлені значення для плиток
    final String weightValue = '${dish.netWeight.toStringAsFixed(0)} / 100';
    final String pheValue = _formatDualValue(dish.totalPhe, dish.phePer100g);
    final String calValue = _formatDualValue(dish.totalCalories, dish.caloriesPer100g);
    final String proteinValue = _formatDualValue(dish.totalProtein, dish.proteinPer100g);
    final String fatValue = _formatDualValue(dish.totalFat, dish.fatPer100g);
    final String carbsValue = _formatDualValue(dish.totalCarbs, dish.carbsPer100g);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border(bottom: BorderSide(color: Colors.orange.shade200, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ==================================================================
          // [ВУЗОЛ 2]: Поле введення назви страви
          // ==================================================================
          TextField(
            controller: nameController,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            decoration: InputDecoration(
              labelText: 'Назва страви',
              hintText: 'наприклад, Суп овочевий',
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.orange.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.orange.shade800, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 10),

          // ==================================================================
          // [ВУЗОЛ 3]: Адаптивна сітка плиток нутрієнтів (Всього / На 100г)
          // ==================================================================
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 560) {
                return Row(
                  children: [
                    Expanded(child: _buildMetricTile('Маса (г)', weightValue, Colors.blueGrey)),
                    const SizedBox(width: 4),
                    Expanded(child: _buildMetricTile('ФА (мг)', pheValue, Colors.purple.shade700)),
                    const SizedBox(width: 4),
                    Expanded(child: _buildMetricTile('Ккал', calValue, Colors.orange.shade900)),
                    const SizedBox(width: 4),
                    Expanded(child: _buildMetricTile('Білки (г)', proteinValue, Colors.red.shade700)),
                    const SizedBox(width: 4),
                    Expanded(child: _buildMetricTile('Жири (г)', fatValue, Colors.amber.shade800)),
                    const SizedBox(width: 4),
                    Expanded(child: _buildMetricTile('Вуглеводи (г)', carbsValue, Colors.teal.shade700)),
                  ],
                );
              } else {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildMetricTile('Маса (г)', weightValue, Colors.blueGrey)),
                        const SizedBox(width: 6),
                        Expanded(child: _buildMetricTile('ФА (мг)', pheValue, Colors.purple.shade700)),
                        const SizedBox(width: 6),
                        Expanded(child: _buildMetricTile('Ккал', calValue, Colors.orange.shade900)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(child: _buildMetricTile('Білки (г)', proteinValue, Colors.red.shade700)),
                        const SizedBox(width: 6),
                        Expanded(child: _buildMetricTile('Жири (г)', fatValue, Colors.amber.shade800)),
                        const SizedBox(width: 6),
                        Expanded(child: _buildMetricTile('Вуглеводи (г)', carbsValue, Colors.teal.shade700)),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // [ВУЗОЛ 4]: Віджет окремої плитки (Tile) з авто-масштабуванням
  // ==========================================================================
  Widget _buildMetricTile(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
