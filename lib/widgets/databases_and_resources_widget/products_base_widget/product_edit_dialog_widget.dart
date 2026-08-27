// ============================================================================
// НАЗВА ФАЙЛУ: product_edit_dialog_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Діалогове вікно створення та редагування продукту в базі
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/models/product_model.dart';
import 'package:my_diet/widgets/common_widget/app_number_input_field_widget.dart';
import 'package:my_diet/widgets/common_widget/app_text_input_field_widget.dart';

// ============================================================================
// [ВУЗОЛ 5]: ДІАЛОГОВЕ ВІКНО СТВОРЕННЯ ТА РЕДАГУВАННЯ ПРОДУКТУ БАЗИ
// ============================================================================
class ProductEditDialogWidget extends StatefulWidget {
  final ProductModel? product; // null для створення, об'єкт для редагування

  const ProductEditDialogWidget({super.key, this.product});

  @override
  State<ProductEditDialogWidget> createState() => _ProductEditDialogWidgetState();
}

class _ProductEditDialogWidgetState extends State<ProductEditDialogWidget> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _categoryController;

  late final TextEditingController _pheController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _proteinController;
  late final TextEditingController _carbsController;
  late final TextEditingController _fatController;

  late final TextEditingController _leucineController;
  late final TextEditingController _tyrosineController;
  late final TextEditingController _methionineController;
  late final TextEditingController _lysineController;

  late final TextEditingController _fiberController;
  late final TextEditingController _saltController;
  late final TextEditingController _sugarController;
  late final TextEditingController _waterController;
  late final TextEditingController _energyController;

  @override
  void initState() {
    super.initState();
    final p = widget.product;

    _nameController = TextEditingController(text: p?.name ?? '');
    _categoryController = TextEditingController(text: p?.category ?? '');

    _pheController = TextEditingController(text: _formatValue(p?.phe));
    _caloriesController = TextEditingController(text: _formatValue(p?.calories));
    _proteinController = TextEditingController(text: _formatValue(p?.protein));
    _carbsController = TextEditingController(text: _formatValue(p?.carbs));
    _fatController = TextEditingController(text: _formatValue(p?.fat));

    _leucineController = TextEditingController(text: _formatValue(p?.leucine));
    _tyrosineController = TextEditingController(text: _formatValue(p?.tyrosine));
    _methionineController = TextEditingController(text: _formatValue(p?.methionine));
    _lysineController = TextEditingController(text: _formatValue(p?.lysine));

    _fiberController = TextEditingController(text: _formatValue(p?.fiber));
    _saltController = TextEditingController(text: _formatValue(p?.salt));
    _sugarController = TextEditingController(text: _formatValue(p?.sugar));
    _waterController = TextEditingController(text: _formatValue(p?.water));
    _energyController = TextEditingController(text: _formatValue(p?.energy));
  }

  String _formatValue(double? val) {
    if (val == null || val == 0.0) return '';
    if (val == val.toInt()) return val.toInt().toString();
    return val.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();

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

  double _parse(TextEditingController controller, [double defaultValue = 0.0]) {
    final text = controller.text.trim().replaceAll(',', '.');
    if (text.isEmpty) return defaultValue;
    return double.tryParse(text) ?? defaultValue;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final isEditing = widget.product != null;

      final updatedProduct = ProductModel(
        id: isEditing ? widget.product!.id : DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        category: _categoryController.text.trim(),
        phe: _parse(_pheController),
        calories: _parse(_caloriesController),
        protein: _parse(_proteinController),
        carbs: _parse(_carbsController),
        fat: _parse(_fatController),
        leucine: _parse(_leucineController),
        tyrosine: _parse(_tyrosineController),
        methionine: _parse(_methionineController),
        lysine: _parse(_lysineController),
        fiber: _parse(_fiberController),
        salt: _parse(_saltController),
        sugar: _parse(_sugarController),
        water: _parse(_waterController),
        energy: _parse(_energyController),
      );

      Navigator.of(context).pop(updatedProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isEditing = widget.product != null;

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        isEditing ? 'Редагувати продукт' : 'Новий продукт бази',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
                  ],
                ),
                const Divider(),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        _buildSectionHeader('Загальні дані'),
                        AppTextInputFieldWidget(controller: _nameController, label: 'Назва продукту', isRequired: true),
                        const SizedBox(height: 10),
                        AppTextInputFieldWidget(controller: _categoryController, label: 'Категорія'),

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

                const Divider(),

                // [ВУЗОЛ 5.1]: ПАНЕЛЬ УПРАВЛІННЯ ВІКНОМ (З КНОПКОЮ ВИДАЛЕННЯ ДЛЯ ІСНУЮЧИХ ЗАПИСІВ)
                Row(
                  children: [
                    if (isEditing)
                      IconButton(
                        tooltip: 'Видалити продукт',
                        icon: Icon(Icons.delete_outline, color: Colors.red.shade700),
                        onPressed: () => Navigator.of(context).pop('delete'),
                      ),
                    const Spacer(),
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Скасувати')),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _submit,
                      icon: Icon(isEditing ? Icons.save : Icons.add, size: 18),
                      label: Text(isEditing ? 'Зберегти' : 'Додати'),
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
