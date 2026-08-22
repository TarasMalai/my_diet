// ============================================================================
// НАЗВА ФАЙЛУ: metric_card_widget.dart
// ПРИЗНАЧЕННЯ: Графічна картка з точною візуалізацією станів (1, 2, 3)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/services/diet_state_service.dart';

class MetricCardWidget extends StatelessWidget {
  final NutrientItem item;

  const MetricCardWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isExceeded = item.isExceeded;

    // Акцентні кольори для стану перевищення та норми
    final Color statusColor = isExceeded ? Colors.red.shade600 : item.baseColor;
    final Color borderColor = isExceeded ? Colors.red.shade300 : item.baseColor.withValues(alpha: 0.25);
    final Color cardBgColor = isExceeded
        ? Colors.red.shade50.withValues(alpha: 0.3)
        : item.baseColor.withValues(alpha: 0.03);

    final String currentStr = item.current % 1 == 0 ? item.current.toInt().toString() : item.current.toStringAsFixed(1);
    final String targetStr = item.target % 1 == 0 ? item.target.toInt().toString() : item.target.toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: borderColor, width: isExceeded ? 1.5 : 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Іконка зберігає свій круглий стиль та оригінальний колір нутрієнта
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: (isExceeded ? Colors.red.shade100 : item.baseColor.withValues(alpha: 0.12)),
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: isExceeded ? Colors.red.shade700 : item.baseColor, size: 18),
              ),
              const SizedBox(width: 10),

              // Назва нутрієнта (не змінює свій колір при перевищенні)
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade800, fontWeight: FontWeight.w500),
                ),
              ),

              // Значення кількості (колір змінюється на червоний при перевищенні)
              Text(
                item.target > 0 ? '$currentStr / $targetStr ${item.unit}' : '$currentStr ${item.unit}',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: statusColor),
              ),
            ],
          ),

          // Смужка прогресу
          if (item.target > 0) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: item.progress,
                backgroundColor: isExceeded ? Colors.red.shade100 : item.baseColor.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                minHeight: 6,
              ),
            ),

            // Текст перевищення (якщо норма більша за 100%)
            if (isExceeded) ...[
              const SizedBox(height: 6),
              Text(
                'Перевищення у ${item.overflowRatio.toStringAsFixed(1)} раза!',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red.shade700),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
