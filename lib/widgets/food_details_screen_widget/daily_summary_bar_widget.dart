// ============================================================================
// НАЗВА ФАЙЛУ: daily_summary_bar_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Панель нутрієнтів з амінокислотами та каруселлю на 4 плитки
// ============================================================================

import 'package:flutter/material.dart';

import 'package:my_diet/services/date_service.dart';
import 'package:my_diet/services/diet_settings_service.dart';
import 'package:my_diet/services/mock_diet_repository_service.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: МОДЕЛЬ ДАНИХ ЕЛЕМЕНТА НУТРІЄНТА (NutrientItem)
// ----------------------------------------------------------------------------
class NutrientItem {
  final String label;
  final double current;
  final double? target;
  final String unit;
  final Color baseColor;
  final IconData icon;
  final Map<String, double>? aminoMap; // Карта амінокислот для плитки ФА

  NutrientItem({
    required this.label,
    required this.current,
    this.target,
    required this.unit,
    required this.baseColor,
    required this.icon,
    this.aminoMap,
  });

  bool get isExceeded => target != null && target! > 0 && current > target!;
  double get progress => (target != null && target! > 0) ? (current / target!).clamp(0.0, 1.0) : 0.0;
}

// ----------------------------------------------------------------------------
// [ВУЗОЛ 2]: ГОЛОВНИЙ ВІДЖЕТ ПАНЕЛІ ПІДСУМКІВ (DailySummaryBarWidget)
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
  // [ВУЗОЛ 2.1]: ВІЗУАЛЬНИЙ КАРКАС ТА ЛОГІКА РОЗРАХУНКУ (BUILD)
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

            // Динамічний підрахунок усіх показників з страв та продуктів
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

            final List<NutrientItem> items = [
              // 1. Фенілаланін + амінокислоти
              NutrientItem(
                label: 'Фенілаланін',
                current: totalPhe,
                target: settings.targetPhe,
                unit: 'ФА',
                baseColor: Colors.purple,
                icon: Icons.science,
                aminoMap: {'Leu': totalLeu, 'Tyr': totalTyr, 'Met': totalMet, 'Les': totalLys},
              ),
              // 2. Калорії
              NutrientItem(
                label: 'Калорії',
                current: totalCalories,
                target: settings.targetCalories,
                unit: 'ккал',
                baseColor: Colors.orange,
                icon: Icons.local_fire_department,
              ),
              // 3. Білки
              NutrientItem(
                label: 'Білки',
                current: totalProtein,
                target: settings.targetProtein,
                unit: 'г',
                baseColor: Colors.blue,
                icon: Icons.fitness_center,
              ),
              // 4. Вуглеводи
              NutrientItem(
                label: 'Вуглеводи',
                current: totalCarbs,
                target: settings.targetCarbs,
                unit: 'г',
                baseColor: Colors.amber,
                icon: Icons.grain,
              ),
              // 5. Жири
              NutrientItem(
                label: 'Жири',
                current: totalFat,
                target: settings.targetFat,
                unit: 'г',
                baseColor: Colors.redAccent,
                icon: Icons.opacity,
              ),
              // 6. Клітковина
              NutrientItem(
                label: 'Клітковина',
                current: totalFiber,
                target: settings.targetFiber,
                unit: 'г',
                baseColor: Colors.green,
                icon: Icons.grass,
              ),
              // 7. Цукор
              NutrientItem(
                label: 'Цукор',
                current: totalSugar,
                target: settings.targetSugar,
                unit: 'г',
                baseColor: Colors.pink,
                icon: Icons.cookie_outlined,
              ),
              // 8. Сіль
              NutrientItem(
                label: 'Сіль',
                current: totalSalt,
                target: settings.targetSalt,
                unit: 'г',
                baseColor: Colors.grey,
                icon: Icons.grain,
              ),
              // 9. Вода
              NutrientItem(
                label: 'Вода',
                current: totalWater,
                target: settings.targetWater,
                unit: 'мл',
                baseColor: Colors.lightBlue,
                icon: Icons.water_drop_outlined,
              ),
              // 10. Енергія
              NutrientItem(
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
                                  child: _buildNutrientTile(item),
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

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.2]: ПОБУДОВА ОКРЕМОЇ ПЛИТКИ НУТРІЄНТА (_buildNutrientTile)
  // --------------------------------------------------------------------------
  Widget _buildNutrientTile(NutrientItem item) {
    final bool isExceeded = item.isExceeded;
    final bool hasTarget = item.target != null && item.target! > 0;

    final Color statusColor = isExceeded ? Colors.red.shade600 : item.baseColor;
    final Color borderColor = isExceeded ? Colors.red.shade300 : item.baseColor.withValues(alpha: 0.3);
    final Color bgColor = isExceeded
        ? Colors.red.shade50.withValues(alpha: 0.3)
        : item.baseColor.withValues(alpha: 0.03);

    final String currentStr = item.current % 1 == 0 ? item.current.toInt().toString() : item.current.toStringAsFixed(1);
    final String targetStr = hasTarget
        ? (item.target! % 1 == 0 ? item.target!.toInt().toString() : item.target!.toStringAsFixed(1))
        : '';

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: isExceeded ? 1.5 : 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Заголовок
          Row(
            children: [
              Icon(item.icon, size: 14, color: isExceeded ? Colors.red.shade700 : item.baseColor),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),

          // Амінокислоти всередині плитки ФА
          if (item.aminoMap != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAminoLabel('Leu', item.aminoMap!['Leu']!),
                      const SizedBox(height: 2),
                      _buildAminoLabel('Met', item.aminoMap!['Met']!),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAminoLabel('Tyr', item.aminoMap!['Tyr']!),
                      const SizedBox(height: 2),
                      _buildAminoLabel('Les', item.aminoMap!['Les']!),
                    ],
                  ),
                ],
              ),
            )
          else
            const Spacer(),

          // Значення та Ціль
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: currentStr,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: statusColor),
                  ),
                  if (hasTarget)
                    TextSpan(
                      text: ' / $targetStr ${item.unit}',
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                    )
                  else
                    TextSpan(
                      text: ' ${item.unit}',
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                    ),
                ],
              ),
            ),
          ),

          // Прогрес-бар (відображаємо тільки якщо встановлено ціль)
          if (hasTarget)
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: item.progress,
                backgroundColor: isExceeded ? Colors.red.shade100 : item.baseColor.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                minHeight: 4,
              ),
            )
          else
            const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildAminoLabel(String name, double val) {
    final String valStr = val % 1 == 0 ? val.toInt().toString() : val.toStringAsFixed(1);
    return Text(
      '$name: $valStr',
      style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600, color: Colors.purple.shade800),
    );
  }
}
