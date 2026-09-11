// ============================================================================
// НАЗВА ФАЙЛУ: daily_summary_bar_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Панель нутрієнтів з амінокислотами та каруселлю на 3/4 плитки
// ============================================================================

import 'package:flutter/material.dart';

import 'package:my_diet/models/summary_nutrient_item_model.dart';
import 'package:my_diet/services/date_service.dart';
import 'package:my_diet/services/diet_settings_service.dart';
import 'package:my_diet/repositories/diet_repository.dart';
import 'package:my_diet/services/summary_nutrient_factory.dart';
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

  @override
  Widget build(BuildContext context) {
    final settings = DietSettingsService();

    return ValueListenableBuilder<int>(
      valueListenable: DietRepository().listenable,
      builder: (context, _, child) {
        return ValueListenableBuilder<DateTime>(
          valueListenable: DateService().selectedDate,
          builder: (context, currentDate, child) {
            final meals = DietRepository().getMealsForDate(currentDate);

            // [ВУЗОЛ 1.1]: ОТРИМАННЯ ГОТОВОГО СПИСКУ НУТРІЄНТІВ З ФАБРИКИ
            final List<SummaryNutrientItemModel> items = SummaryNutrientFactory.buildSummaryList(
              meals: meals,
              settings: settings,
            );

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
              color: Colors.white,
              child: SizedBox(
                height: 85,
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
                          if (items.isEmpty) return const SizedBox();

                          // Якщо ширина екрана < 600px (смартфон) — показуємо 3 плитки.
                          // Якщо >= 600px (ПК/планшет) — показуємо 4 плитки.
                          final int targetCount = constraints.maxWidth < 600 ? 3 : 4;
                          final int visibleCount = targetCount > items.length ? items.length : targetCount;

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
