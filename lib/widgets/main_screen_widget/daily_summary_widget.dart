// ============================================================================
// НАЗВА ФАЙЛУ: daily_summary_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Віджет блоку "Баланс за день" на головному екрані з розгортанням ФА
// ============================================================================

import 'package:flutter/material.dart';

import 'package:my_diet/services/date_service.dart';
import 'package:my_diet/services/diet_settings_service.dart';
import 'package:my_diet/services/diet_state_service.dart';
import 'package:my_diet/services/mock_diet_repository_service.dart';
import 'package:my_diet/widgets/main_screen_widget/daily_summary_widget/metric_card_widget.dart';
import 'package:my_diet/widgets/main_screen_widget/phe_expansion_tile_widget.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: ГОЛОВНИЙ КЛАС ВІДЖЕТА СУМАРНОГО БАЛАНСУ (DailySummaryWidget)
// ----------------------------------------------------------------------------
class DailySummaryWidget extends StatefulWidget {
  final VoidCallback onTapDetails;

  const DailySummaryWidget({super.key, required this.onTapDetails});

  @override
  State<DailySummaryWidget> createState() => _DailySummaryWidgetState();
}

// ----------------------------------------------------------------------------
// [ВУЗОЛ 2]: СТАН ВІДЖЕТА (_DailySummaryWidgetState)
// ----------------------------------------------------------------------------
class _DailySummaryWidgetState extends State<DailySummaryWidget> {
  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.1]: ЗМІННІ СТАНУ
  // --------------------------------------------------------------------------
  bool _isExpanded = false;

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.2]: ВІЗУАЛЬНИЙ КАРКАС ТА ЛОГІКА (BUILD)
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
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

            // [СУПУТНІ АМІНОКИСЛОТИ]
            double totalLeu = 0;
            double totalTyr = 0;
            double totalMet = 0;
            double totalLes = 0;

            // [ДОДАТКОВІ НУТРІЄНТИ]
            double totalFiber = 0;
            double totalSugar = 0;
            double totalSalt = 0;
            double totalWater = 0;
            double totalEnergy = 0;

            // --------------------------------------------------------------------
            // [ВУЗОЛ 2.2.1]: ОБРАХУНОК СУМАРНИХ ПОКАЗНИКІВ
            // --------------------------------------------------------------------
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
                totalLes += item.lysine;

                totalFiber += item.fiber;
                totalSugar += item.sugar;
                totalSalt += item.salt;
                totalWater += item.water;
                totalEnergy += item.energy;
              }
            }

            // Отримуємо актуальні цілі з сервісу налаштувань
            final settings = DietSettingsService();

            // Формуємо список з 10 показників
            final List<NutrientItem> itemsList = [
              NutrientItem(
                label: 'Фенілаланін',
                current: totalPhe,
                target: settings.targetPhe,
                unit: 'ФА',
                baseColor: Colors.purple,
                icon: Icons.science,
              ),
              NutrientItem(
                label: 'Калорії',
                current: totalCalories,
                target: settings.targetCalories,
                unit: 'ккал',
                baseColor: Colors.orange,
                icon: Icons.local_fire_department,
              ),
              NutrientItem(
                label: 'Білки',
                current: totalProtein,
                target: settings.targetProtein,
                unit: 'г',
                baseColor: Colors.blue,
                icon: Icons.fitness_center,
              ),
              NutrientItem(
                label: 'Вуглеводи',
                current: totalCarbs,
                target: settings.targetCarbs,
                unit: 'г',
                baseColor: Colors.amber,
                icon: Icons.grain,
              ),
              NutrientItem(
                label: 'Жири',
                current: totalFat,
                target: settings.targetFat,
                unit: 'г',
                baseColor: Colors.redAccent,
                icon: Icons.opacity,
              ),
              NutrientItem(
                label: 'Клітковина',
                current: totalFiber,
                target: settings.targetFiber,
                unit: 'г',
                baseColor: Colors.green,
                icon: Icons.grass,
              ),
              NutrientItem(
                label: 'Цукор',
                current: totalSugar,
                target: settings.targetSugar,
                unit: 'г',
                baseColor: Colors.pink,
                icon: Icons.cookie_outlined,
              ),
              NutrientItem(
                label: 'Сіль',
                current: totalSalt,
                target: settings.targetSalt,
                unit: 'г',
                baseColor: Colors.grey,
                icon: Icons.grain,
              ),
              NutrientItem(
                label: 'Вода',
                current: totalWater,
                target: settings.targetWater,
                unit: 'мл',
                baseColor: Colors.lightBlue,
                icon: Icons.water_drop_outlined,
              ),
              NutrientItem(
                label: 'Енергія',
                current: totalEnergy,
                target: settings.targetEnergy,
                unit: 'кДж',
                baseColor: Colors.deepOrange,
                icon: Icons.bolt,
              ),
            ];

            final bool hasAnyExceeded = itemsList.any((item) => item.isExceeded);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --------------------------------------------------------------
                  // [ВУЗОЛ 2.2.2]: ШАПКА БЛОКУ "БАЛАНС ЗА ДЕНЬ"
                  // --------------------------------------------------------------
                  Material(
                    color: Colors.blue.shade50.withValues(alpha: 0.4),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
                    child: InkWell(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
                      onTap: widget.onTapDetails,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Баланс за день',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 15),
                            ),
                            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blue.shade700),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // --------------------------------------------------------------
                  // [ВУЗОЛ 2.2.3]: ОСНОВНИЙ ВМІСТ
                  // --------------------------------------------------------------
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hasAnyExceeded)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 10.0),
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Text(
                              'Увага: ліміти перевищено!',
                              style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),

                        // Список показників з розгортанням для Фенілаланіну
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _isExpanded ? itemsList.length : itemsList.take(2).length,
                          separatorBuilder: (context, index) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return PheExpansionTileWidget(
                                phe: totalPhe,
                                targetPhe: DietSettingsService().targetPhe,
                                leu: totalLeu,
                                tyr: totalTyr,
                                met: totalMet,
                                les: totalLes,
                              );
                            }
                            return MetricCardWidget(item: itemsList[index]);
                          },
                        ),

                        const SizedBox(height: 4),

                        // --------------------------------------------------------
                        // [ВУЗОЛ 2.2.4]: КНОПКА РОЗГОРТАННЯ / ЗГОРТАННЯ СПИСКУ
                        // --------------------------------------------------------
                        TextButton.icon(
                          onPressed: () => setState(() => _isExpanded = !_isExpanded),
                          icon: Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 18),
                          label: Text(_isExpanded ? 'Згорнути' : 'Показати всі'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
