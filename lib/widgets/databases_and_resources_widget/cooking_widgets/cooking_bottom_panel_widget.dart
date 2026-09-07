// ============================================================================
// НАЗВА ФАЙЛУ: cooking_bottom_panel_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Віджет нижньої панелі керування для введення назви страви,
//              фінальної ваги після готування та кнопки збереження в Інвентар
// ============================================================================

import 'package:flutter/material.dart';

class CookingBottomPanelWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController finalWeightController;
  final VoidCallback onFinishCooking;

  const CookingBottomPanelWidget({
    super.key,
    required this.nameController,
    required this.finalWeightController,
    required this.onFinishCooking,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, offset: const Offset(0, -2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Назва готової страви (наприклад, Суп овочевий)',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: finalWeightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Фінальна вага після варіння/приготування (грам)',
              hintText: 'наприклад, 1800 (після уварки)',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onFinishCooking,
            icon: const Icon(Icons.inventory_2_outlined),
            label: const Text('Зберегти готову страву в Інвентар'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade800,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
