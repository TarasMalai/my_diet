// ============================================================================
// ВУЗОЛ: ЕКРАН ДЕТАЛЕЙ ХАРЧУВАННЯ ЗА ДЕНЬ (FOOD DETAILS SCREEN)
// Файл: lib/screens/food_details_screen.dart
// ============================================================================

import 'package:flutter/material.dart';

// Сервіси та репозиторії
import 'package:my_diet/services/date_service.dart';
import 'package:my_diet/services/mock_diet_repository.dart';

// Моделі
import 'package:my_diet/models/meal_model.dart';

// Віджети
import 'package:my_diet/widgets/food_details_screen_widget/food_details_app_bar_widget.dart';
import 'package:my_diet/widgets/common_widget/calendar_widget.dart';
import 'package:my_diet/widgets/food_details_screen_widget/daily_summary_bar_widget.dart';
import 'package:my_diet/widgets/food_details_screen_widget/meal_card_widget.dart';

/// Екран деталей харчування з можливістю перетягування прийомів їжі (Drag & Drop).
class FoodDetailsScreen extends StatelessWidget {
  final String title;

  const FoodDetailsScreen({super.key, this.title = 'Деталі харчування'});

  // [ВУЗОЛ 1]: Діалогове вікно створення нового прийому їжі
  void _showAddMealDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Додати прийом їжі'),
        content: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Назва (наприклад: Сніданок, Перекус)',
            hintText: 'Введіть назву...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Скасувати')),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                final currentDate = DateService().selectedDate.value;
                MockDietRepository().addMeal(currentDate, text);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Додати'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // ----------------------------------------------------------------------
      // ВУЗОЛ 2: ВЕРХНЯ ПАНЕЛЬ (APP BAR)
      // ----------------------------------------------------------------------
      appBar: FoodDetailsAppBarWidget(
        title: title,
        onExport: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Експорт даних у розробці...')));
        },
        onSettings: () {},
      ),

      // ----------------------------------------------------------------------
      // ВУЗОЛ 3: ОСНОВНЕ ТІЛО З РЕАКТИВНОЮ ДАТОЮ ТА ДАНІ З МОЖЛИВІСТЮ ПЕРЕТЯГУВАННЯ
      // ----------------------------------------------------------------------
      body: ValueListenableBuilder<DateTime>(
        valueListenable: DateService().selectedDate,
        builder: (context, currentDate, child) {
          return Column(
            children: [
              // --- 3.1. КАЛЕНДАР З ГЛОБАЛЬНИМ ОНОВЛЕННЯМ ---
              CalendarWidget(
                selectedDate: currentDate,
                onDateSelected: (newDate) {
                  DateService().updateDate(newDate);
                },
              ),

              // --- 3.2. ПЛАШКА ПІДСУМКІВ ЗА ДЕНЬ ---
              ValueListenableBuilder<int>(
                valueListenable: MockDietRepository().listenable,
                builder: (context, _, child) {
                  return const DailySummaryBarWidget();
                },
              ),

              // --- 3.3. СПИСОК ПРИЙОМІВ ЇЖІ З ПЕРЕТЯГУВАННЯМ (REORDERABLE) ---
              Expanded(
                child: ValueListenableBuilder<int>(
                  valueListenable: MockDietRepository().listenable,
                  builder: (context, _, child) {
                    final List<MealModel> meals = MockDietRepository().getMealsForDate(currentDate);

                    if (meals.isEmpty) {
                      return const Center(
                        child: Text('Немає даних про харчування на цю дату', style: TextStyle(color: Colors.grey)),
                      );
                    }

                    return ReorderableListView.builder(
                      buildDefaultDragHandles: false, // [ВУЗОЛ]: Вимикаємо стандартний іконку справа
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      itemCount: meals.length,
                      onReorderItem: (oldIndex, newIndex) {
                        final item = meals.removeAt(oldIndex);
                        meals.insert(newIndex, item);
                      },
                      itemBuilder: (context, index) {
                        final meal = meals[index];
                        return KeyedSubtree(
                          key: ValueKey(meal.id),
                          child: MealCardWidget(
                            meal: meal,
                            index: index, // Передаємо індекс для DragStartListener
                            initiallyExpanded: false,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),

      // ----------------------------------------------------------------------
      // ВУЗОЛ 4: НИЖНЯ ПАНЕЛЬ З КНОПКОЮ ДОДАВАННЯ НОВОГО ПРИЙОМУ ЇЖІ
      // ----------------------------------------------------------------------
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, -2), blurRadius: 4),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Додати прийом їжі', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            onPressed: () => _showAddMealDialog(context),
          ),
        ),
      ),
    );
  }
}
