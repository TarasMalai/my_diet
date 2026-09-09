// ============================================================================
// НАЗВА ФАЙЛУ: cooking_bottom_panel_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Нижня панель керування: тара, фінальна вага, чекбокс тари,
//              нотатки та кнопки дій
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CookingBottomPanelWidget extends StatelessWidget {
  final TextEditingController tareController;
  final TextEditingController finalWeightController;
  final TextEditingController notesController;
  final bool useTare;
  final ValueChanged<bool?> onUseTareChanged;
  final VoidCallback onAddIngredient;
  final VoidCallback onSaveToRecipes;

  const CookingBottomPanelWidget({
    super.key,
    required this.tareController,
    required this.finalWeightController,
    required this.notesController,
    required this.useTare,
    required this.onUseTareChanged,
    required this.onAddIngredient,
    required this.onSaveToRecipes,
  });

  void _showNotesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Нотатки до страви'),
        content: TextField(
          controller: notesController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Введіть коментарі чи деталі приготування...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Готово'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasNotes = notesController.text.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, -2))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ==================================================================
          // [ВУЗОЛ 1]: Поля "Вага тари" та "Фінальна вага"
          // ==================================================================
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: tareController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*[\.,]?\d*'))],
                  decoration: const InputDecoration(
                    labelText: 'Вага тари (г)',
                    hintText: '0.0',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: finalWeightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*[\.,]?\d*'))],
                  decoration: const InputDecoration(
                    labelText: 'Фінальна вага (г)',
                    hintText: '0.0',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),

          // ==================================================================
          // [ВУЗОЛ 2]: Чекбокс "Враховувати тару"
          // ==================================================================
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Checkbox(
                value: useTare,
                onChanged: onUseTareChanged,
                activeColor: Colors.orange.shade800,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              GestureDetector(
                onTap: () => onUseTareChanged(!useTare),
                child: const Text('Враховувати тару', style: TextStyle(fontSize: 13, color: Colors.black87)),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // ==================================================================
          // [ВУЗОЛ 3]: Рядок кнопок дій (+Інгредієнт, Нотатки, В Рецепти)
          // ==================================================================
          Row(
            children: [
              Expanded(
                flex: 3,
                child: ElevatedButton.icon(
                  onPressed: onAddIngredient,
                  icon: const Icon(Icons.add, size: 20, color: Colors.white),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Інгредієнт',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade800,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 4,
                child: ElevatedButton(
                  onPressed: () => _showNotesDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasNotes ? Colors.orange.shade200 : Colors.orange.shade100,
                    foregroundColor: Colors.orange.shade900,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Icon(hasNotes ? Icons.note_alt : Icons.note_add_outlined, size: 24),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: ElevatedButton.icon(
                  onPressed: onSaveToRecipes,
                  icon: const Icon(Icons.inventory_2_outlined, size: 20, color: Colors.white),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'В Рецепти',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade800,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
