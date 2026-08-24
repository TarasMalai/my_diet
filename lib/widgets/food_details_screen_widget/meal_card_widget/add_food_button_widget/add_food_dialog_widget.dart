// ============================================================================
// НАЗВА ФАЙЛУ: add_food_dialog_widget.dart
// ПРИЗНАЧЕННЯ: Спливаюче вікно вводу продукту з автоочищенням нулів при фокусі
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
  // ВУЗОЛ 1.1: Ключ форми та контролери текстових полів
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _weightController = TextEditingController(text: '100'); // Початкова вага 100г
  final _pheController = TextEditingController(text: '0');
  final _caloriesController = TextEditingController(text: '0');
  final _proteinController = TextEditingController(text: '0');
  final _carbsController = TextEditingController(text: '0');
  final _fatController = TextEditingController(text: '0');

  // ВУЗОЛ 1.2: Фокус-ноди для управління очищенням нуля при натисканні
  final _weightFocus = FocusNode();
  final _pheFocus = FocusNode();
  final _caloriesFocus = FocusNode();
  final _proteinFocus = FocusNode();
  final _carbsFocus = FocusNode();
  final _fatFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // Налаштування слухачів фокуса для автоматичного очищення «0»
    _setupFocusListener(_weightController, _weightFocus);
    _setupFocusListener(_pheController, _pheFocus);
    _setupFocusListener(_caloriesController, _caloriesFocus);
    _setupFocusListener(_proteinController, _proteinFocus);
    _setupFocusListener(_carbsController, _carbsFocus);
    _setupFocusListener(_fatController, _fatFocus);
  }

  // ВУЗОЛ 1.3: Метод для автоматичного стирання «0» при отриманні фокуса
  void _setupFocusListener(TextEditingController controller, FocusNode focusNode) {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        if (controller.text == '0') {
          controller.clear();
        }
      } else {
        // Якщо поле залишили порожнім, повертаємо туди «0» або «100» для ваги
        if (controller.text.trim().isEmpty) {
          controller.text = (controller == _weightController) ? '100' : '0';
        }
      }
    });
  }

  @override
  void dispose() {
    // Звільнення контролерів
    _nameController.dispose();
    _weightController.dispose();
    _pheController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();

    // Звільнення фокус-нодів
    _weightFocus.dispose();
    _pheFocus.dispose();
    _caloriesFocus.dispose();
    _proteinFocus.dispose();
    _carbsFocus.dispose();
    _fatFocus.dispose();

    super.dispose();
  }

  // ВУЗОЛ 2.1: Обробник збереження даних
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
                // Поле назви продукту
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Назва продукту', hintText: 'напр. Яблуко'),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Введіть назву' : null,
                ),
                const SizedBox(height: 12),
                // Поле ваги
                TextFormField(
                  controller: _weightController,
                  focusNode: _weightFocus,
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
                        focusNode: _pheFocus,
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
                        focusNode: _caloriesFocus,
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
                        focusNode: _proteinFocus,
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
                        focusNode: _carbsFocus,
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
                        focusNode: _fatFocus,
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
