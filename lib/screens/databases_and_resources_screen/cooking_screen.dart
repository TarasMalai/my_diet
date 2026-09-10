// ============================================================================
// НАЗВА ФАЙЛУ: cooking_screen.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Головний екран процесу готування з можливістю завершення страв
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/services/cooking_service.dart';
import 'package:my_diet/widgets/common_widget/banner_widget/app_scaffold_widget.dart';
import 'package:my_diet/screens/databases_and_resources_screen/cooking_screen/cooking_detail_screen.dart';

class CookingScreen extends StatefulWidget {
  const CookingScreen({super.key});

  @override
  State<CookingScreen> createState() => _CookingScreenState();
}

class _CookingScreenState extends State<CookingScreen> {
  final CookingService _cookingService = CookingService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  String _getIngredientsPreview(List<dynamic> ingredients) {
    if (ingredients.isEmpty) return 'Без інгредієнтів';

    final names = ingredients.map((ing) => ing.name.toString()).where((n) => n.isNotEmpty).toList();
    if (names.isEmpty) return 'Без інгредієнтів';

    if (names.length <= 3) {
      return names.join(', ');
    } else {
      return '${names.take(3).join(', ')} (+ще ${names.length - 3})';
    }
  }

  Future<void> _loadData() async {
    await _cookingService.init();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _refresh() => setState(() {});

  Future<void> _createNewDishAndOpen() async {
    final navigator = Navigator.of(context);
    final newDish = await _cookingService.createNewDish();
    if (!mounted) return;

    await navigator.push(MaterialPageRoute(builder: (context) => CookingDetailScreen(dish: newDish)));

    // Якщо зародили страву і нічого не додали — прибираємо з порожніх чернеток
    if (newDish.ingredients.isEmpty && newDish.name.trim().isEmpty) {
      await _cookingService.deleteActiveDish(newDish.id);
    }

    _refresh();
  }

  void _showArchiveDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final archivedDishes = _cookingService.archivedDishes;
            return AlertDialog(
              title: const Text('Архів приготовлених страв (10 днів)'),
              content: SizedBox(
                width: double.maxFinite,
                child: archivedDishes.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Архів порожній', textAlign: TextAlign.center),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: archivedDishes.length,
                        itemBuilder: (context, index) {
                          final archivedDish = archivedDishes[index];
                          return Card(
                            elevation: 1.5,
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: ExpansionTile(
                              title: Text(
                                archivedDish.name.isEmpty ? 'Без назви' : archivedDish.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Склад: ${_getIngredientsPreview(archivedDish.ingredients)}\n'
                                'Маса: ${archivedDish.netWeight.toStringAsFixed(0)} г  |  ФА: ${archivedDish.totalPhe.toStringAsFixed(1)} мг  |  Ккал: ${archivedDish.totalCalories.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                                tooltip: 'Видалити з архіву',
                                onPressed: () async {
                                  await _cookingService.deleteFromArchive(archivedDish.id);
                                  setDialogState(() {});
                                  _refresh();
                                },
                              ),
                              children: [
                                const Divider(height: 1),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Інгредієнти:',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                      const SizedBox(height: 4),
                                      ...archivedDish.ingredients.map(
                                        (ing) => Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text('• ${ing.name}', style: const TextStyle(fontSize: 12)),
                                              ),
                                              Text(
                                                '${ing.weight.toStringAsFixed(0)} г | ${ing.phe.toStringAsFixed(1)} мг ФА',
                                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (archivedDish.notes.isNotEmpty) ...[
                                        const SizedBox(height: 8),
                                        Text(
                                          'Нотатки: ${archivedDish.notes}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          icon: const Icon(Icons.replay, size: 18),
                                          label: const Text('Готувати знову'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.orange.shade800,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                          ),
                                          onPressed: () async {
                                            Navigator.pop(dialogContext);
                                            final newDish = await _cookingService.cookAgain(archivedDish);
                                            if (!context.mounted) return;
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => CookingDetailScreen(dish: newDish),
                                              ),
                                            );
                                            _refresh();
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
                      ),
              ),
              actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Закрити'))],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return AppScaffoldWidget(
        appBar: AppBar(
          title: const Text('Кухонний котел'),
          backgroundColor: Colors.orange.shade800,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    final activeDishes = _cookingService.activeDishes;

    return AppScaffoldWidget(
      appBar: AppBar(
        title: const Text('Кухонний котел'),
        backgroundColor: Colors.orange.shade800,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.inventory_2_outlined),
            tooltip: 'Архів страв (10 днів)',
            onPressed: _showArchiveDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: activeDishes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.soup_kitchen_outlined, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text('Немає страв у процесі', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: activeDishes.length,
                    itemBuilder: (context, index) {
                      final dish = activeDishes[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          // ЗЛІВА: Клікабельна кнопка-холодильник «Завершити та в інвентар»
                          leading: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () async {
                              await _cookingService.finishCooking(dish);
                              _refresh();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.green.shade300, width: 1.5),
                              ),
                              child: Icon(Icons.kitchen, color: Colors.green.shade700, size: 24),
                            ),
                          ),
                          title: Text(
                            dish.name.trim().isEmpty ? 'Нова страва' : dish.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Склад: ${_getIngredientsPreview(dish.ingredients)}\n'
                            'Маса: ${dish.netWeight.toStringAsFixed(0)} г  |  ФА: ${dish.totalPhe.toStringAsFixed(1)} мг  |  Ккал: ${dish.totalCalories.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          // СПРАВА: Тільки кошик для видалення чернетки
                          trailing: IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                            tooltip: 'Видалити чернетку',
                            onPressed: () async {
                              await _cookingService.deleteActiveDish(dish.id);
                              _refresh();
                            },
                          ),
                          onTap: () async {
                            final navigator = Navigator.of(context);
                            await navigator.push(
                              MaterialPageRoute(builder: (context) => CookingDetailScreen(dish: dish)),
                            );
                            _refresh();
                          },
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _createNewDishAndOpen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade800,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), // або 24, як було
                ),
                icon: const Icon(Icons.add),
                label: const Text('Готувати нову страву', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
