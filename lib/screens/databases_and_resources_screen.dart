// ============================================================================
// НАЗВА ФАЙЛУ: databases_and_resources_screen.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Екран «Бази та Ресурси». Виступає як хаб для управління
//              інвентарем, готуванням страв, доступу до баз продуктів
//              та корисних посилань.
// ============================================================================

import 'package:flutter/material.dart';

// ----------------------------------------------------------------------------
// ВУЗОЛ 1: ІМПОРТИ ВІДЖЕТІВ (Поки що закоментовані, щоб не було помилок)
// ----------------------------------------------------------------------------
// Згодом ми розкоментуємо їх, коли створимо відповідні файли у папці
// lib/widgets/databases_and_resources/
// import '../widgets/databases_and_resources/inventory_widget.dart';
// import '../widgets/databases_and_resources/cooking_widget.dart';
// import '../widgets/databases_and_resources/products_base_widget.dart';
// import '../widgets/databases_and_resources/useful_links_widget.dart';

class DatabasesAndResourcesScreen extends StatelessWidget {
  const DatabasesAndResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ----------------------------------------------------------------------
      // ВУЗОЛ 2: ВЕРХНЯ ПАНЕЛЬ (AppBar)
      // ----------------------------------------------------------------------
      appBar: AppBar(
        title: const Text('Бази та Ресурси', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      // ----------------------------------------------------------------------
      // ВУЗОЛ 3: ОСНОВНИЙ КОНТЕНТ (Body зі скролом)
      // ----------------------------------------------------------------------
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- БЛОК 1: ОПЕРАТИВНІ ІНСТРУМЕНТИ ---
              _buildSectionTitle('Управління та Склад', Icons.handyman),
              const SizedBox(height: 12),
              // Тут буде InventoryWidget()
              _buildPlaceholderTile('Інвентар (Наявні продукти)', Colors.green),
              const SizedBox(height: 12),
              // Тут буде CookingWidget()
              _buildPlaceholderTile('Кухня (Готування страв)', Colors.orange),

              const SizedBox(height: 24),

              // --- БЛОК 2: ДОВІДНИКИ ТА БАЗИ ---
              _buildSectionTitle('Бази Даних', Icons.storage),
              const SizedBox(height: 12),
              // Тут буде ProductsBaseWidget()
              _buildPlaceholderTile('База продуктів та напівфабрикатів', Colors.blue),
              const SizedBox(height: 12),
              // Тут буде RecipesBaseWidget()
              _buildPlaceholderTile('Мої збережені рецепти', Colors.purple),

              const SizedBox(height: 24),

              // --- БЛОК 3: КОРИСНІ ПОСИЛАННЯ ---
              _buildSectionTitle('Корисні ресурси', Icons.language),
              const SizedBox(height: 12),
              // Тут буде UsefulLinksWidget()
              _buildPlaceholderTile('YouTube канали та Інститути', Colors.redAccent),

              const SizedBox(height: 40), // Відступ знизу
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // ВУЗОЛ 4: ДОПОМІЖНІ МЕТОДИ (Тимчасові заглушки для дизайну)
  // --------------------------------------------------------------------------

  /// Метод для генерації заголовків секцій
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

  /// Метод для генерації тимчасових карток-заглушок (доки ми не підключимо віджети)
  Widget _buildPlaceholderTile(String title, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
