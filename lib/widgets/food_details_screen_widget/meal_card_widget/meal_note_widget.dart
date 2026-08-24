// ============================================================================
// НАЗВА ФАЙЛУ: meal_note_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Інтерактивний віджет нотатки/коментаря прийому їжі (сірий/оранжевий)
// ============================================================================

import 'package:flutter/material.dart';

/// [ВУЗОЛ 1]: ВІДЖЕТ НОТАТКИ ПРИЙОМУ ЇЖІ
class MealNoteWidget extends StatelessWidget {
  final String note;
  final VoidCallback onTap; // Дія при натисканні (відкриття діалогу вводу/редагування)

  const MealNoteWidget({super.key, required this.note, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool hasNote = note.trim().isNotEmpty;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            decoration: BoxDecoration(
              // Динамічний колір: сірий, якщо порожньо, або оранжевий, якщо є нотатка
              color: hasNote ? Colors.orange.shade50 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: hasNote ? Colors.orange.shade300 : Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(
                  hasNote ? Icons.edit_note_rounded : Icons.add_comment_outlined,
                  size: 18.0,
                  color: hasNote ? Colors.orange.shade800 : Colors.grey.shade600,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    hasNote ? '📝 $note' : 'Додати нотатку або коментар...',
                    style: TextStyle(
                      fontStyle: hasNote ? FontStyle.normal : FontStyle.italic,
                      color: hasNote ? Colors.black87 : Colors.grey.shade600,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }
}
