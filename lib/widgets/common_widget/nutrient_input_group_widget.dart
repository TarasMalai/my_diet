// ============================================================================
// НАЗВА ФАЙЛУ: nutrient_input_group_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Компонований віджет для відображення групи числових полів
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/widgets/common_widget/app_number_input_field_widget.dart';

class NutrientInputRow {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final TextInputAction textInputAction;

  NutrientInputRow({
    required this.controller,
    required this.label,
    this.hintText = '0.0',
    this.textInputAction = TextInputAction.next,
  });
}

class NutrientInputGroupWidget extends StatelessWidget {
  final String title;
  final List<List<NutrientInputRow>> rows;

  const NutrientInputGroupWidget({super.key, required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.teal.shade800),
          ),
        ),
        for (var row in rows) ...[
          Row(
            children: [
              for (int i = 0; i < row.length; i++) ...[
                Expanded(
                  child: AppNumberInputFieldWidget(
                    controller: row[i].controller,
                    label: row[i].label,
                    hintText: row[i].hintText,
                    textInputAction: row[i].textInputAction,
                  ),
                ),
                if (i < row.length - 1) const SizedBox(width: 8),
              ],
            ],
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
