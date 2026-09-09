// ============================================================================
// НАЗВА ФАЙЛУ: cooking_ingredients_list_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Віджет списку доданих інгредієнтів у страві або порожнього стану
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/models/food_item_model.dart';

class CookingIngredientsListWidget extends StatelessWidget {
  final List<FoodItemModel> ingredients;
  final Function(String id) onDelete;

  const CookingIngredientsListWidget({super.key, required this.ingredients, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (ingredients.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.soup_kitchen_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text('Ця страва ще порожня', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            const Text('Додайте інгредієнти нижче', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        final item = ingredients[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Вага: ${item.weight} г  |  ФА: ${item.phe.toStringAsFixed(1)} мг'),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => onDelete(item.id),
            ),
          ),
        );
      },
    );
  }
}
