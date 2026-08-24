// ============================================================================
// НАЗВА ФАЙЛУ: databases_navigation_tile_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Віджет-плитка швидкого переходу з головного екрана до хабу
//              «Бази та Ресурси» (інвентар, рецепти, посилання тощо).
// ============================================================================

import 'package:flutter/material.dart';
// Імпортуємо екран «Бази та Ресурси», до якого здійснюється навігація
//import '../../screens/databases_and_resources_screen.dart';
import 'package:my_diet/screens/databases_and_resources_screen.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: ГОЛОВНИЙ КЛАС ВІДЖЕТА ПЛИТКИ НАВІГАЦІЇ (DatabasesNavigationTileWidget)
// ----------------------------------------------------------------------------
/// Stateless віджет, що представляє собою інтерактивну картку-плитку з іконкою,
/// заголовком, описом та стрілочкою переходу.
class DatabasesNavigationTileWidget extends StatelessWidget {
  const DatabasesNavigationTileWidget({super.key});

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.1]: ВІЗУАЛЬНИЙ КАРКАС ТА ОБРОБКА НАТИСКАННЯ (BUILD)
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Викликаємо перехід на новий екран хабу за допомогою Navigator
            Navigator.push(context, MaterialPageRoute(builder: (context) => const DatabasesAndResourcesScreen()));
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // ------------------------------------------------------------
                // [ВУЗОЛ 1.1.1]: ІКОНКА РОЗДІЛУ
                // ------------------------------------------------------------
                // Круглий контейнер з іконкою розділу
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.teal.shade700, shape: BoxShape.circle),
                  child: const Icon(Icons.folder_shared, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),

                // ------------------------------------------------------------
                // [ВУЗОЛ 1.1.2]: ТЕКСТОВИЙ БЛОК (ЗАГОЛОВОК ТА ОПИС)
                // ------------------------------------------------------------
                // Текстовий блок: заголовок та підзаголовок опису
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Бази та Ресурси',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Інвентар, готування, рецепти, наукові бази та корисні посилання',
                        style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),

                // ------------------------------------------------------------
                // [ВУЗОЛ 1.1.3]: ІНДИКАТОР ПЕРЕХОДУ (СТРІЛОЧКА)
                // ------------------------------------------------------------
                // Стрілочка вказує на те, що елемент є клікабельним (веде далі)
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.teal),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
