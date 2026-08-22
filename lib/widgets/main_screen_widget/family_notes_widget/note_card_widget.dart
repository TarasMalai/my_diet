// ============================================================================
// НАЗВА ФАЙЛУ: note_card_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Віджет однієї картки сімейної нотатки з індикацією пріоритету
// ============================================================================

import 'package:flutter/material.dart';
import '../../../models/note_model.dart';

class NoteCardWidget extends StatelessWidget {
  final FamilyNote note;
  final VoidCallback? onEdit; // Колбек для редагування
  final VoidCallback? onDelete; // Колбек для видалення

  const NoteCardWidget({super.key, required this.note, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
        // Робимо кольорову лінію зліва відповідно до пріоритету нотатки
        border: Border(left: BorderSide(color: note.priorityColor, width: 5.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Шапка картки: Автор, час та дії (редагування/видалення)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  note.authorName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blueGrey),
                ),
                Row(
                  children: [
                    Text(
                      '${note.timestamp.hour.toString().padLeft(2, '0')}:${note.timestamp.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                    if (onEdit != null) ...[
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: onEdit,
                        borderRadius: BorderRadius.circular(4),
                        child: Icon(Icons.edit_outlined, size: 16, color: Colors.blueGrey.shade400),
                      ),
                    ],
                    if (onDelete != null) ...[
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: onDelete,
                        borderRadius: BorderRadius.circular(4),
                        child: Icon(Icons.close, size: 16, color: Colors.grey.shade400),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Текст повідомлення
            Text(note.content, style: const TextStyle(fontSize: 14, color: Colors.black87)),

            // Блок вкладеного файлу (якщо він є)
            if (note.attachmentPath != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      note.isImage ? Icons.image : Icons.picture_as_pdf,
                      size: 16,
                      color: note.isImage ? Colors.blue : Colors.red,
                    ),
                    const SizedBox(width: 6),
                    const Text('Прикріплений файл', style: TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
