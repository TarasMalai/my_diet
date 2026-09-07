// ============================================================================
// НАЗВА ФАЙЛУ: add_food_dialog_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Спливаюче вікно додавання продукту з автозаповненням та інтеграцією з Інвентарем
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/models/food_item_model.dart';
import 'package:my_diet/models/product_model.dart';
import 'package:my_diet/models/pantry_item_model.dart';
import 'package:my_diet/services/mock_diet_repository_service.dart';
import 'package:my_diet/services/pantry_service.dart';
import 'package:my_diet/repositories/product_repository.dart';
import 'package:my_diet/widgets/common_widget/app_number_input_field_widget.dart';

// ============================================================================
// [ВУЗОЛ 1]: ГОЛОВНИЙ КЛАС ДІАЛОГУ ТА ІНІЦІАЛІЗАЦІЯ СТАНУ
// ============================================================================
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

  List<ProductModel> _availableProducts = [];
  bool _isLoadingProducts = true;

  // Зв'язок із Інвентарем для поточного вибраного продукту
  PantryItemModel? _linkedPantryItem;

  // Контролери вводу
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
  void initState() {
    super.initState();
    _loadProductsBase();
  }

  /// Завантаження бази продуктів для підказок у пошуку
  Future<void> _loadProductsBase() async {
    try {
      final products = await ProductRepository().loadProducts();
      if (mounted) {
        setState(() {
          _availableProducts = products;
          _isLoadingProducts = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingProducts = false);
      }
    }
  }

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

  // ============================================================================
  // [ВУЗОЛ 2]: ЛОГІКА АВТОЗАПОВНЕННЯ, ПАРСИНГУ ТА ЗБЕРЕЖЕННЯ
  // ============================================================================

  /// Автозаповнення полів нутрієнтів із вибраного продукту + перевірка Інвентаря
  void _autofillFromProduct(ProductModel product) {
    setState(() {
      _nameController.text = product.name;

      // Перевіряємо, чи є цей продукт у інвентарі
      _linkedPantryItem = PantryService().findItem(product.name);

      _caloriesController.text = product.calories > 0 ? _formatNum(product.calories) : '';
      _pheController.text = product.phe > 0 ? _formatNum(product.phe) : '';
      _proteinController.text = product.protein > 0 ? _formatNum(product.protein) : '';
      _fatController.text = product.fat > 0 ? _formatNum(product.fat) : '';
      _carbsController.text = product.carbs > 0 ? _formatNum(product.carbs) : '';

      _leucineController.text = product.leucine > 0 ? _formatNum(product.leucine) : '';
      _tyrosineController.text = product.tyrosine > 0 ? _formatNum(product.tyrosine) : '';
      _methionineController.text = product.methionine > 0 ? _formatNum(product.methionine) : '';
      _lysineController.text = product.lysine > 0 ? _formatNum(product.lysine) : '';

      _fiberController.text = product.fiber > 0 ? _formatNum(product.fiber) : '';
      _sugarController.text = product.sugar > 0 ? _formatNum(product.sugar) : '';
      _saltController.text = product.salt > 0 ? _formatNum(product.salt) : '';
      _waterController.text = product.water > 0 ? _formatNum(product.water) : '';
      _energyController.text = product.energy > 0 ? _formatNum(product.energy) : '';
    });
  }

  String _formatNum(double val) {
    return val % 1 == 0 ? val.toInt().toString() : val.toString();
  }

  double _parse(TextEditingController controller, [double defaultValue = 0.0]) {
    final text = controller.text.trim().replaceAll(',', '.');
    if (text.isEmpty) return defaultValue;
    return double.tryParse(text) ?? defaultValue;
  }

  /// Збереження продукту у прийом їжі та автоматичне списання з Інвентаря (якщо він там був)
  void _submit() {
    if (_formKey.currentState!.validate()) {
      final weight = _parse(_weightController, 100.0);

      // Якщо продукт був прив'язаний до Інвентаря, списуємо звідти вагу автоматично!
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

  // ============================================================================
  // [ВУЗОЛ 3]: ВІДОБРАЖЕННЯ ІНТЕРФЕЙСУ (BUILD)
  // ============================================================================
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
                // Шапка діалогу
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

                // Тіло форми
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        _buildSectionHeader('Основна інформація'),

                        // Поле пошуку з автозаповненням
                        _buildProductAutocompleteField(),

                        // Індикатор наявності в Інвентарі (якщо знайдено)
                        if (_linkedPantryItem != null) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                                  'В інвентарі є: ${_linkedPantryItem!.weightInGram} г (буде списано)',
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

                        const SizedBox(height: 10),
                        AppNumberInputFieldWidget(controller: _weightController, label: 'Вага (грам)', hintText: '100'),

                        const SizedBox(height: 16),
                        _buildSectionHeader('Основні нутрієнти (на 100 г)'),
                        Row(
                          children: [
                            Expanded(
                              child: AppNumberInputFieldWidget(controller: _caloriesController, label: 'Ккал'),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: AppNumberInputFieldWidget(controller: _pheController, label: 'ФА (мг)'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: AppNumberInputFieldWidget(controller: _proteinController, label: 'Білки (г)'),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: AppNumberInputFieldWidget(controller: _fatController, label: 'Жири (г)'),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: AppNumberInputFieldWidget(controller: _carbsController, label: 'Вуглеводи (г)'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        _buildSectionHeader('Амінокислоти (на 100 г)'),
                        Row(
                          children: [
                            Expanded(
                              child: AppNumberInputFieldWidget(controller: _tyrosineController, label: 'Тирозин (мг)'),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: AppNumberInputFieldWidget(controller: _leucineController, label: 'Лейцин (мг)'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: AppNumberInputFieldWidget(
                                controller: _methionineController,
                                label: 'Метіонін (мг)',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: AppNumberInputFieldWidget(controller: _lysineController, label: 'Лізин (мг)'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        _buildSectionHeader('Додатково (на 100 г)'),
                        Row(
                          children: [
                            Expanded(
                              child: AppNumberInputFieldWidget(controller: _fiberController, label: 'Клітковина (г)'),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: AppNumberInputFieldWidget(controller: _sugarController, label: 'Цукор (г)'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: AppNumberInputFieldWidget(controller: _saltController, label: 'Сіль (г)'),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: AppNumberInputFieldWidget(controller: _waterController, label: 'Вода (г)'),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: AppNumberInputFieldWidget(
                                controller: _energyController,
                                label: 'кДж',
                                textInputAction: TextInputAction.done,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),

                // Кнопки дій
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

  // ============================================================================
  // [ВУЗОЛ 4]: ДОПОМІЖНІ ВІДЖЕТИ ПОШУКУ ТА ВЕРСТКИ
  // ============================================================================

  // ----------------------------------------------------------------------------
  // [ВУЗОЛ 4.1]: ВІДЖЕТ ПОЛЯ З АВТОЗАПОВНЕННЯМ ТА ПРІОРИТЕТНИМ СОРТУВАННЯМ
  // ----------------------------------------------------------------------------
  Widget _buildProductAutocompleteField() {
    return RawAutocomplete<ProductModel>(
      textEditingController: _nameController,
      focusNode: FocusNode(),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<ProductModel>.empty();
        }
        final query = textEditingValue.text.toLowerCase().trim();

        final matches = _availableProducts.where((product) {
          return product.name.toLowerCase().contains(query);
        }).toList();

        matches.sort((a, b) {
          final aName = a.name.toLowerCase();
          final bName = b.name.toLowerCase();

          int getPriority(String name) {
            if (name == query) return 0;
            if (name.startsWith(query)) return 1;
            if (name.contains(' $query')) return 2;
            return 3;
          }

          final aPriority = getPriority(aName);
          final bPriority = getPriority(bName);

          if (aPriority != bPriority) {
            return aPriority.compareTo(bPriority);
          }

          return aName.compareTo(bName);
        });

        return matches;
      },
      displayStringForOption: (ProductModel option) => option.name,
      onSelected: (ProductModel selection) {
        _autofillFromProduct(selection);
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'Назва продукту *',
            hintText: 'Почніть вводити для пошуку...',
            prefixIcon: const Icon(Icons.search, color: Colors.teal),
            suffixIcon: _isLoadingProducts
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: Padding(padding: EdgeInsets.all(12.0), child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.teal, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Введіть назву продукту';
            }
            return null;
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 220, maxWidth: 480),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (BuildContext context, int index) {
                  final ProductModel option = options.elementAt(index);
                  return ListTile(
                    dense: true,
                    title: Text(option.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      'ФА: ${option.phe} мг | Ккал: ${option.calories} | Білок: ${option.protein} г',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                    ),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // ----------------------------------------------------------------------------
  // [ВУЗОЛ 4.2]: ЗАГОЛОВОК СЕКЦІЇ
  // ----------------------------------------------------------------------------
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.teal.shade800),
      ),
    );
  }
}
