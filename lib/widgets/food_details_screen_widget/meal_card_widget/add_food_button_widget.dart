// ============================================================================
// НАЗВА ФАЙЛУ: add_food_button_widget.dart
// ПРИЗНАЧЕННЯ: Кнопка "Додати продукт або страву", яка викликає AddFoodDialog
// ============================================================================

import 'package:flutter/material.dart';

// Імпорт діалогу з підпапки
import 'add_food_button_widget/add_food_dialog_widget.dart';

class AddFoodButtonWidget extends StatelessWidget {
  final DateTime date;
  final String mealId;
  final String mealTitle;

  const AddFoodButtonWidget({super.key, required this.date, required this.mealId, required this.mealTitle});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        // Викликаємо діалогове вікно додавання
        showDialog(
          context: context,
          builder: (ctx) => AddFoodDialogWidget(date: date, mealId: mealId, mealTitle: mealTitle),
        );
      },
      icon: const Icon(Icons.add_circle_outline),
      label: const Text('Додати продукт або страву'),
    );
  }
}
