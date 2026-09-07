// ============================================================================
// НАЗВА ФАЙЛУ: inventory_screen.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Екран управління інвентарем (Інвентар) із вибором продуктів із Головної бази
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/models/pantry_item_model.dart';
import 'package:my_diet/models/product_model.dart';
import 'package:my_diet/repositories/product_repository.dart';
import 'package:my_diet/services/pantry_service.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final PantryService _pantryService = PantryService();

  void _refresh() {
    setState(() {});
  }

  /// Відкрити діалог вибору продукту з Головної бази для додавання в Інвентар
  void _showAddFromDatabaseDialog(BuildContext context) async {
    // Завантажуємо продукти з головної бази
    List<ProductModel> products = [];
    try {
      products = await ProductRepository().loadProducts();
    } catch (_) {}

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return _AddPantryItemDialog(
          allProducts: products,
          onItemAdded: () {
            _refresh();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _pantryService.getItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Інвентар (Наявні продукти)'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.kitchen_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text('Інвентар порожній', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  const Text(
                    'Додайте продукти з бази, щоб відстежувати залишки',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      'Залишок у хаті: ${item.weightInGram} г  |  ФА: ${item.phe.toStringAsFixed(1)} мг/100г',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        _pantryService.removeItem(item.id);
                        _refresh();
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFromDatabaseDialog(context),
        backgroundColor: Colors.teal.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

/// Внутрішній віджет-діалог для пошуку по базі та введення ваги в інвентарі
class _AddPantryItemDialog extends StatefulWidget {
  final List<ProductModel> allProducts;
  final VoidCallback onItemAdded;

  const _AddPantryItemDialog({required this.allProducts, required this.onItemAdded});

  @override
  State<_AddPantryItemDialog> createState() => _AddPantryItemDialogState();
}

class _AddPantryItemDialogState extends State<_AddPantryItemDialog> {
  ProductModel? _selectedProduct;
  final _weightController = TextEditingController();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Додати з бази в Інвентар'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Пошук по продуктах
            Autocomplete<ProductModel>(
              displayStringForOption: (ProductModel option) => option.name,
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<ProductModel>.empty();
                }
                return widget.allProducts.where(
                  (p) => p.name.toLowerCase().contains(textEditingValue.text.toLowerCase()),
                );
              },
              onSelected: (ProductModel selection) {
                setState(() {
                  _selectedProduct = selection;
                });
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(labelText: 'Пошук продукту з бази', prefixIcon: Icon(Icons.search)),
                );
              },
            ),
            const SizedBox(height: 16),
            if (_selectedProduct != null) ...[
              Text(
                'Вибрано: ${_selectedProduct!.name}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Загальна вага вдома (грам)',
                  hintText: 'наприклад, 2000 (для 2 кг)',
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Скасувати')),
        ElevatedButton(
          onPressed: _selectedProduct == null
              ? null
              : () {
                  final weight = double.tryParse(_weightController.text.replaceAll(',', '.')) ?? 0.0;
                  if (weight > 0) {
                    final pantryItem = PantryItemModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      productId: _selectedProduct!.id,
                      name: _selectedProduct!.name,
                      weightInGram: weight,
                      phe: _selectedProduct!.phe,
                      calories: _selectedProduct!.calories,
                      protein: _selectedProduct!.protein,
                      carbs: _selectedProduct!.carbs,
                      fat: _selectedProduct!.fat,
                      leucine: _selectedProduct!.leucine,
                      tyrosine: _selectedProduct!.tyrosine,
                      methionine: _selectedProduct!.methionine,
                      lysine: _selectedProduct!.lysine,
                      fiber: _selectedProduct!.fiber,
                      salt: _selectedProduct!.salt,
                      sugar: _selectedProduct!.sugar,
                      water: _selectedProduct!.water,
                      energy: _selectedProduct!.energy,
                    );

                    PantryService().saveItem(pantryItem);
                    widget.onItemAdded();
                    Navigator.pop(context);
                  }
                },
          child: const Text('Зберегти в Інвентар'),
        ),
      ],
    );
  }
}
