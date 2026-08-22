// ============================================================================
// НАЗВА ФАЙЛУ: edit_note_dialog_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Діалогове вікно для редагування існуючої нотатки з вибором пріоритету
// ============================================================================

import 'package:flutter/material.dart';
import '../../../models/note_model.dart';

class EditNoteDialogWidget extends StatefulWidget {
  final FamilyNote note;
  final Function(FamilyNote) onNoteEdited;

  const EditNoteDialogWidget({super.key, required this.note, required this.onNoteEdited});

  @override
  State<EditNoteDialogWidget> createState() => _EditNoteDialogWidgetState();
}

class _EditNoteDialogWidgetState extends State<EditNoteDialogWidget> {
  late TextEditingController _textController;
  late NotePriority _selectedPriority;

  @override
  void initState() {
    super.initState();
    // Заповнюємо початковими даними існуючої нотатки
    _textController = TextEditingController(text: widget.note.content);
    _selectedPriority = widget.note.priority;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // Допоміжний метод для отримання кольору пріоритету
  Color _getPriorityColor(NotePriority priority) {
    switch (priority) {
      case NotePriority.low:
        return Colors.green.shade400;
      case NotePriority.medium:
        return Colors.amber.shade600;
      case NotePriority.high:
        return Colors.red.shade600;
    }
  }

  // Допоміжний метод для отримання назви пріоритету
  String _getPriorityName(NotePriority priority) {
    switch (priority) {
      case NotePriority.low:
        return 'Низький';
      case NotePriority.medium:
        return 'Середній';
      case NotePriority.high:
        return 'Високий';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, top: 24, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        // Динамічна тонка рамка у верхній частині вікна відповідно до обраного кольору
        border: Border(top: BorderSide(color: _getPriorityColor(_selectedPriority), width: 4.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Редагувати нотатку',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'Введіть текст повідомлення...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _getPriorityColor(_selectedPriority), width: 2),
              ),
            ),
            maxLines: 3,
            autofocus: true,
          ),
          const SizedBox(height: 18),

          // Підпис перед вибором пріоритету
          const Text(
            'Оберіть пріоритет повідомлення:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 10),

          // Кнопки вибору пріоритету з кольоровою підсвіткою
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: NotePriority.values.map((priority) {
              final isSelected = _selectedPriority == priority;
              final color = _getPriorityColor(priority);

              return ChoiceChip(
                label: Text(
                  _getPriorityName(priority),
                  style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
                ),
                selected: isSelected,
                selectedColor: color,
                backgroundColor: Colors.grey.shade100,
                onSelected: (selected) {
                  setState(() {
                    _selectedPriority = priority;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Кнопка збереження змін
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _getPriorityColor(_selectedPriority),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                if (_textController.text.trim().isNotEmpty) {
                  // Зберігаємо змінений текст і пріоритет, зберігаючи при цьому ID, автора та час
                  final updatedNote = FamilyNote(
                    id: widget.note.id,
                    authorName: widget.note.authorName,
                    content: _textController.text.trim(),
                    priority: _selectedPriority,
                    timestamp: widget.note.timestamp,
                  );
                  widget.onNoteEdited(updatedNote);
                  Navigator.pop(context);
                }
              },
              child: const Text('Зберегти зміни', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
