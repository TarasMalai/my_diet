// ============================================================================
// ВУЗОЛ: ЕКРАН ДЕТАЛЕЙ ХАРЧУВАННЯ ЗА ДЕНЬ (FOOD DETAILS SCREEN)
// Файл: lib/screens/food_details_screen.dart
// ============================================================================

import 'package:flutter/material.dart';

// Сервіси та репозиторії
import '../services/date_service.dart';
import '../services/mock_diet_repository.dart';

// Моделі
import '../models/meal_model.dart';

// Віджети
import '../widgets/food_details_screen_widget/food_details_app_bar_widget.dart';
import '../widgets/common_widget/calendar_widget.dart';
import '../widgets/food_details_screen_widget/daily_summary_bar_widget.dart';
import '../widgets/food_details_screen_widget/meal_card_widget.dart';

/// Екран деталей харчування, що динамічно отримує прийоми їжі за обраною датою.
class FoodDetailsScreen extends StatelessWidget {
  final String title;

  const FoodDetailsScreen({super.key, this.title = 'Деталі харчування'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // ----------------------------------------------------------------------
      // ВУЗОЛ 1: ВЕРХНЯ ПАНЕЛЬ (APP BAR)
      // ----------------------------------------------------------------------
      appBar: FoodDetailsAppBarWidget(
        title: title,
        onExport: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Експорт даних у розробці...')));
        },
        onSettings: () {},
      ),

      // ----------------------------------------------------------------------
      // ВУЗОЛ 2: ОСНОВНЕ ТІЛО З РЕАКТИВНОЮ ДАТОЮ ТА МОДЕЛЬНИМИ ДАНИМИ
      // ----------------------------------------------------------------------
      body: ValueListenableBuilder<DateTime>(
        valueListenable: DateService().selectedDate,
        builder: (context, currentDate, child) {
          return Column(
            children: [
              // --- 2.1. КАЛЕНДАР З ГЛОБАЛЬНИМ ОНОВЛЕННЯМ ---
              CalendarWidget(
                selectedDate: currentDate,
                onDateSelected: (newDate) {
                  DateService().updateDate(newDate);
                },
              ),

              // --- 2.2. ПЛАШКА ПІДСУМКІВ ЗА ДЕНЬ ---
              ValueListenableBuilder<int>(
                valueListenable: MockDietRepository().listenable,
                builder: (context, _, child) {
                  return const DailySummaryBarWidget();
                },
              ),

              // --- 2.3. ДИНАМІЧНИЙ СПИСОК КАРТОК ПРИЙОМІВ ЇЖІ ---
              Expanded(
                child: ValueListenableBuilder<int>(
                  // Слухаємо зміни в репозиторії для миттєвого оновлення списку
                  valueListenable: MockDietRepository().listenable,
                  builder: (context, _, child) {
                    final List<MealModel> meals = MockDietRepository().getMealsForDate(currentDate);

                    if (meals.isEmpty) {
                      return const Center(
                        child: Text('Немає даних про харчування на цю дату', style: TextStyle(color: Colors.grey)),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      itemCount: meals.length,
                      itemBuilder: (context, index) {
                        final meal = meals[index];
                        return MealCardWidget(
                          meal: meal,
                          initiallyExpanded: false, // Усі прийоми їжі згорнуті за замовчуванням
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
    );
  }
}
