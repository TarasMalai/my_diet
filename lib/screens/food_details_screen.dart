// ============================================================================
// НАЗВА ФАЙЛУ: food_details_screen.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Екран деталей харчування за день. Відображає календар,
//              зведену плашку нутрієнтів та список прийомів їжі з підтримкою
//              перетягування (Drag & Drop) і додавання нових прийомів.
// ============================================================================

import 'package:flutter/material.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: ІМПОРТИ СЕРВІСІВ ТА РЕПОЗИТОРІЇВ
// ----------------------------------------------------------------------------
import 'package:my_diet/services/date_service.dart';
import 'package:my_diet/services/mock_diet_repository_service.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1.1]: ІМПОРТИ МОДЕЛЕЙ
// ----------------------------------------------------------------------------
import 'package:my_diet/models/meal_model.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1.2]: ІМПОРТИ ВІДЖЕТІВ
// ----------------------------------------------------------------------------
import 'package:my_diet/widgets/food_details_screen_widget/food_details_app_bar_widget.dart';
import 'package:my_diet/widgets/common_widget/calendar_widget.dart';
import 'package:my_diet/widgets/food_details_screen_widget/daily_summary_bar_widget.dart';
import 'package:my_diet/widgets/food_details_screen_widget/meal_card_widget.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 2]: ГОЛОВНИЙ КЛАС ЕКРАНУ (FoodDetailsScreen)
// ----------------------------------------------------------------------------
/// Екран деталей харчування з можливістю перетягування прийомів їжі (Drag & Drop).
class FoodDetailsScreen extends StatelessWidget {
  final String title;

  const FoodDetailsScreen({super.key, this.title = 'Деталі харчування'});

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.1]: ДІАЛОГОВЕ ВІКНО СТВОРЕННЯ НОВОГО ПРИЙОМУ ЇЖІ
  // --------------------------------------------------------------------------
  /// Відкриває модальний діалог із текстовим полем для введення назви прийому їжі.
  void _showAddMealDialog(BuildContext context) {
    // [ВУЗОЛ 2.1.1: Текстовий контролер]
    // Зберігає та контролює введене користувачем значення у текстовому полі.
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
                // Зчитуємо поточну дату з DateService і додаємо новий прийом в репозиторій
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

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.2]: ВІЗУАЛЬНИЙ КАРКАС ЕКРАНУ (BUILD)
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // ----------------------------------------------------------------------
      // [ВУЗОЛ 2.2.1]: ВЕРХНЯ ПАНЕЛЬ (APP BAR)
      // ----------------------------------------------------------------------
      appBar: FoodDetailsAppBarWidget(
        title: title,
        onExport: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Експорт даних у розробці...')));
        },
        onSettings: () {},
      ),

      // ----------------------------------------------------------------------
      // [ВУЗОЛ 2.2.2]: ОСНОВНЕ ТІЛО З РЕАКТИВНОЮ ДАТОЮ ТА ДАНІ З МОЖЛИВІСТЮ ПЕРЕТЯГУВАННЯ
      // ----------------------------------------------------------------------
      body: ValueListenableBuilder<DateTime>(
        // [ВУЗОЛ 2.2.2.1: Реактивна підписка на дату]
        // Оновлює весь вміст екрана при зміні поточної дати в DateService.
        valueListenable: DateService().selectedDate,
        builder: (context, currentDate, child) {
          return Column(
            children: [
              // --------------------------------------------------------------
              // [ВУЗОЛ 2.2.2.2]: КАЛЕНДАР З ГЛОБАЛЬНИМ ОНОВЛЕННЯМ
              // --------------------------------------------------------------
              CalendarWidget(
                selectedDate: currentDate,
                onDateSelected: (newDate) {
                  DateService().updateDate(newDate);
                },
              ),

              // --------------------------------------------------------------
              // [ВУЗОЛ 2.2.2.3]: ПЛАШКА ПІДСУМКІВ ЗА ДЕНЬ
              // --------------------------------------------------------------
              ValueListenableBuilder<int>(
                // Реагує на оновлення MockDietRepository
                valueListenable: MockDietRepository().listenable,
                builder: (context, _, child) {
                  return const DailySummaryBarWidget();
                },
              ),

              // --------------------------------------------------------------
              // [ВУЗОЛ 2.2.2.4]: СПИСОК ПРИЙОМІВ ЇЖІ З ПЕРЕТЯГУВАННЯМ (REORDERABLE)
              // --------------------------------------------------------------
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

                    // [ВУЗОЛ 2.2.2.4.1: ReorderableListView]
                    // Спеціальний список, що дозволяє користувачеві змінювати порядок елементів
                    // за допомогою затискання та перетягування (Drag & Drop).
                    return ReorderableListView.builder(
                      buildDefaultDragHandles: false, // Вимикаємо стандартну іконку справа
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      itemCount: meals.length,
                      onReorderItem: (oldIndex, newIndex) {
                        // Калбек зміни порядку елементів у списку
                        final item = meals.removeAt(oldIndex);
                        meals.insert(newIndex, item);
                      },
                      itemBuilder: (context, index) {
                        final meal = meals[index];
                        // [ВУЗОЛ 2.2.2.4.2: KeyedSubtree та ValueKey]
                        // Обов'язковий унікальний ключ (ValueKey) для збереження стану віджетів
                        // при їх переміщенні в динамічному списку.
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
      // [ВУЗОЛ 2.2.3]: НИЖНЯ ПАНЕЛЬ З КНОПКОЮ ДОДАВАННЯ НОВОГО ПРИЙОМУ ЇЖІ
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
