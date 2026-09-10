// ============================================================================
// НАЗВА ФАЙЛУ: add_cooking_ingredient_dialog_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Діалогове вікно пошуку інгредієнта з Інвентарю та Бази продуктів
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/models/food_item_model.dart';
import 'package:my_diet/models/product_model.dart';
import 'package:my_diet/services/product_search_service.dart';

class AddCookingIngredientDialogWidget extends StatefulWidget {
  final Function(FoodItemModel) onIngredientAdded;
  final String? currentDishName; // Додано параметр назви поточної страви

  const AddCookingIngredientDialogWidget({super.key, required this.onIngredientAdded, this.currentDishName});

  @override
  State<AddCookingIngredientDialogWidget> createState() => _AddCookingIngredientDialogWidgetState();
}

class _AddCookingIngredientDialogWidgetState extends State<AddCookingIngredientDialogWidget> {
  ProductSearchResult? _selectedResult;
  final _weightController = TextEditingController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _weightController.addListener(_updateState);
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
    final weight = double.tryParse(_weightController.text.replaceAll(',', '.')) ?? 0.0;
    final bool canAdd = _selectedResult != null && weight > 0;

    return AlertDialog(
      title: const Text('Додати інгредієнт'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Autocomplete<ProductSearchResult>(
              displayStringForOption: (ProductSearchResult option) => option.displayName,
              optionsBuilder: (TextEditingValue textEditingValue) async {
                if (textEditingValue.text.trim().isEmpty) {
                  return const Iterable<ProductSearchResult>.empty();
                }
                return await ProductSearchService.searchForCooking(
                  textEditingValue.text,
                  currentDishName: widget.currentDishName,
                );
              },
              onSelected: (ProductSearchResult selection) {
                setState(() {
                  _selectedResult = selection;
                  _searchController.text = selection.displayName;
                });
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                if (_searchController.text != controller.text && controller.text.isNotEmpty) {
                  _searchController.text = controller.text;
                }
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  onChanged: (val) {
                    setState(() {
                      _searchController.text = val;
                      if (_selectedResult != null && _selectedResult!.displayName != val) {
                        _selectedResult = null;
                      }
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Пошук інгредієнта',
                    hintText: 'Почніть вводити назву...',
                    prefixIcon: Icon(Icons.search),
                  ),
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 220, maxWidth: 360),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);

                          return ListTile(
                            leading: Icon(
                              option.isFromPantry ? Icons.kitchen : Icons.set_meal,
                              color: option.isFromPantry ? Colors.orange.shade800 : Colors.teal.shade700,
                            ),
                            title: Text(
                              option.displayName,
                              style: TextStyle(fontWeight: option.isFromPantry ? FontWeight.bold : FontWeight.normal),
                            ),
                            subtitle: Text(option.subtitle, style: const TextStyle(fontSize: 11)),
                            onTap: () => onSelected(option),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Вага сирого інгредієнта (грам)',
                hintText: 'наприклад, 300',
              ),
            ),
            if (_selectedResult != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    _selectedResult!.isFromPantry ? Icons.kitchen : Icons.set_meal,
                    size: 16,
                    color: _selectedResult!.isFromPantry ? Colors.orange.shade800 : Colors.teal.shade700,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _selectedResult!.isFromPantry
                          ? 'Обрано з інвентарю: ${_selectedResult!.displayName}'
                          : 'Обрано з бази: ${_selectedResult!.displayName}',
                      style: TextStyle(
                        fontSize: 12,
                        color: _selectedResult!.isFromPantry ? Colors.orange.shade900 : Colors.teal.shade900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
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
                  final double weight = double.tryParse(_weightController.text.replaceAll(',', '.')) ?? 0.0;
                  final res = _selectedResult!;

                  final ProductModel prod = res.isFromPantry
                      ? ProductModel(
                          id: res.pantryItem!.id,
                          name: res.pantryItem!.name,
                          category: 'Інвентар',
                          phe: res.pantryItem!.phe,
                          calories: res.pantryItem!.calories,
                          protein: res.pantryItem!.protein,
                          carbs: res.pantryItem!.carbs,
                          fat: res.pantryItem!.fat,
                          leucine: res.pantryItem!.leucine,
                          tyrosine: res.pantryItem!.tyrosine,
                          methionine: res.pantryItem!.methionine,
                          lysine: res.pantryItem!.lysine,
                          fiber: res.pantryItem!.fiber,
                          salt: res.pantryItem!.salt,
                          sugar: res.pantryItem!.sugar,
                          water: res.pantryItem!.water,
                          energy: res.pantryItem!.energy,
                        )
                      : res.product!;

                  final foodItem = FoodItemModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: prod.name,
                    weight: weight,
                    phe: (prod.phe * weight) / 100,
                    calories: (prod.calories * weight) / 100,
                    protein: (prod.protein * weight) / 100,
                    carbs: (prod.carbs * weight) / 100,
                    fat: (prod.fat * weight) / 100,
                    leucine: (prod.leucine * weight) / 100,
                    tyrosine: (prod.tyrosine * weight) / 100,
                    methionine: (prod.methionine * weight) / 100,
                    lysine: (prod.lysine * weight) / 100,
                    fiber: (prod.fiber * weight) / 100,
                    salt: (prod.salt * weight) / 100,
                    sugar: (prod.sugar * weight) / 100,
                    water: (prod.water * weight) / 100,
                    energy: (prod.energy * weight) / 100,
                  );

                  widget.onIngredientAdded(foodItem);
                  Navigator.pop(context);
                },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade800, foregroundColor: Colors.white),
          child: const Text('Додати'),
        ),
      ],
    );
  }
}
