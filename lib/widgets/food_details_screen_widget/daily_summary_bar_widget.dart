// ============================================================================
// НАЗВА ФАЙЛУ: daily_summary_bar_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Панель нутрієнтів з амінокислотами та каруселлю на 4 плитки
// ============================================================================

import 'package:flutter/material.dart';

import 'package:my_diet/models/summary_nutrient_item_model.dart';
import 'package:my_diet/services/date_service.dart';
import 'package:my_diet/services/diet_settings_service.dart';
import 'package:my_diet/services/mock_diet_repository_service.dart';
import 'package:my_diet/widgets/food_details_screen_widget/daily_summary_bar_widget/summary_nutrient_tile_widget.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: ГОЛОВНИЙ ВІДЖЕТ ПАНЕЛІ ПІДСУМКІВ (DailySummaryBarWidget)
// ----------------------------------------------------------------------------
class DailySummaryBarWidget extends StatefulWidget {
  const DailySummaryBarWidget({super.key});

  @override
  State<DailySummaryBarWidget> createState() => _DailySummaryBarWidgetState();
}

class _DailySummaryBarWidgetState extends State<DailySummaryBarWidget> {
  int _startIndex = 0;

  void _next(int total) {
    if (total == 0) return;
    setState(() {
      _startIndex = (_startIndex + 1) % total;
    });
  }

  void _prev(int total) {
    if (total == 0) return;
    setState(() {
      _startIndex = (_startIndex - 1 + total) % total;
    });
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.1]: ВІЗУАЛЬНИЙ КАРКАС ТА ЛОГІКА РОЗРАХУНКУ (BUILD)
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final settings = DietSettingsService();

    return ValueListenableBuilder<int>(
      valueListenable: MockDietRepository().listenable,
      builder: (context, _, child) {
        return ValueListenableBuilder<DateTime>(
          valueListenable: DateService().selectedDate,
          builder: (context, currentDate, child) {
            final meals = MockDietRepository().getMealsForDate(currentDate);

            // [ОСНОВНІ НУТРІЄНТИ]
            double totalPhe = 0;
            double totalCalories = 0;
            double totalProtein = 0;
            double totalCarbs = 0;
            double totalFat = 0;

            // [АМІНОКИСЛОТИ]
            double totalLeu = 0;
            double totalTyr = 0;
            double totalMet = 0;
            double totalLys = 0;

            // [ДОДАТКОВІ НУТРІЄНТИ]
            double totalFiber = 0;
            double totalSugar = 0;
            double totalSalt = 0;
            double totalWater = 0;
            double totalEnergy = 0;

            // Динамічний підрахунок усіх показників зі страв та продуктів
            for (var meal in meals) {
              totalPhe += meal.totalPhe;
              totalCalories += meal.totalCalories;
              totalProtein += meal.totalProtein;
              totalCarbs += meal.totalCarbs;
              totalFat += meal.totalFat;

              for (var item in meal.items) {
                totalLeu += item.leucine;
                totalTyr += item.tyrosine;
                totalMet += item.methionine;
                totalLys += item.lysine;

                totalFiber += item.fiber;
                totalSugar += item.sugar;
                totalSalt += item.salt;
                totalWater += item.water;
                totalEnergy += item.energy;
              }
            }

            final List<SummaryNutrientItemModel> items = [
              // 1. Фенілаланін + амінокислоти
              SummaryNutrientItemModel(
                label: 'Фенілаланін',
                current: totalPhe,
                target: settings.targetPhe,
                unit: 'ФА',
                baseColor: Colors.purple,
                icon: Icons.science,
                aminoMap: {'Leu': totalLeu, 'Tyr': totalTyr, 'Met': totalMet, 'Les': totalLys},
              ),
              // 2. Калорії
              SummaryNutrientItemModel(
                label: 'Калорії',
                current: totalCalories,
                target: settings.targetCalories,
                unit: 'ккал',
                baseColor: Colors.orange,
                icon: Icons.local_fire_department,
              ),
              // 3. Білки
              SummaryNutrientItemModel(
                label: 'Білки',
                current: totalProtein,
                target: settings.targetProtein,
                unit: 'г',
                baseColor: Colors.blue,
                icon: Icons.fitness_center,
              ),
              // 4. Вуглеводи
              SummaryNutrientItemModel(
                label: 'Вуглеводи',
                current: totalCarbs,
                target: settings.targetCarbs,
                unit: 'г',
                baseColor: Colors.amber,
                icon: Icons.grain,
              ),
              // 5. Жири
              SummaryNutrientItemModel(
                label: 'Жири',
                current: totalFat,
                target: settings.targetFat,
                unit: 'г',
                baseColor: Colors.redAccent,
                icon: Icons.opacity,
              ),
              // 6. Клітковина
              SummaryNutrientItemModel(
                label: 'Клітковина',
                current: totalFiber,
                target: settings.targetFiber,
                unit: 'г',
                baseColor: Colors.green,
                icon: Icons.grass,
              ),
              // 7. Цукор
              SummaryNutrientItemModel(
                label: 'Цукор',
                current: totalSugar,
                target: settings.targetSugar,
                unit: 'г',
                baseColor: Colors.pink,
                icon: Icons.cookie_outlined,
              ),
              // 8. Сіль
              SummaryNutrientItemModel(
                label: 'Сіль',
                current: totalSalt,
                target: settings.targetSalt,
                unit: 'г',
                baseColor: Colors.grey,
                icon: Icons.grain,
              ),
              // 9. Вода
              SummaryNutrientItemModel(
                label: 'Вода',
                current: totalWater,
                target: settings.targetWater,
                unit: 'мл',
                baseColor: Colors.lightBlue,
                icon: Icons.water_drop_outlined,
              ),
              // 10. Енергія
              SummaryNutrientItemModel(
                label: 'Енергія',
                current: totalEnergy,
                target: settings.targetEnergy,
                unit: 'кДж',
                baseColor: Colors.deepOrange,
                icon: Icons.bolt,
              ),
            ];

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
              color: Colors.white,
              child: SizedBox(
                height: 108,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.grey, size: 24),
                      onPressed: () => _prev(items.length),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 20),
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          const int visibleCount = 4;

                          List<Widget> visibleCards = [];
                          for (int i = 0; i < visibleCount; i++) {
                            int itemIndex = (_startIndex + i) % items.length;
                            final item = items[itemIndex];

                            visibleCards.add(
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                  child: SummaryNutrientTileWidget(item: item),
                                ),
                              ),
                            );
                          }

                          return Row(children: visibleCards);
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
                      onPressed: () => _next(items.length),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 20),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
