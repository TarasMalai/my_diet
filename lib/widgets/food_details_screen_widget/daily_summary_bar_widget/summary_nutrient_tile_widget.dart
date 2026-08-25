// ============================================================================
// НАЗВА ФАЙЛУ: summary_nutrient_tile_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Віджет відображення окремої плитки нутрієнта
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/models/summary_nutrient_item_model.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: ВІДЖЕТ ОКРЕМОЇ ПЛИТКИ НУТРІЄНТА (SummaryNutrientTileWidget)
// ----------------------------------------------------------------------------
class SummaryNutrientTileWidget extends StatelessWidget {
  final SummaryNutrientItemModel item;

  const SummaryNutrientTileWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isExceeded = item.isExceeded;
    final bool hasTarget = item.target != null && item.target! > 0;

    final Color statusColor = isExceeded ? Colors.red.shade600 : item.baseColor;
    final Color borderColor = isExceeded ? Colors.red.shade300 : item.baseColor.withValues(alpha: 0.3);
    final Color bgColor = isExceeded
        ? Colors.red.shade50.withValues(alpha: 0.3)
        : item.baseColor.withValues(alpha: 0.03);

    final String currentStr = item.current % 1 == 0 ? item.current.toInt().toString() : item.current.toStringAsFixed(1);
    final String targetStr = hasTarget
        ? (item.target! % 1 == 0 ? item.target!.toInt().toString() : item.target!.toStringAsFixed(1))
        : '';

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: isExceeded ? 1.5 : 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // [1] Заголовок плиточки (Іконка + Назва)
          Row(
            children: [
              Icon(item.icon, size: 14, color: isExceeded ? Colors.red.shade700 : item.baseColor),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),

          // [2] Блок додаткових амінокислот всередині плитки Фенілаланіну
          if (item.aminoMap != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAminoLabel('Leu', item.aminoMap!['Leu']!),
                      const SizedBox(height: 2),
                      _buildAminoLabel('Met', item.aminoMap!['Met']!),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAminoLabel('Tyr', item.aminoMap!['Tyr']!),
                      const SizedBox(height: 2),
                      _buildAminoLabel('Les', item.aminoMap!['Les']!),
                    ],
                  ),
                ],
              ),
            )
          else
            const Spacer(),

          // [3] Числове значення та ціль
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: currentStr,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: statusColor),
                  ),
                  if (hasTarget)
                    TextSpan(
                      text: ' / $targetStr ${item.unit}',
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                    )
                  else
                    TextSpan(
                      text: ' ${item.unit}',
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                    ),
                ],
              ),
            ),
          ),

          // [4] Прогрес-бар (відображається тільки якщо встановлено ціль)
          if (hasTarget)
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: item.progress,
                backgroundColor: isExceeded ? Colors.red.shade100 : item.baseColor.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                minHeight: 4,
              ),
            )
          else
            const SizedBox(height: 4),
        ],
      ),
    );
  }

  /// Вкладений метод для побудови текстового підпису амінокислоти
  Widget _buildAminoLabel(String name, double val) {
    final String valStr = val % 1 == 0 ? val.toInt().toString() : val.toStringAsFixed(1);
    return Text(
      '$name: $valStr',
      style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600, color: Colors.purple.shade800),
    );
  }
}
