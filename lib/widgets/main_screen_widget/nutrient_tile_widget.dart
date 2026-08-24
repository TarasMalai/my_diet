// ============================================================================
// НАЗВА ФАЙЛУ: nutrient_tile_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Плитка відображення додаткових показників (Волокна, Вода, БЖУ...)
// ============================================================================

import 'package:flutter/material.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: ГОЛОВНИЙ КЛАС ВІДЖЕТА ПЛИТКИ ПОКАЗНИКА (NutrientTileWidget)
// ----------------------------------------------------------------------------
class NutrientTileWidget extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final String emoji;
  final Color color;

  const NutrientTileWidget({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.emoji,
    required this.color,
  });

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2]: ВІЗУАЛЬНИЙ КАРКАС ТА СТРУКТУРА ПЛИТКИ (BUILD)
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          // ------------------------------------------------------------------
          // [ВУЗОЛ 2.1]: ЕМОДЗІ-ІКОНКА ПОКАЗНИКА
          // ------------------------------------------------------------------
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),

          // ------------------------------------------------------------------
          // [ВУЗОЛ 2.2]: ТЕКСТОВИЙ БЛОК (НАЗВА ТА ЗНАЧЕННЯ З ОДИНИЦЕЮ ВИМІРУ)
          // ------------------------------------------------------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: value,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      TextSpan(
                        text: ' $unit',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
