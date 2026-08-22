// ============================================================================
// НАЗВА ФАЙЛУ: daily_summary_widget.dart
// ПРИЗНАЧЕННЯ: Віджет блоку "Баланс за день" на головному екрані
// ============================================================================

import 'package:flutter/material.dart';

import '../../services/date_service.dart';
import '../../services/diet_state_service.dart';
import '../../services/mock_diet_repository.dart';
import 'daily_summary_widget/metric_card_widget.dart';

class DailySummaryWidget extends StatefulWidget {
  final VoidCallback onTapDetails;

  const DailySummaryWidget({super.key, required this.onTapDetails});

  @override
  State<DailySummaryWidget> createState() => _DailySummaryWidgetState();
}

class _DailySummaryWidgetState extends State<DailySummaryWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // 1. Слухаємо зміну обраної дати
    return ValueListenableBuilder<DateTime>(
      valueListenable: DateService().selectedDate,
      builder: (context, currentDate, child) {
        // 2. Отримуємо прийоми їжі за обрану дату
        final meals = MockDietRepository().getMealsForDate(currentDate);

        // 3. Підраховуємо фактично спожиті нутрієнти
        double totalPhe = 0;
        double totalCalories = 0;
        double totalProtein = 0;
        double totalCarbs = 0;
        double totalFat = 0;

        for (var meal in meals) {
          totalPhe += meal.totalPhe;
          totalCalories += meal.totalCalories;
          totalProtein += meal.totalProtein;
          totalCarbs += meal.totalCarbs;
          totalFat += meal.totalFat;
        }

        // 4. Формуємо список показників
        final List<NutrientItem> itemsList = [
          NutrientItem(
            label: 'Фенілаланін',
            current: totalPhe,
            target: 300,
            unit: 'ФА',
            baseColor: Colors.purple,
            icon: Icons.science,
          ),
          NutrientItem(
            label: 'Калорії',
            current: totalCalories,
            target: 2000,
            unit: 'ккал',
            baseColor: Colors.orange,
            icon: Icons.local_fire_department,
          ),
          NutrientItem(
            label: 'Білки',
            current: totalProtein,
            target: 50,
            unit: 'г',
            baseColor: Colors.blue,
            icon: Icons.fitness_center,
          ),
          NutrientItem(
            label: 'Вуглеводи',
            current: totalCarbs,
            target: 250,
            unit: 'г',
            baseColor: Colors.amber,
            icon: Icons.grain,
          ),
          NutrientItem(
            label: 'Жири',
            current: totalFat,
            target: 70,
            unit: 'г',
            baseColor: Colors.redAccent,
            icon: Icons.opacity,
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
              // Шапка блоку "Баланс за день"
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

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Червоний баннер при перевищенні будь-якого ліміту
                    if (hasAnyExceeded)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 10.0),
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8.0)),
                        child: const Text(
                          'Увага: ліміти перевищено!',
                          style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // Список карток показників (метрики)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _isExpanded ? itemsList.length : itemsList.take(2).length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        return MetricCardWidget(item: itemsList[index]);
                      },
                    ),

                    const SizedBox(height: 4),

                    // Кнопка показати всі / згорнути
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
  }
}
