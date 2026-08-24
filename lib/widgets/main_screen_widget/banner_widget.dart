// ============================================================================
// НАЗВА ФАЙЛУ: banner_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Інформаційно-мотиваційний банер для головного екрана.
//              Призначений для відображення підказок, порад дня
//              або важливих сповіщень.
// ============================================================================

import 'package:flutter/material.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: ГОЛОВНИЙ КЛАС ВІДЖЕТА (BannerWidget)
// ----------------------------------------------------------------------------
/// Віджет банера на головному екрані.
/// [ВУЗОЛ 1.0: StatelessWidget]
/// Приймає параметри тексту та дії при натисканні.
class BannerWidget extends StatelessWidget {
  /// Заголовок банера (наприклад, "Порада дня")
  final String title;

  /// Основний текст/підзаголовок банера
  final String subtitle;

  /// Іконка банера
  final IconData icon;

  /// Дія при натисканні на банер (необов'язкова)
  final VoidCallback? onTap;

  const BannerWidget({
    super.key,
    this.title = 'Порада дня',
    this.subtitle = 'Не забувайте пити достатню кількість води та стежити за балансом БЖВ!',
    this.icon = Icons.lightbulb_outline_rounded,
    this.onTap,
  });

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.1]: ВІЗУАЛЬНИЙ КАРКАС (BUILD)
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          gradient: LinearGradient(
            colors: [Colors.teal.shade400, Colors.teal.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // ------------------------------------------------------------
                // [ВУЗОЛ 1.1.1]: ІКОНКА БАНЕРА
                // ------------------------------------------------------------
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                  child: Icon(icon, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),

                // ------------------------------------------------------------
                // [ВУЗОЛ 1.1.2]: ТЕКСТОВИЙ БЛОК (Заголовок та підзаголовок)
                // ------------------------------------------------------------
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xE6FFFFFF), // 90% білий колір для const
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
