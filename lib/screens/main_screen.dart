// ============================================================================
// НАЗВА ФАЙЛУ: main_screen.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Головний робочий екран додатку (Dashboard). Містить календар,
//              зведену інформацію за день, зарезервовані блоки для повідомлень,
//              а також виклик віджета переходу до хабу «Бази та Ресурси».
// ============================================================================

import 'package:flutter/material.dart';
import '../screens/food_details_screen.dart';
import '../services/navigation_service.dart';
// [НОВИЙ ІМПОРТ]: Сервіс глобального управління датою
import '../services/date_service.dart';
import '../widgets/main_screen_widget/daily_summary_widget.dart';

// ----------------------------------------------------------------------------
// ВУЗОЛ 1: ІМПОРТИ ВІДЖЕТІВ ТА МОДУЛІВ
// ----------------------------------------------------------------------------
import '../widgets/main_screen_widget/main_app_bar_widget.dart';
import '../widgets/main_screen_widget/main_app_bar_widget/app_drawer_widget.dart';
import '../widgets/common_widget/calendar_widget.dart';
import '../services/mock_diet_repository.dart';
import '../widgets/main_screen_widget/family_notes_widget.dart';
import '../widgets/main_screen_widget/databases_navigation_tile_widget.dart';

// ----------------------------------------------------------------------------
// 2. ГОЛОВНИЙ КЛАС ЕКРАНУ (MainScreen)
// ----------------------------------------------------------------------------
/// Головний екран системи, підписаний на глобальний сервіс дати DateService.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // --------------------------------------------------------------------------
  // ВУЗОЛ 2.1: ВІЗУАЛЬНИЙ КАРКАС ЕКРАНУ (BUILD)
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ----------------------------------------------------------------------
      // ВУЗОЛ 2.1.1: ВЕРХНЯ ПАНЕЛЬ (AppBar)
      // ----------------------------------------------------------------------
      appBar: const MainAppBarWidget(),

      // ----------------------------------------------------------------------
      // ВУЗОЛ 2.1.2: ПРАВЕ ВИРИНАЮЧЕ МЕНЮ (EndDrawer)
      // ----------------------------------------------------------------------
      endDrawer: const AppDrawerWidget(),

      // ----------------------------------------------------------------------
      // ВУЗОЛ 2.1.3: ОСНОВНА РОБОЧА ОБЛАСЬ (Body)
      // ----------------------------------------------------------------------
      body: ValueListenableBuilder<int>(
        // Слухаємо зміни в репозиторії для миттєвого оновлення при поверненні
        valueListenable: MockDietRepository().listenable,
        builder: (context, _, child) {
          return ValueListenableBuilder<DateTime>(
            // Також підписуємося на глобальну дату з DateService
            valueListenable: DateService().selectedDate,
            builder: (context, currentDate, child) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // ------------------------------------------------------------
                    // ВУЗОЛ 2.1.3.1: ВІДЖЕТ КАЛЕНДАРЯ
                    // ------------------------------------------------------------
                    CalendarWidget(
                      selectedDate: currentDate,
                      onDateSelected: (newDate) {
                        // Оновлюємо глобальну дату через сервіс
                        DateService().updateDate(newDate);
                      },
                    ),

                    const SizedBox(height: 8),

                    // ------------------------------------------------------------
                    // ВУЗОЛ 2.1.3.2: ВІДЖЕТ НУТРІЄНТІВ ТА СУМІШЕЙ ЗА ДЕНЬ
                    // ------------------------------------------------------------
                    DailySummaryWidget(
                      onTapDetails: () {
                        // Передаємо актуальну глобальну дату у сервіс навігації
                        NavigationService.navigateToFoodDetails(context);
                      },
                    ),

                    const SizedBox(height: 12),

                    // ------------------------------------------------------------
                    // ВУЗОЛ 2.1.3.3: СТРІЧКА ПОВІДОМЛЕНЬ ТА НОТАТОК
                    // ------------------------------------------------------------
                    const FamilyNotesWidget(),

                    const SizedBox(height: 16),

                    // ------------------------------------------------------------
                    // ВУЗОЛ 2.1.3.4: ПЕРЕХІД ДО ЕКРАНУ «БАЗИ ТА РЕСУРСИ»
                    // ------------------------------------------------------------
                    const DatabasesNavigationTileWidget(),

                    const SizedBox(height: 100),
                  ],
                ),
              );
            },
          );
        },
      ),
      // ----------------------------------------------------------------------
      // ВУЗОЛ 2.1.4: ФІКСОВАНИЙ НИЖНІЙ БАНЕР (Bottom Navigation Bar)
      // ----------------------------------------------------------------------
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, -2)),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Icon(Icons.campaign_outlined, color: Colors.orange.shade800, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Тут резервується місце для системних сповіщень чи реклами',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
