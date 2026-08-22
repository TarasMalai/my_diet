// ============================================================================
// НАЗВА ФАЙЛУ: app_drawer_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Виринаюче бокове меню (Drawer), яке викликається кнопкою
//              «гамбургер» з верхньої панелі (MainAppBarWidget).
// ============================================================================

import 'package:flutter/material.dart';

// ----------------------------------------------------------------------------
// 1. ГОЛОВНИЙ КЛАС БОКОВОГО МЕНЮ (AppDrawerWidget)
// ----------------------------------------------------------------------------
class AppDrawerWidget extends StatelessWidget {
  const AppDrawerWidget({super.key});

  // --------------------------------------------------------------------------
  // ВУЗОЛ 1.1: ВІЗУАЛЬНИЙ КАРКАС МЕНЮ (BUILD)
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Прибираємо відступи за замовчуванням у ListView
        padding: EdgeInsets.zero,
        children: [
          // ------------------------------------------------------------------
          // ВУЗОЛ 1.1.1: ШАПКА МЕНЮ (Header)
          // ------------------------------------------------------------------
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Меню проекту',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Керування дієтою та профілем', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),

          // ------------------------------------------------------------------
          // ВУЗОЛ 1.1.2: ПУНКТИ МЕНЮ (Items)
          // ------------------------------------------------------------------
          // Пункт 1: Налаштування
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Налаштування'),
            onTap: () {
              // Дія при натисканні на налаштування
              Navigator.pop(context); // Закриваємо меню
              debugPrint('Натиснуто: Налаштування');
            },
          ),

          // Пункт 2: Профіль сина (або сімейна підписка)
          ListTile(
            leading: const Icon(Icons.family_restroom),
            title: const Text('Сімейний доступ'),
            onTap: () {
              Navigator.pop(context);
              debugPrint('Натиснуто: Сімейний доступ');
            },
          ),

          // Пункт 3: Про програму
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Про програму'),
            onTap: () {
              Navigator.pop(context);
              debugPrint('Натиснуто: Про програму');
            },
          ),
        ],
      ),
    );
  }
}
