// ============================================================================
// НАЗВА ФАЙЛУ: add_food_dialog_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Спливаюче вікно додавання продукту/страви в прийом їжі
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/models/food_item_model.dart';
import 'package:my_diet/models/pantry_item_model.dart';
import 'package:my_diet/services/mock_diet_repository_service.dart';
import 'package:my_diet/services/pantry_service.dart';
import 'package:my_diet/services/product_search_service.dart';
import 'package:my_diet/widgets/common_widget/app_number_input_field_widget.dart';
import 'package:my_diet/widgets/common_widget/nutrient_input_group_widget.dart';

class AddFoodDialogWidget extends StatefulWidget {
  final DateTime date;
  final String mealId;
  final String mealTitle;

  const AddFoodDialogWidget({super.key, required this.date, required this.mealId, required this.mealTitle});

  @override
  State<AddFoodDialogWidget> createState() => _AddFoodDialogWidgetState();
}

class _AddFoodDialogWidgetState extends State<AddFoodDialogWidget> {
  final _formKey = GlobalKey<FormState>();

  // Зв'язаний елемент з інвентарю для списання
  PantryItemModel? _linkedPantryItem;
  bool _isCustomEntry = false; // Прапорець ручного введення (загадки)

  // Контролери
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _pheController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();

  final _leucineController = TextEditingController();
  final _tyrosineController = TextEditingController();
  final _methionineController = TextEditingController();
  final _lysineController = TextEditingController();

