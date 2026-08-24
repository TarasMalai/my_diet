// ============================================================================
// НАЗВА ФАЙЛУ: main_app_bar_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Верхня панель (AppBar) головного екрана...
// ============================================================================

import 'package:flutter/material.dart';

// ----------------------------------------------------------------------------
// ВУЗОЛ 1: ІМПОРТИ ВІДЖЕТІВ ТА МОДУЛІВ
// ----------------------------------------------------------------------------
// Імпортуємо наше бокове меню, щоб верхня панель знала про його існування

// ----------------------------------------------------------------------------
// 2. ГОЛОВНИЙ КЛАС ВІДЖЕТА ВЕРХНЬОЇ ПАНЕЛІ (MainAppBarWidget)
// ----------------------------------------------------------------------------
class MainAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBarWidget({super.key});

  // --------------------------------------------------------------------------
  // ВУЗОЛ 2.1: ВІЗУАЛЬНИЙ КАРКАС ПАНЕЛІ (BUILD)
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Моя дієта',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      centerTitle: true,
      backgroundColor: Colors.green,
      automaticallyImplyLeading: false,

      // ----------------------------------------------------------------------
      // ВУЗОЛ 2.1.1: ДІЇ У ПРАВІЙ ЧАСТИНІ ПАНЕЛІ (Actions)
      // ----------------------------------------------------------------------
      actions: [
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          tooltip: 'Відкрити меню',
          onPressed: () {
            // КОМЕНТАР: Команда Scaffold.of(context).openEndDrawer() наказує
            // екрану відкрити бокове меню з правого боку (або відкрити звичний Drawer).
            // Але щоб це працювало коректно на рівні Scaffold, ми викликаємо
            // Scaffold.of(context).openDrawer() або передаємо властивість Scaffold.
            Scaffold.of(context).openEndDrawer();
            debugPrint('Натиснуто кнопку меню: відкриваємо бокову панель');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
