// ============================================================================
// НАЗВА ФАЙЛУ: cooking_screen.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Екран кухні — збір інгредієнтів, розрахунок та збереження страви в Інвентар
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/services/cooking_service.dart';
import 'package:my_diet/widgets/databases_and_resources_widget/cooking_widgets/add_cooking_ingredient_dialog_widget.dart';
import 'package:my_diet/widgets/databases_and_resources_widget/cooking_widgets/cooking_bottom_panel_widget.dart';
import 'package:my_diet/widgets/databases_and_resources_widget/cooking_widgets/cooking_ingredients_list_widget.dart';
import 'package:my_diet/widgets/databases_and_resources_widget/cooking_widgets/cooking_totals_header_widget.dart';
import 'package:my_diet/models/cooking_history_model.dart';
import 'package:my_diet/services/cooking_history_service.dart';
import 'package:my_diet/models/food_item_model.dart';

class CookingScreen extends StatefulWidget {
  const CookingScreen({super.key});

  @override
  State<CookingScreen> createState() => _CookingScreenState();
}

class _CookingScreenState extends State<CookingScreen> {
  final CookingService _cookingService = CookingService();
  final _dishNameController = TextEditingController();
  final _finalWeightController = TextEditingController();

  @override
  void dispose() {
    _dishNameController.dispose();
    _finalWeightController.dispose();
    super.dispose();
  }

  /// Оновити стан екрана для перемальовування інтерфейсу
  void _refresh() {
    setState(() {});
  }

  /// Відкрити діалог перегляду історії приготування з розгортанням інгредієнтів
  void _openHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Історія готування (за 10 днів)'),
              content: SizedBox(
                width: 600,
                height: 500,
                child: FutureBuilder<List<CookingHistoryModel>>(
                  future: CookingHistoryService.loadHistory(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final history = snapshot.data ?? [];
                    if (history.isEmpty) {
                      return const Center(
                        child: Text(
                          'Історія порожня\n(записи зберігаються до 10 днів)',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final record = history[index];
                        final dateStr = '${record.cookedAt.day}.${record.cookedAt.month}.${record.cookedAt.year}';

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ExpansionTile(
                            title: Text(record.dishName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('Вага: ${record.finalWeight} г  |  Дата: $dateStr'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              tooltip: 'Видалити з історії',
                              onPressed: () async {
                                await CookingHistoryService.deleteRecipe(record.id);
                                setDialogState(() {}); // Оновлюємо список у діалозі
                              },
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Складові інгредієнти:',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.orange),
                                    ),
                                    const SizedBox(height: 6),
                                    ...record.ingredients.map(
                                      (ing) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text('• ${ing.name}', style: const TextStyle(fontSize: 13)),
                                            ),
                                            Text(
                                              '${ing.weight} г',
                                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton.icon(
                                        icon: const Icon(Icons.refresh, size: 18),
                                        label: const Text('Завантажити цей рецепт у котел'),
                                        onPressed: () {
                                          // Очищаємо поточний котел і завантажуємо інгредієнти з історії
                                          _cookingService.ingredients.clear();
                                          for (var ing in record.ingredients) {
                                            _cookingService.addIngredient(ing);
                                          }
                                          _dishNameController.text = record.dishName;
                                          _finalWeightController.text = record.finalWeight.toString();
                                          _refresh();

                                          Navigator.pop(context); // Закриваємо діалог історії
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Рецепт "${record.dishName}" завантажено в котел!'),
                                              backgroundColor: Colors.teal,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Закрити'))],
            );
          },
        );
      },
    );
  }

  /// Відкрити діалогове вікно для вибору та додавання інгредієнта
  void _openAddIngredientDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AddCookingIngredientDialogWidget(onAdded: () => _refresh());
      },
    );
  }

  /// Завершити готування, перевірити поля та зберегти готову страву в Інвентар
  void _finishCooking() async {
    final name = _dishNameController.text.trim();
    final finalWeight = double.tryParse(_finalWeightController.text.replaceAll(',', '.')) ?? 0.0;

    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Введіть назву готової страви!'), backgroundColor: Colors.red));
      return;
    }

    if (finalWeight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Введіть реальну фінальну вагу страви після приготування!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Робимо копію інгредієнтів ДО того, як котел очиститься всередині сервісу
    final currentIngredients = List<FoodItemModel>.from(_cookingService.ingredients);

    final success = _cookingService.finishCookingAndSaveToPantry(name, finalWeight);

    if (success) {
      // Зберігаємо рецепт в історію з повною копією інгредієнтів
      final historyRecord = CookingHistoryModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        dishName: name,
        finalWeight: finalWeight,
        ingredients: currentIngredients,
        cookedAt: DateTime.now(),
      );
      await CookingHistoryService.saveRecipe(historyRecord);

      // Безпечна перевірка після асинхронної операції
      if (!mounted) return;

      _dishNameController.clear();
      _finalWeightController.clear();
      _refresh();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Страву "$name" успішно збережено в Інвентар та в історію!'),
          backgroundColor: Colors.teal,
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Додайте хоча б один інгредієнт до казана!'), backgroundColor: Colors.orange),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ingredients = _cookingService.ingredients;
    final totals = _cookingService.calculateTotals();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Кухня (Готування страв)'),
        backgroundColor: Colors.orange.shade800,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Історія приготування',
            onPressed: () => _openHistoryDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Верхня панель загальних підсумків
          CookingTotalsHeaderWidget(totals: totals),
          const Divider(height: 1),

          // Список доданих інгредієнтів
          Expanded(
            child: CookingIngredientsListWidget(
              ingredients: ingredients,
              onDelete: (id) {
                _cookingService.removeIngredient(id);
                _refresh();
              },
            ),
          ),

          // Нижня панель введення назви, ваги та збереження
          CookingBottomPanelWidget(
            nameController: _dishNameController,
            finalWeightController: _finalWeightController,
            onFinishCooking: _finishCooking,
          ),
        ],
      ),
      // Плаваюча кнопка для додавання нового інгредієнта
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddIngredientDialog(context),
        backgroundColor: Colors.orange.shade800,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Додати інгредієнт', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
