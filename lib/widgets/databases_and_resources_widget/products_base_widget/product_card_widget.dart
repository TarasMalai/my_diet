// ============================================================================
// НАЗВА ФАЙЛУ: product_card_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Картка продукту із повними назвами основних нутрієнтів та кнопками дій.
// ШЛЯХ: lib/widgets/databases_and_resources_widget/products_base_widget/product_card_widget.dart
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/models/product_model.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductCardWidget({super.key, required this.product, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.shade50.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade600, width: 1.5),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

          // ------------------------------------------------------------------
          // [ВУЗОЛ 1]: ЗГОРНУТИЙ СТАН
          // ------------------------------------------------------------------
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name.isEmpty ? '(Без назви)' : product.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: product.name.isEmpty ? Colors.red.shade700 : Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                product.category.isEmpty ? 'БЕЗ КАТЕГОРІЇ' : product.category.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),

              // [ВУЗОЛ 1.1]: РЯДОК ОСНОВНИХ НУТРІЄНТІВ З ПОВНИМИ НАЗВАМИ
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _buildMainBadge('Калорії', '${product.calories.toStringAsFixed(0)} ккал', Colors.orange.shade800),
                  _buildMainBadge('Фенілаланін', '${product.phe.toStringAsFixed(0)} мг', Colors.green.shade800),
                  _buildMainBadge('Білки', '${product.protein.toStringAsFixed(1)} г', Colors.blue.shade800),
                  _buildMainBadge('Жири', '${product.fat.toStringAsFixed(1)} г', Colors.amber.shade900),
                  _buildMainBadge('Вуглеводи', '${product.carbs.toStringAsFixed(1)} г', Colors.purple.shade800),
                ],
              ),
            ],
          ),

          // ------------------------------------------------------------------
          // [ВУЗОЛ 2]: РОЗГОРНУТИЙ СТАН
          // ------------------------------------------------------------------
          children: [
            const Divider(height: 16, thickness: 1),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Розширені нутрієнти та амінокислоти (на 100 г):',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _buildNutrientDetail('Тирозин (Tyr)', '${product.tyrosine.toStringAsFixed(0)} мг'),
                _buildNutrientDetail('Лейцин (Leu)', '${product.leucine.toStringAsFixed(0)} мг'),
                _buildNutrientDetail('Метіонін (Met)', '${product.methionine.toStringAsFixed(0)} мг'),
                _buildNutrientDetail('Лізин (Lys)', '${product.lysine.toStringAsFixed(0)} мг'),
                _buildNutrientDetail('Клітковина', '${product.fiber.toStringAsFixed(1)} г'),
                _buildNutrientDetail('Цукор', '${product.sugar.toStringAsFixed(1)} г'),
                _buildNutrientDetail('Сіль', '${product.salt.toStringAsFixed(2)} г'),
                _buildNutrientDetail('Вода', '${product.water.toStringAsFixed(1)} г'),
                _buildNutrientDetail('Енергія', '${product.energy.toStringAsFixed(0)} кДж'),
              ],
            ),
            const SizedBox(height: 16),

            // [ВУЗОЛ 2.1]: ПАНЕЛЬ КНОПОК ДІЙ (ВИДАЛИТИ ТА ПРАВИТИ)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Видалити'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade700,
                    side: BorderSide(color: Colors.red.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Правити'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 3]: ДОПОМІЖНІ МЕТОДИ ПЛАШОК
  // --------------------------------------------------------------------------
  Widget _buildMainBadge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  Widget _buildNutrientDetail(String label, String value) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
