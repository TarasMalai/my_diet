// ============================================================================
// НАЗВА ФАЙЛУ: add_food_dialog_widget.dart
// ПРИЗНАЧЕННЯ: Спливаюче вікно вводу продукту без зайвих нулів
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_diet/models/food_item_model.dart';
import 'package:my_diet/services/mock_diet_repository.dart';

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

  final _nameController = TextEditingController();
  final _weightController = TextEditingController(text: '100'); // Вага за замовчуванням 100г
  final _pheController = TextEditingController(); // Порожньо без '0'
  final _caloriesController = TextEditingController(); // Порожньо без '0'
  final _proteinController = TextEditingController(); // Порожньо без '0'
  final _carbsController = TextEditingController(); // Порожньо без '0'
  final _fatController = TextEditingController(); // Порожньо без '0'

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _pheController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final weight = double.tryParse(_weightController.text.replaceAll(',', '.')) ?? 100.0;
      final phe100 = double.tryParse(_pheController.text.replaceAll(',', '.')) ?? 0.0;
      final cal100 = double.tryParse(_caloriesController.text.replaceAll(',', '.')) ?? 0.0;
      final prot100 = double.tryParse(_proteinController.text.replaceAll(',', '.')) ?? 0.0;
      final carbs100 = double.tryParse(_carbsController.text.replaceAll(',', '.')) ?? 0.0;
      final fat100 = double.tryParse(_fatController.text.replaceAll(',', '.')) ?? 0.0;

      final item = FoodItemModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        weight: weight,
        phe: (phe100 * weight) / 100,
        calories: (cal100 * weight) / 100,
        protein: (prot100 * weight) / 100,
        carbs: (carbs100 * weight) / 100,
        fat: (fat100 * weight) / 100,
      );

      MockDietRepository().addFoodToMeal(widget.date, widget.mealId, item);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Додати в "${widget.mealTitle}"'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Назва продукту', hintText: 'напр. Яблуко'),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Введіть назву' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*[\.,]?\d*'))],
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Вага (грам)', hintText: '100'),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Показники на 100 грам:', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _pheController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*[\.,]?\d*'))],
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(labelText: 'ФА (мг)', hintText: '0'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _caloriesController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*[\.,]?\d*'))],
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(labelText: 'Ккал', hintText: '0'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _proteinController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*[\.,]?\d*'))],
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(labelText: 'Білки (г)', hintText: '0'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _carbsController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*[\.,]?\d*'))],
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(labelText: 'Вуглев. (г)', hintText: '0'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _fatController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*[\.,]?\d*'))],
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(labelText: 'Жири (г)', hintText: '0'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Скасувати')),
        ElevatedButton(onPressed: _submit, child: const Text('Зберегти')),
      ],
    );
  }
}
