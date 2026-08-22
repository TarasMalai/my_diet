// ============================================================================
// ВУЗОЛ: ВЕРХНЯ ПАНЕЛЬ ЕКРАНА ДЕТАЛЕЙ ХАРЧУВАННЯ (FOOD DETAILS APP BAR)
// Файл: lib/widgets/food_details_screen/food_details_app_bar_widget.dart
// ============================================================================

import 'package:flutter/material.dart';

/// Кастомна верхня панель (AppBar) для екрана деталей харчування.
/// Реалізує [PreferredSizeWidget], що дозволяє передавати її у властивість `appBar` віджета `Scaffold`.
class FoodDetailsAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  /// Заголовок екрана (за замовчуванням 'Деталі харчування')
  final String title;

  /// Колбек для обробки натискання кнопки "Експорт"
  final VoidCallback? onExport;

  /// Колбек для обробки натискання кнопки "Налаштування"
  final VoidCallback? onSettings;

  const FoodDetailsAppBarWidget({super.key, this.title = 'Деталі харчування', this.onExport, this.onSettings});

  // --------------------------------------------------------------------------
  // ОБОБОВ'ЯЗКОВА ПЕРЕВИЗНАЧЕНА ВЛАСТИВІСТЬ ДЛЯ PreferredSizeWidget
  // --------------------------------------------------------------------------
  // Вказує Flutter'у фіксовану стандартну висоту для AppBar (kToolbarHeight = 56.0 логічних пікселів)
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  // --------------------------------------------------------------------------
  // МЕТОД ПОБУДОВИ ВІДЖЕТА (build)
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,

      // Вимикаємо автоматичне створення кнопки "Назад", щоб мати повний контроль над її виглядом та поведінкою
      automaticallyImplyLeading: false,

      // ----------------------------------------------------------------------
      // ВУЗОЛ 1: КНОПКА "НАЗАД"
      // ----------------------------------------------------------------------
      // `leading` відповідає за ліву частину AppBar
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        // Navigator.of(context).pop() закриває поточний екран і повертає на головний
        onPressed: () => Navigator.of(context).pop(),
        tooltip: 'Назад',
      ),

      // ----------------------------------------------------------------------
      // ВУЗОЛ 2: ЗАГОЛОВОК ЕКРАНА
      // ----------------------------------------------------------------------
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

      // ----------------------------------------------------------------------
      // ВУЗОЛ 3: ВИРИНАЮЧЕ МЕНЮ ОПЦІЙ (3 КРАПКИ)
      // ----------------------------------------------------------------------
      // `actions` відповідає за праву частину AppBar (масив віджетів)
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (String value) {
            if (value == 'export' && onExport != null) {
              onExport!();
            } else if (value == 'settings' && onSettings != null) {
              onSettings!();
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'export',
              child: Row(
                children: [
                  Icon(Icons.share, size: 20, color: Colors.black54),
                  SizedBox(width: 12),
                  Text('Експортувати'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings, size: 20, color: Colors.black54),
                  SizedBox(width: 12),
                  Text('Налаштування'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
