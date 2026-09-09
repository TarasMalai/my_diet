// ============================================================================
// НАЗВА ФАЙЛУ: cooking_detail_screen.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Екран детального редагування страви з передачею стану чекбокса useTare
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/models/cooking_dish_model.dart';
import 'package:my_diet/models/food_item_model.dart';
import 'package:my_diet/services/cooking_service.dart';
import 'package:my_diet/widgets/common_widget/banner_widget/app_scaffold_widget.dart';
import 'package:my_diet/widgets/databases_and_resources_widget/cooking_widgets/add_cooking_ingredient_dialog_widget.dart';
import 'package:my_diet/widgets/databases_and_resources_widget/cooking_widgets/cooking_bottom_panel_widget.dart';
import 'package:my_diet/widgets/databases_and_resources_widget/cooking_widgets/cooking_ingredients_list_widget.dart';
import 'package:my_diet/widgets/databases_and_resources_widget/cooking_widgets/cooking_totals_header_widget.dart';

class CookingDetailScreen extends StatefulWidget {
  final CookingDishModel dish;

  const CookingDetailScreen({super.key, required this.dish});

  @override
  State<CookingDetailScreen> createState() => _CookingDetailScreenState();
}

class _CookingDetailScreenState extends State<CookingDetailScreen> {
  late TextEditingController _nameController;
  late TextEditingController _tareController;
  late TextEditingController _finalWeightController;
  late TextEditingController _notesController;

  final CookingService _cookingService = CookingService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.dish.name);
    _tareController = TextEditingController(text: widget.dish.tareWeight > 0 ? widget.dish.tareWeight.toString() : '');
    _finalWeightController = TextEditingController(
      text: widget.dish.finalGrossWeight > 0 ? widget.dish.finalGrossWeight.toString() : '',
    );
    _notesController = TextEditingController(text: widget.dish.notes);

    _nameController.addListener(_saveChangesToMemory);
    _tareController.addListener(_saveChangesToMemory);
    _finalWeightController.addListener(_saveChangesToMemory);
    _notesController.addListener(_saveChangesToMemory);
  }

  void _saveChangesToMemory() {
    widget.dish.name = _nameController.text;
    widget.dish.tareWeight = double.tryParse(_tareController.text.replaceAll(',', '.')) ?? 0.0;
    widget.dish.finalGrossWeight = double.tryParse(_finalWeightController.text.replaceAll(',', '.')) ?? 0.0;
    widget.dish.notes = _notesController.text;

    _cookingService.updateDish(widget.dish);
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tareController.dispose();
    _finalWeightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showAddIngredientDialog() {
    showDialog(
      context: context,
      builder: (context) => AddCookingIngredientDialogWidget(
        onIngredientAdded: (FoodItemModel item) {
          setState(() {
            widget.dish.ingredients.add(item);
            _cookingService.updateDish(widget.dish);
          });
        },
      ),
    );
  }

  Future<void> _saveToRecipesAndClose() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    await _cookingService.saveToMyRecipes(widget.dish);

    if (!mounted) return;

    messenger.showSnackBar(const SnackBar(content: Text('Страву збережено в Рецепти та перенесено в архів')));
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBar: AppBar(
        title: Text(widget.dish.name.isEmpty ? 'Редагування страви' : widget.dish.name),
        backgroundColor: Colors.orange.shade800,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          CookingTotalsHeaderWidget(dish: widget.dish, nameController: _nameController),
          Expanded(
            child: CookingIngredientsListWidget(
              ingredients: widget.dish.ingredients,
              onDelete: (String id) {
                setState(() {
                  widget.dish.ingredients.removeWhere((i) => i.id == id);
                  _cookingService.updateDish(widget.dish);
                });
              },
            ),
          ),
          CookingBottomPanelWidget(
            tareController: _tareController,
            finalWeightController: _finalWeightController,
            notesController: _notesController,
            useTare: widget.dish.useTare,
            onUseTareChanged: (bool? val) {
              setState(() {
                widget.dish.useTare = val ?? true;
                _cookingService.updateDish(widget.dish);
              });
            },
            onAddIngredient: _showAddIngredientDialog,
            onSaveToRecipes: _saveToRecipesAndClose,
          ),
        ],
      ),
    );
  }
}
