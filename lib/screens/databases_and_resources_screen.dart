// ============================================================================
// НАЗВА ФАЙЛУ: databases_and_resources_screen.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Екран «Бази та Ресурси». Виступає як хаб для управління
//              інвентарем, готуванням страв, доступу до баз продуктів
//              та корисних посилань.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/widgets/databases_and_resources_widget/products_base_widget.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 2]: ГОЛОВНИЙ КЛАС ЕКРАНУ (DatabasesAndResourcesScreen)
// ----------------------------------------------------------------------------
class DatabasesAndResourcesScreen extends StatelessWidget {
  const DatabasesAndResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Бази та Ресурси', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --------------------------------------------------------------
              // СЕКЦІЯ 1 - ОПЕРАТИВНІ ІНСТРУМЕНТИ
              // --------------------------------------------------------------
              _buildSectionTitle('Управління та Склад', Icons.handyman),
              const SizedBox(height: 12),
              _buildPlaceholderTile('Інвентар (Наявні продукти)', Colors.green),
              const SizedBox(height: 12),
              _buildPlaceholderTile('Кухня (Готування страв)', Colors.orange),

              const SizedBox(height: 24),

              // --------------------------------------------------------------
              // СЕКЦІЯ 2 - ДОВІДНИКИ ТА БАЗИ ДАНИХ
              // --------------------------------------------------------------
              _buildSectionTitle('Бази Даних', Icons.storage),
              const SizedBox(height: 12),

              // Прив'язуємо перехід до нашої бази продуктів
              _buildPlaceholderTile(
                'База продуктів та напівфабрикатів',
                Colors.blue,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductsBaseWidget()));
                },
              ),

              const SizedBox(height: 12),
              _buildPlaceholderTile('Мої збережені рецепти', Colors.purple),

              const SizedBox(height: 24),

              // --------------------------------------------------------------
              // СЕКЦІЯ 3 - КОРИСНІ РЕСУРСИ
              // --------------------------------------------------------------
              _buildSectionTitle('Корисні ресурси', Icons.language),
              const SizedBox(height: 12),
              _buildPlaceholderTile('YouTube канали та Інститути', Colors.redAccent),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // ДОПОМІЖНІ МЕТОДИ ГЕНЕРАЦІЇ UI
  // --------------------------------------------------------------------------

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueGrey, size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
        ),
      ],
    );
  }

  /// Оновлений метод плитки з підтримкою натискання (onTap)
  Widget _buildPlaceholderTile(String title, Color color, {VoidCallback? onTap}) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
          ),
        ),
      ),
    );
  }
}
