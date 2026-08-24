// ============================================================================
// НАЗВА ФАЙЛУ: meal_card_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Головна картка прийому їжі на основі MealModel
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/models/meal_model.dart';
import 'package:my_diet/widgets/food_details_screen_widget/food_row_item_widget.dart';
import 'package:my_diet/widgets/food_details_screen_widget/meal_card_widget/add_food_button_widget.dart';
import 'package:my_diet/widgets/food_details_screen_widget/meal_card_widget/meal_header_widget.dart';
import 'package:my_diet/widgets/food_details_screen_widget/meal_card_widget/meal_note_widget.dart';
import 'package:my_diet/services/date_service.dart';
import 'package:my_diet/services/mock_diet_repository.dart';

void _showEditNoteDialog(BuildContext context, MealModel meal) {
  final controller = TextEditingController(text: meal.note ?? '');

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Нотатка до: "${meal.title}"'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: 'Введіть нотатку або коментар...', border: OutlineInputBorder()),
        maxLines: 3,
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Скасувати')),
        ElevatedButton(
          onPressed: () {
            final currentDate = DateService().selectedDate.value;

            // Тепер зберігаємо нотатку у репозиторії!
            MockDietRepository().updateMealNote(currentDate, meal.id, controller.text.trim());

            Navigator.of(context).pop();
          },
          child: const Text('Зберегти'),
        ),
      ],
    ),
  );
}

/// [ВУЗОЛ 1]: ГОЛОВНИЙ ВІДЖЕТ КАРТКИ ПРИЙОМУ ЇЖІ
class MealCardWidget extends StatelessWidget {
  final MealModel meal;
  final bool initiallyExpanded;
  final VoidCallback? onAddFoodPressed;
  final int index;

  const MealCardWidget({
    super.key,
    required this.meal,
    required this.index,
    this.initiallyExpanded = false,
    this.onAddFoodPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 2,
      color: Colors.white,
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        title: MealHeaderWidget(meal: meal, index: index),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Блок нотатки (якщо вона є)
                MealNoteWidget(
                  note: meal.note ?? '',
                  onTap: () {
                    // Тут ми показуємо діалог для введення/редагування нотатки
                    _showEditNoteDialog(context, meal);
                  },
                ),

                // 2. Підзаголовок списку страв
                const Text(
                  "З'їдені страви та продукти:",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 6.0),

                // 3. Список продуктів або повідомлення "Порожньо"
                if (meal.items.isEmpty)
                  const Padding(
                    // ВИПРАВЛЕНО: Використовуємо EdgeInsets.symmetric замість EdgeInsets.vertical для const
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Поки немає доданих продуктів',
                      style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.black54),
                    ),
                  )
                else
                  // Відображаємо продукти з моделі
                  ...meal.items.map(
                    (item) => FoodRowItemWidget(
                      name: item.name,
                      weight: '${item.weight.toStringAsFixed(0)} г',
                      fa: '${item.phe.toStringAsFixed(0)} ФА',
                      kcal: '${item.calories.toStringAsFixed(0)} ккал',
                      onDelete: () {
                        final currentDate = DateService().selectedDate.value;
                        MockDietRepository().removeFoodFromMeal(currentDate, meal.id, item.id);
                      },
                    ),
                  ),

                // 4. Кнопка додавання нового продукту
                Center(
                  child: AddFoodButtonWidget(
                    date: DateService()
                        .selectedDate
                        .value, // або currentDate (дата з важеля календаря чи параметрів картки)
                    mealId: meal.id, // ID поточного прийому їжі
                    mealTitle: meal.title, // Назва прийому (напр. 'СНІДАНОК')
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
