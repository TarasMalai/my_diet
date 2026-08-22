// ============================================================================
// НАЗВА ФАЙЛУ: daily_summary_bar_widget.dart
// ПРИЗНАЧЕННЯ: Панель підсумків нутрієнтів, що автоматично вираховує
//              значення за обрану в DateService дату з MockDietRepository.
// ============================================================================

import 'package:flutter/material.dart';

import '../../services/date_service.dart';
import '../../services/diet_state_service.dart';
import '../../services/mock_diet_repository.dart';

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

  @override
  Widget build(BuildContext context) {
    // 1. Слухаємо зміни в репозиторії для миттєвого оновлення при додаванні продуктів
    return ValueListenableBuilder<int>(
      valueListenable: MockDietRepository().listenable,
      builder: (context, _, child) {
        // 2. Також слухаємо зміну обраної дати
        return ValueListenableBuilder<DateTime>(
          valueListenable: DateService().selectedDate,
          builder: (context, currentDate, child) {
            // Отримуємо прийоми їжі за обрану дату з репозиторію
            final meals = MockDietRepository().getMealsForDate(currentDate);

            // Підраховуємо фактично спожиті нутрієнти за день
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

            // Формуємо актуальний список плиточок нутрієнтів
            final List<NutrientItem> items = [
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

            if (items.isEmpty) return const SizedBox.shrink();

            return Container(
              height: 105,
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              child: Row(
                children: [
                  // Ліва стрілка прокрутки
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.grey, size: 28),
                    onPressed: () => _prev(items.length),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32),
                  ),

                  // Зона відображення цілих плиточок
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double availableWidth = constraints.maxWidth;
                        double cardMinWidth = 120.0;
                        int visibleCount = (availableWidth / cardMinWidth).floor().clamp(1, items.length);

                        List<Widget> visibleCards = [];
                        for (int i = 0; i < visibleCount; i++) {
                          int itemIndex = (_startIndex + i) % items.length;
                          final item = items[itemIndex];

                          visibleCards.add(
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: _buildNutrientTile(item),
                              ),
                            ),
                          );
                        }

                        return Row(children: visibleCards);
                      },
                    ),
                  ),

                  // Права стрілка прокрутки
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.grey, size: 28),
                    onPressed: () => _next(items.length),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Віджет плиточки нутрієнта
  Widget _buildNutrientTile(NutrientItem item) {
    final bool isExceeded = item.isExceeded;

    final Color statusColor = isExceeded ? Colors.red.shade600 : item.baseColor;
    final Color borderColor = isExceeded ? Colors.red.shade300 : item.baseColor.withValues(alpha: 0.3);
    final Color bgColor = isExceeded
        ? Colors.red.shade50.withValues(alpha: 0.3)
        : item.baseColor.withValues(alpha: 0.03);

    final String currentStr = item.current % 1 == 0 ? item.current.toInt().toString() : item.current.toStringAsFixed(1);
    final String targetStr = item.target % 1 == 0 ? item.target.toInt().toString() : item.target.toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: isExceeded ? 1.5 : 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(item.icon, size: 15, color: isExceeded ? Colors.red.shade700 : item.baseColor),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
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
                  if (item.target > 0)
                    TextSpan(
                      text: ' / $targetStr ${item.unit}',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: item.progress,
              backgroundColor: isExceeded ? Colors.red.shade100 : item.baseColor.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}
