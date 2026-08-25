// ============================================================================
// НАЗВА ФАЙЛУ: add_food_dialog_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Спливаюче вікно вводу продукту з автоочищенням нулів при фокусі
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_diet/models/food_item_model.dart';
import 'package:my_diet/services/mock_diet_repository_service.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: ДІАЛОГОВЕ ВІКНО ДОДАВАННЯ ПРОДУКТУ (AddFoodDialogWidget)
// ----------------------------------------------------------------------------
class AddFoodDialogWidget extends StatefulWidget {
  final DateTime date;
  final String mealId;
  final String mealTitle;

  const AddFoodDialogWidget({super.key, required this.date, required this.mealId, required this.mealTitle});

  @override
  State<AddFoodDialogWidget> createState() => _AddFoodDialogWidgetState();
}

class _AddFoodDialogWidgetState extends State<AddFoodDialogWidget> {
  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.1]: КЛЮЧ ФОРМИ ТА КОНТРОЛЕРИ ТЕКСТОВИХ ПОЛІВ
  // --------------------------------------------------------------------------
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _weightController = TextEditingController(text: '100');
  final _pheController = TextEditingController(text: '0');
  final _caloriesController = TextEditingController(text: '0');
  final _proteinController = TextEditingController(text: '0');
  final _carbsController = TextEditingController(text: '0');
  final _fatController = TextEditingController(text: '0');

  // [ДОДАНО 25.08.2026]: Контролери для амінокислот
  final _leucineController = TextEditingController(text: '0');
  final _tyrosineController = TextEditingController(text: '0');
  final _methionineController = TextEditingController(text: '0');
  final _lysineController = TextEditingController(text: '0');

  // [ДОДАНО 25.08.2026]: Контролери для додаткових нутрієнтів
  final _fiberController = TextEditingController(text: '0');
  final _saltController = TextEditingController(text: '0');
  final _sugarController = TextEditingController(text: '0');
  final _waterController = TextEditingController(text: '0');
  final _energyController = TextEditingController(text: '0');

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.2]: ФОКУС-НОДИ ДЛЯ УПРАВЛІННЯ ОЧИЩЕННЯМ НУЛЯ ПРИ НАТИСКАННІ
  // --------------------------------------------------------------------------
  final _weightFocus = FocusNode();
  final _pheFocus = FocusNode();
  final _caloriesFocus = FocusNode();
  final _proteinFocus = FocusNode();
  final _carbsFocus = FocusNode();
  final _fatFocus = FocusNode();

  // [ДОДАНО 25.08.2026]: Фокус-ноди для амінокислот
  final _leucineFocus = FocusNode();
  final _tyrosineFocus = FocusNode();
  final _methionineFocus = FocusNode();
  final _lysineFocus = FocusNode();

  // [ДОДАНО 25.08.2026]: Фокус-ноди для додаткових нутрієнтів
  final _fiberFocus = FocusNode();
  final _saltFocus = FocusNode();
  final _sugarFocus = FocusNode();
  final _waterFocus = FocusNode();
  final _energyFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _setupFocusListener(_weightController, _weightFocus);
    _setupFocusListener(_pheController, _pheFocus);
    _setupFocusListener(_caloriesController, _caloriesFocus);
    _setupFocusListener(_proteinController, _proteinFocus);
    _setupFocusListener(_carbsController, _carbsFocus);
    _setupFocusListener(_fatController, _fatFocus);

    // [ДОДАНО 25.08.2026]: Слухачі фокусу для нових полів
    _setupFocusListener(_leucineController, _leucineFocus);
    _setupFocusListener(_tyrosineController, _tyrosineFocus);
    _setupFocusListener(_methionineController, _methionineFocus);
    _setupFocusListener(_lysineController, _lysineFocus);

    _setupFocusListener(_fiberController, _fiberFocus);
    _setupFocusListener(_saltController, _saltFocus);
    _setupFocusListener(_sugarController, _sugarFocus);
    _setupFocusListener(_waterController, _waterFocus);
    _setupFocusListener(_energyController, _energyFocus);
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.3]: МЕТОД ДЛЯ АВТОМАТИЧНОГО СТИРАННЯ «0» ПРИ ОТРЕСУВАННІ ФОКУСА
  // --------------------------------------------------------------------------
  void _setupFocusListener(TextEditingController controller, FocusNode focusNode) {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        if (controller.text == '0') {
          controller.clear();
        }
      } else {
        if (controller.text.trim().isEmpty) {
          controller.text = (controller == _weightController) ? '100' : '0';
        }
      }
    });
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.4]: ЗВІЛЬНЕННЯ РЕСУРСІВ (DISPOSE)
  // --------------------------------------------------------------------------
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

    _weightFocus.dispose();
    _pheFocus.dispose();
    _caloriesFocus.dispose();
    _proteinFocus.dispose();
    _carbsFocus.dispose();
    _fatFocus.dispose();

    _leucineFocus.dispose();
    _tyrosineFocus.dispose();
    _methionineFocus.dispose();
    _lysineFocus.dispose();
    _fiberFocus.dispose();
    _saltFocus.dispose();
    _sugarFocus.dispose();
    _waterFocus.dispose();
    _energyFocus.dispose();

    super.dispose();
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2]: ОБРОБНИК ЗБЕРЕЖЕННЯ ТА РОЗРАХУНКУ ДАНИХ (_submit)
  // --------------------------------------------------------------------------
  void _submit() {
    if (_formKey.currentState!.validate()) {
      final weight = double.tryParse(_weightController.text.replaceAll(',', '.')) ?? 100.0;
      final phe100 = double.tryParse(_pheController.text.replaceAll(',', '.')) ?? 0.0;
      final cal100 = double.tryParse(_caloriesController.text.replaceAll(',', '.')) ?? 0.0;
      final prot100 = double.tryParse(_proteinController.text.replaceAll(',', '.')) ?? 0.0;
      final carbs100 = double.tryParse(_carbsController.text.replaceAll(',', '.')) ?? 0.0;
      final fat100 = double.tryParse(_fatController.text.replaceAll(',', '.')) ?? 0.0;

      final leu100 = double.tryParse(_leucineController.text.replaceAll(',', '.')) ?? 0.0;
      final tyr100 = double.tryParse(_tyrosineController.text.replaceAll(',', '.')) ?? 0.0;
      final met100 = double.tryParse(_methionineController.text.replaceAll(',', '.')) ?? 0.0;
      final lys100 = double.tryParse(_lysineController.text.replaceAll(',', '.')) ?? 0.0;

      final fiber100 = double.tryParse(_fiberController.text.replaceAll(',', '.')) ?? 0.0;
      final salt100 = double.tryParse(_saltController.text.replaceAll(',', '.')) ?? 0.0;
      final sugar100 = double.tryParse(_sugarController.text.replaceAll(',', '.')) ?? 0.0;
      final water100 = double.tryParse(_waterController.text.replaceAll(',', '.')) ?? 0.0;
      final energy100 = double.tryParse(_energyController.text.replaceAll(',', '.')) ?? 0.0;

      final item = FoodItemModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        weight: weight,
        phe: (phe100 * weight) / 100,
        calories: (cal100 * weight) / 100,
        protein: (prot100 * weight) / 100,
        carbs: (carbs100 * weight) / 100,
        fat: (fat100 * weight) / 100,
        leucine: (leu100 * weight) / 100,
        tyrosine: (tyr100 * weight) / 100,
        methionine: (met100 * weight) / 100,
        lysine: (lys100 * weight) / 100,
        fiber: (fiber100 * weight) / 100,
        salt: (salt100 * weight) / 100,
        sugar: (sugar100 * weight) / 100,
        water: (water100 * weight) / 100,
        energy: (energy100 * weight) / 100,
      );

      MockDietRepository().addFoodToMeal(widget.date, widget.mealId, item);
      Navigator.of(context).pop();
    }
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 3]: ВІЗУАЛЬНИЙ КАРКАС ДІАЛОГУ ТА ФОРМА ВВОДУ (BUILD)
  // --------------------------------------------------------------------------
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
                // ------------------------------------------------------------
                // [ВУЗОЛ 3.1]: ПОЛЯ ВВЕДЕННЯ НАЗВИ ТА ВАГИ
                // ------------------------------------------------------------
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Назва продукту', hintText: 'напр. Яблуко'),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Введіть назву' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _weightController,
                  focusNode: _weightFocus,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))],
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Вага (грам)', hintText: '100'),
                ),

                // ------------------------------------------------------------
                // [ВУЗОЛ 3.2]: БЛОК ПОКАЗНИКІВ НА 100 ГРАМ (ФА та ККАЛ)
                // ------------------------------------------------------------
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
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))],
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
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))],
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(labelText: 'Ккал', hintText: '0'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // ------------------------------------------------------------
                // [ВУЗОЛ 3.3]: БЛОК БЖВ (БІЛКИ, ВУГЛЕВОДИ, ЖИРИ)
                // ------------------------------------------------------------
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _proteinController,
                        focusNode: _proteinFocus,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))],
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
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))],
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
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))],
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(labelText: 'Жири (г)', hintText: '0'),
                      ),
                    ),
                  ],
                ),

                // ------------------------------------------------------------
                // [ВУЗОЛ 3.4]: АМІНОКИСЛОТИ (ОПЦІОНАЛЬНО) [ДОДАНО 25.08.2026]
                // ------------------------------------------------------------
                const SizedBox(height: 12),
                ExpansionTile(
                  title: const Text(
                    'Амінокислоти (на 100г)',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  childrenPadding: const EdgeInsets.symmetric(vertical: 8.0),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _leucineController,
                            focusNode: _leucineFocus,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))],
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(labelText: 'Лейцин (мг)', hintText: '0'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _tyrosineController,
                            focusNode: _tyrosineFocus,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))],
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(labelText: 'Тирозин (мг)', hintText: '0'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _methionineController,
                            focusNode: _methionineFocus,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))],
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(labelText: 'Метіонін (мг)', hintText: '0'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _lysineController,
                            focusNode: _lysineFocus,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))],
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(labelText: 'Лізин (мг)', hintText: '0'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // ------------------------------------------------------------
                // [ВУЗОЛ 3.5]: ДОДАТКОВІ НУТРІЄНТИ (ОПЦІОНАЛЬНО) [ДОДАНО 25.08.2026]
                // ------------------------------------------------------------
                ExpansionTile(
                  title: const Text(
                    'Додаткові нутрієнти (на 100г)',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  childrenPadding: const EdgeInsets.symmetric(vertical: 8.0),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _fiberController,
                            focusNode: _fiberFocus,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))],
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(labelText: 'Клітковина (г)', hintText: '0'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _sugarController,
                            focusNode: _sugarFocus,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))],
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(labelText: 'Цукор (г)', hintText: '0'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _saltController,
                            focusNode: _saltFocus,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))],
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(labelText: 'Сіль (г)', hintText: '0'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _waterController,
                            focusNode: _waterFocus,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))],
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(labelText: 'Вода (мл)', hintText: '0'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _energyController,
                      focusNode: _energyFocus,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))],
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(labelText: 'Енергія (кДж)', hintText: '0'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // ----------------------------------------------------------------------
      // [ВУЗОЛ 3.6]: КНОПКИ ДІЙ (СКАСУВАТИ / ЗБЕРЕГТИ)
      // ----------------------------------------------------------------------
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Скасувати')),
        ElevatedButton(onPressed: _submit, child: const Text('Зберегти')),
      ],
    );
  }
}
