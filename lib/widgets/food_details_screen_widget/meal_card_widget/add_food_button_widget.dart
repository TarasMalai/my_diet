// ============================================================================
// НАЗВА ФАЙЛУ: add_food_button_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Кнопка додавання продукту в картці прийому їжі
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/widgets/food_details_screen_widget/meal_card_widget/add_food_button_widget/add_food_dialog_widget.dart';

class AddFoodButtonWidget extends StatelessWidget {
  final DateTime date;
  final String mealId;
  final String mealTitle;

  const AddFoodButtonWidget({super.key, required this.date, required this.mealId, required this.mealTitle});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AddFoodDialogWidget(date: date, mealId: mealId, mealTitle: mealTitle),
        );
      },
      icon: const Icon(Icons.add_rounded, size: 20),
      label: const Text('Додати продукт', style: TextStyle(fontWeight: FontWeight.w600)),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.teal.shade800,
        side: BorderSide(color: Colors.teal.shade300, width: 1.2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
