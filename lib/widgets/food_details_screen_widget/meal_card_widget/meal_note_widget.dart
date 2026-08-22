// ============================================================================
// НАЗВА ФАЙЛУ: meal_note_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Окремий віджет відображення нотатки прийому їжі
// ============================================================================

import 'package:flutter/material.dart';

/// [ВУЗОЛ 1]: ВІДЖЕТ НОТАТКИ ПРИЙОМУ ЇЖІ
class MealNoteWidget extends StatelessWidget {
  final String note;

  const MealNoteWidget({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    // Якщо нотатка порожня — віджет нічого не малює на екрані
    if (note.trim().isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.amber.shade200),
          ),
          child: Text(
            '📝 Нотатка: $note',
            style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black87, fontSize: 13),
          ),
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }
}
