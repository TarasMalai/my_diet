// ============================================================================
// НАЗВА ФАЙЛУ: main_screen.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Головний робочий екран додатку (Dashboard). Містить календар,
//              зведену інформацію за день, зарезервовані блоки для повідомлень,
//              а також виклик віджета переходу до хабу «Бази та Ресурси».
// ============================================================================

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: ІМПОРТИ СИСТЕМНИХ ПАКЕТІВ ТА СЕРВІСІВ
// ----------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:my_diet/services/navigation_service.dart';
import 'package:my_diet/services/date_service.dart'; // Глобальний сервіс управління датою
import 'package:my_diet/services/mock_diet_repository.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1.1]: ІМПОРТИ МОДУЛЬНИХ ВІДЖЕТІВ
// ----------------------------------------------------------------------------
import 'package:my_diet/widgets/main_screen_widget/daily_summary_widget.dart';
import 'package:my_diet/widgets/main_screen_widget/main_app_bar_widget.dart';
import 'package:my_diet/widgets/main_screen_widget/main_app_bar_widget/app_drawer_widget.dart';
import 'package:my_diet/widgets/common_widget/calendar_widget.dart';
import 'package:my_diet/widgets/main_screen_widget/family_notes_widget.dart';
import 'package:my_diet/widgets/main_screen_widget/databases_navigation_tile_widget.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 2]: ГОЛОВНИЙ КЛАС ЕКРАНУ (MainScreen)
// ----------------------------------------------------------------------------
/// Головний екран системи, підписаний на глобальний сервіс дати DateService
/// та репозиторій даних MockDietRepository.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

// ----------------------------------------------------------------------------
// [ВУЗОЛ 2.1]: СТАН ЕКРАНУ (_MainScreenState)
// ----------------------------------------------------------------------------
class _MainScreenState extends State<MainScreen> {
  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.1.1]: ВІЗУАЛЬНИЙ КАРКАС ЕКРАНУ (BUILD)
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ----------------------------------------------------------------------
      // [ВУЗОЛ 2.1.1.1]: ВЕРХНЯ ПАНЕЛЬ (AppBar)
      // ----------------------------------------------------------------------
      appBar: const MainAppBarWidget(),

      // ----------------------------------------------------------------------
      // [ВУЗОЛ 2.1.1.2]: ПРАВЕ ВИРИНАЮЧЕ МЕНЮ (EndDrawer)
      // ----------------------------------------------------------------------
      endDrawer: const AppDrawerWidget(),

      // ----------------------------------------------------------------------
      // [ВУЗОЛ 2.1.1.3]: ОСНОВНА РОБОЧА ОБЛАСЬ (Body)
      // ----------------------------------------------------------------------
      body: ValueListenableBuilder<int>(
        // [ВУЗОЛ 2.1.1.3.1: Слухач репозиторію]
        // Реагує на лічильник оновлень репозиторію для автоматичного перемальовування
        // даних при поверненні з деталей харчування або зміні списку продуктів.
        valueListenable: MockDietRepository().listenable,
        builder: (context, _, child) {
          return ValueListenableBuilder<DateTime>(
            // [ВУЗОЛ 2.1.1.3.2: Слухач глобальної дати]
            // Підписка на DateService. Зміна дати в кастомному календарі
            // миттєво сповіщає весь інтерфейс для завантаження відповідних даних.
            valueListenable: DateService().selectedDate,
            builder: (context, currentDate, child) {
              return SingleChildScrollView(
                // [ВУЗОЛ 2.1.1.3.3: Вертикальний скрол]
                // Запобігає помилкам переповнення екрана (Overflow) на пристроях із малим дозволом.
                child: Column(
                  children: [
                    // --------------------------------------------------------
                    // [ВУЗОЛ 2.1.1.3.4]: ВІДЖЕТ КАЛЕНДАРЯ
                    // --------------------------------------------------------
                    CalendarWidget(
                      selectedDate: currentDate,
                      onDateSelected: (newDate) {
                        // Оновлюємо глобальну дату через сервіс-одинак (Singleton)
                        DateService().updateDate(newDate);
                      },
                    ),

                    const SizedBox(height: 8),

                    // --------------------------------------------------------
                    // [ВУЗОЛ 2.1.1.3.5]: ВІДЖЕТ НУТРІЄНТІВ ТА СУМІШЕЙ ЗА ДЕНЬ
                    // --------------------------------------------------------
                    DailySummaryWidget(
                      onTapDetails: () {
                        // Передаємо контекст у сервіс навігації для переходу на екран деталей
                        NavigationService.navigateToFoodDetails(context);
                      },
                    ),

                    const SizedBox(height: 12),

                    // --------------------------------------------------------
                    // [ВУЗОЛ 2.1.1.3.6]: СТРІЧКА ПОВІДОМЛЕНЬ ТА НОТАТОК
                    // --------------------------------------------------------
                    const FamilyNotesWidget(),

                    const SizedBox(height: 16),

                    // --------------------------------------------------------
                    // [ВУЗОЛ 2.1.1.3.7]: ПЕРЕХІД ДО ЕКРАНУ «БАЗИ ТА РЕСУРСИ»
                    // --------------------------------------------------------
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
      // [ВУЗОЛ 2.1.1.4]: ФІКСОВАНИЙ НИЖНІЙ БАНЕР (Bottom Navigation Bar)
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
          // [ВУЗОЛ 2.1.1.4.1: Безпечна зона]
          // Гарантує, що вміст не перекривається кнопками навігації чи вирізами Android/iOS.
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