  final _fiberController = TextEditingController();
  final _saltController = TextEditingController();
  final _sugarController = TextEditingController();
  final _waterController = TextEditingController();
  final _energyController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _pheController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _leucineController.dispose();
    _tyrosineController.dispose();
    _methionineController.dispose();
    _lysineController.dispose();
    _fiberController.dispose();
    _saltController.dispose();
    _sugarController.dispose();
    _waterController.dispose();
    _energyController.dispose();
    super.dispose();
  }

  /// Вибір результату з пошуку
  void _onResultSelected(ProductSearchResult result) {
    setState(() {
      _nameController.text = result.displayName;
      _isCustomEntry = false;

      if (result.isFromPantry) {
        final item = result.pantryItem!;
        _linkedPantryItem = item;
        _fillFields(
          calories: item.calories,
          phe: item.phe,
          protein: item.protein,
          fat: item.fat,
          carbs: item.carbs,
          leucine: item.leucine,
          tyrosine: item.tyrosine,
          methionine: item.methionine,
          lysine: item.lysine,
          fiber: item.fiber,
          sugar: item.sugar,
          salt: item.salt,
          water: item.water,
          energy: item.energy,
        );
      } else {
        final product = result.product!;
        _linkedPantryItem = PantryService().findItem(product.name, productId: product.id);
        _fillFields(
          calories: product.calories,
          phe: product.phe,
          protein: product.protein,
          fat: product.fat,
          carbs: product.carbs,
          leucine: product.leucine,
          tyrosine: product.tyrosine,
          methionine: product.methionine,
          lysine: product.lysine,
          fiber: product.fiber,
          sugar: product.sugar,
          salt: product.salt,
          water: product.water,
          energy: product.energy,
        );
      }
    });
  }

  void _fillFields({
    required double calories,
    required double phe,
    required double protein,
    required double fat,
    required double carbs,
    double leucine = 0,
    double tyrosine = 0,
    double methionine = 0,
    double lysine = 0,
    double fiber = 0,
    double sugar = 0,
    double salt = 0,
    double water = 0,
    double energy = 0,
  }) {
    _caloriesController.text = calories > 0 ? _formatNum(calories) : '';
    _pheController.text = phe > 0 ? _formatNum(phe) : '';
    _proteinController.text = protein > 0 ? _formatNum(protein) : '';
    _fatController.text = fat > 0 ? _formatNum(fat) : '';
    _carbsController.text = carbs > 0 ? _formatNum(carbs) : '';

    _leucineController.text = leucine > 0 ? _formatNum(leucine) : '';
    _tyrosineController.text = tyrosine > 0 ? _formatNum(tyrosine) : '';
    _methionineController.text = methionine > 0 ? _formatNum(methionine) : '';
    _lysineController.text = lysine > 0 ? _formatNum(lysine) : '';

    _fiberController.text = fiber > 0 ? _formatNum(fiber) : '';
    _sugarController.text = sugar > 0 ? _formatNum(sugar) : '';
    _saltController.text = salt > 0 ? _formatNum(salt) : '';
    _waterController.text = water > 0 ? _formatNum(water) : '';
    _energyController.text = energy > 0 ? _formatNum(energy) : '';
  }

  String _formatNum(double val) {
    if (val % 1 == 0) return val.toInt().toString();

    // Форматуємо до 2 знаків після коми та видаляємо зайві нулі в кінці
    String formatted = val.toStringAsFixed(2);
    if (formatted.contains('.')) {
      formatted = formatted.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }
    return formatted;
  }

  double _parse(TextEditingController controller) {
    final text = controller.text.trim().replaceAll(',', '.');
    if (text.isEmpty) return 0.0;
    return double.tryParse(text) ?? 0.0;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final weight = _parse(_weightController);

      // Якщо позицію вибрано з інвентарю — списуємо вагу
      if (_linkedPantryItem != null) {
        PantryService().deductWeight(_linkedPantryItem!.id, weight);
      }

      final item = FoodItemModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        weight: weight,
        phe: (_parse(_pheController) * weight) / 100,
        calories: (_parse(_caloriesController) * weight) / 100,
        protein: (_parse(_proteinController) * weight) / 100,
        carbs: (_parse(_carbsController) * weight) / 100,
        fat: (_parse(_fatController) * weight) / 100,
        leucine: (_parse(_leucineController) * weight) / 100,
        tyrosine: (_parse(_tyrosineController) * weight) / 100,
        methionine: (_parse(_methionineController) * weight) / 100,
        lysine: (_parse(_lysineController) * weight) / 100,
        fiber: (_parse(_fiberController) * weight) / 100,
        salt: (_parse(_saltController) * weight) / 100,
        sugar: (_parse(_sugarController) * weight) / 100,
        water: (_parse(_waterController) * weight) / 100,
        energy: (_parse(_energyController) * weight) / 100,
      );

      MockDietRepository().addFoodToMeal(widget.date, widget.mealId, item);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 550, maxHeight: screenHeight * 0.85),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ЗАГОЛОВОК
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Додати в "${widget.mealTitle}"',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
                  ],
                ),
                const Divider(),

                // ФОРМА
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // УНІВЕРСАЛЬНИЙ ПОШУК (ПОДВІЙНИЙ)
                        Autocomplete<ProductSearchResult>(
                          displayStringForOption: (option) => option.displayName,
                          optionsBuilder: (textEditingValue) async {
                            final results = await ProductSearchService.searchForMeal(textEditingValue.text);
                            setState(() {
                              _isCustomEntry = results.isEmpty && textEditingValue.text.trim().isNotEmpty;
                              if (_isCustomEntry) {
                                _linkedPantryItem = null;
                              }
                            });
                            return results;
                          },
                          onSelected: _onResultSelected,
                          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                            if (_nameController.text != controller.text && controller.text.isEmpty) {
                              controller.text = _nameController.text;
                            }
                            controller.addListener(() {
                              _nameController.text = controller.text;
                            });

                            return TextFormField(
                              controller: controller,
                              focusNode: focusNode,
                              decoration: const InputDecoration(
                                labelText: 'Назва продукту або страви',
                                hintText: 'Почніть вводити назву...',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Введіть назву продукту або страви';
                                }
                                return null;
                              },
                            );
                          },
                          optionsViewBuilder: (context, onSelected, options) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                elevation: 4,
                                borderRadius: BorderRadius.circular(8),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxHeight: 220, maxWidth: 510),
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
                                          style: TextStyle(
                                            fontWeight: option.isFromPantry ? FontWeight.bold : FontWeight.normal,
                                          ),
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

                        // ПІДКАЗКА: РУЧНЕ ВВЕДЕННЯ
                        if (_isCustomEntry) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.amber.shade300),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, size: 16, color: Colors.amber.shade900),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Позицію не знайдено. Вкажіть нутрієнти вручну.',
                                    style: TextStyle(fontSize: 12, color: Colors.amber.shade900),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // ПЛАШКА ІНВЕНТАРЯ
                        if (_linkedPantryItem != null) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.teal.shade200),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.home_outlined, size: 16, color: Colors.teal),
                                const SizedBox(width: 8),
                                Text(
                                  'В інвентарі є: ${_linkedPantryItem!.weightInGram.toInt()} г (буде списано)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.teal.shade800,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 12),

                        // ПОЛЕ ВАГИ
                        AppNumberInputFieldWidget(
                          controller: _weightController,
                          label: 'Вага (грам)',
                          hintText: '100',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Введіть вагу продукту';
                            }
                            final numValue = double.tryParse(value.trim().replaceAll(',', '.'));
                            if (numValue == null || numValue <= 0) {
                              return 'Введіть коректну вагу (> 0)';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        // ОЧИЩЕНІ БЛОКИ НУТРІЄНТІВ
                        NutrientInputGroupWidget(
                          title: 'Основні нутрієнти (на 100 г)',
                          rows: [
                            [
                              NutrientInputRow(controller: _caloriesController, label: 'Ккал', hintText: '0'),
                              NutrientInputRow(
                                controller: _pheController,
                                label: 'Фенілаланін (ФА, мг)',
                                hintText: '0',
                              ),
                            ],
                            [
                              NutrientInputRow(controller: _proteinController, label: 'Білки (г)'),
                              NutrientInputRow(controller: _fatController, label: 'Жири (г)'),
                              NutrientInputRow(controller: _carbsController, label: 'Вуглеводи (г)'),
                            ],
                          ],
                        ),

                        NutrientInputGroupWidget(
                          title: 'Амінокислоти (на 100 г)',
                          rows: [
                            [
                              NutrientInputRow(controller: _tyrosineController, label: 'Тирозин (мг)', hintText: '0'),
                              NutrientInputRow(controller: _leucineController, label: 'Лейцин (мг)', hintText: '0'),
                            ],
                            [
                              NutrientInputRow(
                                controller: _methionineController,
                                label: 'Метіонін (мг)',
                                hintText: '0',
                              ),
                              NutrientInputRow(controller: _lysineController, label: 'Лізин (мг)', hintText: '0'),
                            ],
                          ],
                        ),

                        NutrientInputGroupWidget(
                          title: 'Додатково (на 100 г)',
                          rows: [
                            [
                              NutrientInputRow(controller: _fiberController, label: 'Клітковина (г)'),
                              NutrientInputRow(controller: _sugarController, label: 'Цукор (г)'),
                            ],
                            [
                              NutrientInputRow(controller: _saltController, label: 'Сіль (г)'),
                              NutrientInputRow(controller: _waterController, label: 'Вода (г)'),
                              NutrientInputRow(
                                controller: _energyController,
                                label: 'Енергія (кДж)',
                                hintText: '0',
                                textInputAction: TextInputAction.done,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // КНОПКИ
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Скасувати')),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Додати'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade700,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
