// ============================================================================
// НАЗВА ФАЙЛУ: add_food_button_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Кнопка "Додати продукт або страву", яка викликає AddFoodDialog
// ============================================================================

import 'package:flutter/material.dart';

// Імпорт діалогу додавання продукту з підпапки
import 'package:my_diet/widgets/food_details_screen_widget/meal_card_widget/add_food_button_widget/add_food_dialog_widget.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: КНОПКА ДОДАВАННЯ ПРОДУКТУ/СТРАВИ (AddFoodButtonWidget)
// ----------------------------------------------------------------------------
class AddFoodButtonWidget extends StatelessWidget {
  final DateTime date;
  final String mealId;
  final String mealTitle;

  const AddFoodButtonWidget({super.key, required this.date, required this.mealId, required this.mealTitle});

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.1]: ВІЗУАЛЬНИЙ КАРКАС ТА ВИКЛИК ДІАЛОГУ (BUILD)
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        // [ВУЗОЛ 1.1.1]: ВИКЛИК ДІАЛОГОВОГО ВІКНА ДОДАВАННЯ
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
