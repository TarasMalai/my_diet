// ============================================================================
// НАЗВА ФАЙЛУ: cooking_totals_header_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Віджет верхньої інформаційної панелі для відображення загальних
//              показників сирої маси та нутрієнтів у кухонному котлі
// ============================================================================

import 'package:flutter/material.dart';

class CookingTotalsHeaderWidget extends StatelessWidget {
  final Map<String, double> totals;

  const CookingTotalsHeaderWidget({super.key, required this.totals});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.orange.shade50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTotalMetric('Сира маса', '${totals['weight']!.toStringAsFixed(1)} г'),
          _buildTotalMetric('Загалом ФА', '${totals['phe']!.toStringAsFixed(1)} мг'),
          _buildTotalMetric('Загалом Ккал', totals['calories']!.toStringAsFixed(1)),
        ],
      ),
    );
  }

  /// Допоміжний метод для побудови окремого елемента метрики
  Widget _buildTotalMetric(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ],
    );
  }
}
