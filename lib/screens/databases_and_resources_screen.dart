// ============================================================================
// НАЗВА ФАЙЛУ: databases_and_resources_screen.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Екран «Бази та Ресурси». Виступає як хаб для управління
//              інвентарем, готуванням страв, доступу до баз продуктів
//              та корисних посилань.
// ============================================================================

import 'package:flutter/material.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: ІМПОРТИ ВІДЖЕТІВ (Закоментовані до моменту створення файлів)
// ----------------------------------------------------------------------------
// Згодом ми розкоментуємо їх, коли створимо відповідні файли у папці
// lib/widgets/databases_and_resources/
// import '../widgets/databases_and_resources/inventory_widget.dart';
// import '../widgets/databases_and_resources/cooking_widget.dart';
// import '../widgets/databases_and_resources/products_base_widget.dart';
// import '../widgets/databases_and_resources/useful_links_widget.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 2]: ГОЛОВНИЙ КЛАС ЕКРАНУ (DatabasesAndResourcesScreen)
// ----------------------------------------------------------------------------
/// Головний екран-хаб для доступу до баз даних, ресурсів та модулів готування.
/// [ВУЗОЛ 2.0: StatelessWidget]
/// Використовується, оскільки екран є статичним контейнером-провідником
/// і показує готові модулі віджетів.
class DatabasesAndResourcesScreen extends StatelessWidget {
  const DatabasesAndResourcesScreen({super.key});

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.1]: ВІЗУАЛЬНИЙ КАРКАС ЕКРАНУ (BUILD)
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ----------------------------------------------------------------------
      // [ВУЗОЛ 2.1.1]: ВЕРХНЯ ПАНЕЛЬ (AppBar)
      // ----------------------------------------------------------------------
      appBar: AppBar(
        title: const Text('Бази та Ресурси', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      // ----------------------------------------------------------------------
      // [ВУЗОЛ 2.1.2]: ОСНОВНИЙ КОНТЕНТ (Body зі скролом)
      // ----------------------------------------------------------------------
      body: SingleChildScrollView(
        // [ВУЗОЛ 2.1.2.1: SingleChildScrollView]
        // Гарантує прокрутку екрана, якщо контент не вміщується за висотою.
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --------------------------------------------------------------
              // [ВУЗОЛ 2.1.2.2]: СЕКЦІЯ 1 - ОПЕРАТИВНІ ІНСТРУМЕНТИ
              // --------------------------------------------------------------
              _buildSectionTitle('Управління та Склад', Icons.handyman),
              const SizedBox(height: 12),
              // Тут буде InventoryWidget()
              _buildPlaceholderTile('Інвентар (Наявні продукты)', Colors.green),
              const SizedBox(height: 12),
              // Тут буде CookingWidget()
              _buildPlaceholderTile('Кухня (Готування страв)', Colors.orange),

              const SizedBox(height: 24),

              // --------------------------------------------------------------
              // [ВУЗОЛ 2.1.2.3]: СЕКЦІЯ 2 - ДОВІДНИКИ ТА БАЗИ ДАНИХ
              // --------------------------------------------------------------
              _buildSectionTitle('Бази Даних', Icons.storage),
              const SizedBox(height: 12),
              // Тут буде ProductsBaseWidget()
              _buildPlaceholderTile('База продуктів та напівфабрикатів', Colors.blue),
              const SizedBox(height: 12),
              // Тут буде RecipesBaseWidget()
              _buildPlaceholderTile('Мої збережені рецепти', Colors.purple),

              const SizedBox(height: 24),

              // --------------------------------------------------------------
              // [ВУЗОЛ 2.1.2.4]: СЕКЦІЯ 3 - КОРИСНІ РЕСУРСИ
              // --------------------------------------------------------------
              _buildSectionTitle('Корисні ресурси', Icons.language),
              const SizedBox(height: 12),
              // Тут буде UsefulLinksWidget()
              _buildPlaceholderTile('YouTube канали та Інститути', Colors.redAccent),

              const SizedBox(height: 40), // Відступ знизу для зручного скролу
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 3]: ДОПОМІЖНІ МЕТОДИ ГЕНЕРАЦІЇ UI (Тимчасові заглушки)
  // --------------------------------------------------------------------------

  /// [ВУЗОЛ 3.1: _buildSectionTitle]
  /// Метод для генерації уніфікованих заголовків секцій з іконкою.
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

  /// [ВУЗОЛ 3.2: _buildPlaceholderTile]
  /// Метод для генерації тимчасових карток-заглушок (доки не підключені фінальні віджети).
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
