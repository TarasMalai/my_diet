// ============================================================================
// НАЗВА ФАЙЛУ: add_cooking_ingredient_dialog_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Діалогове вікно пошуку продукту з бази та вказівки ваги
//              для додавання інгредієнта в кухонний котел (з покращеним пошуком та пріоритетом)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/models/food_item_model.dart';
import 'package:my_diet/models/product_model.dart';
import 'package:my_diet/repositories/product_repository.dart';
import 'package:my_diet/services/cooking_service.dart';

class AddCookingIngredientDialogWidget extends StatefulWidget {
  final VoidCallback onAdded;

  const AddCookingIngredientDialogWidget({super.key, required this.onAdded});

  @override
  State<AddCookingIngredientDialogWidget> createState() => _AddCookingIngredientDialogWidgetState();
}

class _AddCookingIngredientDialogWidgetState extends State<AddCookingIngredientDialogWidget> {
  List<ProductModel> _allProducts = [];
  ProductModel? _selectedProduct;
  final _weightController = TextEditingController();
  final _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _weightController.addListener(_updateState);
  }

  /// Асинхронне завантаження продуктів із загальної бази
  Future<void> _loadProducts() async {
    try {
      final products = await ProductRepository().loadProducts();
      if (mounted) {
        setState(() {
          _allProducts = products;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    _weightController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Знаходимо продукт або за точним вибором, або намагаємося співставити за текстом з поля пошуку
    ProductModel? activeProduct = _selectedProduct;
    if (activeProduct == null && _searchController.text.isNotEmpty) {
      final match = _allProducts.where((p) => p.name.toLowerCase() == _searchController.text.trim().toLowerCase());
      if (match.isNotEmpty) {
        activeProduct = match.first;
      }
    }

    final weight = double.tryParse(_weightController.text.replaceAll(',', '.')) ?? 0.0;
    final bool canAdd = activeProduct != null && weight > 0;

    return AlertDialog(
      title: const Text('Додати інгредієнт у котел'),
      content: SizedBox(
        width: 400,
        child: _isLoading
            ? const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()))
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Віджет автодоповнення для пошуку продукту з пріоритетом на початок рядка
                  Autocomplete<ProductModel>(
                    displayStringForOption: (ProductModel option) => option.name,
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<ProductModel>.empty();
                      }
                      final query = textEditingValue.text.toLowerCase();

                      // Спочатку ті, що починаються з введеного запиту
                      final startsWithQuery = _allProducts.where((p) => p.name.toLowerCase().startsWith(query));
                      // Потім ті, що просто містять в собі рядок
                      final containsQuery = _allProducts.where(
                        (p) => p.name.toLowerCase().contains(query) && !p.name.toLowerCase().startsWith(query),
                      );

                      return [...startsWithQuery, ...containsQuery];
                    },
                    onSelected: (ProductModel selection) {
                      setState(() {
                        _selectedProduct = selection;
                        _searchController.text = selection.name;
                      });
                    },
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      // Синхронізуємо локальний контролер пошуку
                      if (_searchController.text != controller.text && controller.text.isNotEmpty) {
                        _searchController.text = controller.text;
                      }
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        onChanged: (val) {
                          setState(() {
                            _searchController.text = val;
                            // Якщо користувач змінив текст вручну — скидаємо чіткий вибір, щоб перевірити збіг заново
                            if (_selectedProduct != null && _selectedProduct!.name != val) {
                              _selectedProduct = null;
                            }
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Пошук продукту з бази',
                          prefixIcon: Icon(Icons.search),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Поле для введення ваги завжди доступне, якщо введено назву
                  TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Вага сирого інгредієнта (грам)',
                      hintText: 'наприклад, 300',
                    ),
                  ),
                  if (activeProduct != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Знайдено в базі: ${activeProduct.name}',
                      style: const TextStyle(fontSize: 12, color: Colors.green),
                    ),
                  ],
                ],
              ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Скасувати')),
        ElevatedButton(
          onPressed: !canAdd
              ? null
              : () {
                  final foodItem = FoodItemModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: activeProduct!.name,
                    weight: weight,
                    phe: (activeProduct.phe * weight) / 100,
                    calories: (activeProduct.calories * weight) / 100,
                    protein: (activeProduct.protein * weight) / 100,
                    carbs: (activeProduct.carbs * weight) / 100,
                    fat: (activeProduct.fat * weight) / 100,
                    leucine: (activeProduct.leucine * weight) / 100,
                    tyrosine: (activeProduct.tyrosine * weight) / 100,
                    methionine: (activeProduct.methionine * weight) / 100,
                    lysine: (activeProduct.lysine * weight) / 100,
                    fiber: (activeProduct.fiber * weight) / 100,
                    salt: (activeProduct.salt * weight) / 100,
                    sugar: (activeProduct.sugar * weight) / 100,
                    water: (activeProduct.water * weight) / 100,
                    energy: (activeProduct.energy * weight) / 100,
                  );

                  CookingService().addIngredient(foodItem);
                  widget.onAdded();
                  Navigator.pop(context);
                },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade800, foregroundColor: Colors.white),
          child: const Text('Додати в котел'),
        ),
      ],
    );
  }
}
