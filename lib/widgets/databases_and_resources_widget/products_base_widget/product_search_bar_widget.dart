// ============================================================================
// НАЗВА ФАЙЛУ: product_search_bar_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Окремий віджет пошукового рядка для фільтрації продуктів.
// ШЛЯХ: lib/widgets/databases_and_resources_widget/products_base_widget/product_search_bar_widget.dart
// ============================================================================

import 'package:flutter/material.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: ВІДЖЕТ ПОШУКУ ПРОДУКТІВ (ProductSearchBarWidget)
// ----------------------------------------------------------------------------
class ProductSearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const ProductSearchBarWidget({super.key, required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: controller,
        onChanged: (_) => onChanged(),
        decoration: InputDecoration(
          hintText: 'Пошук продукту або категорії...',
          prefixIcon: const Icon(Icons.search, color: Colors.green),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.green.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.green.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.green.shade700, width: 2),
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    controller.clear();
                    onChanged();
                  },
                )
              : null,
        ),
      ),
    );
  }
}
