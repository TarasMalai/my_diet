// ============================================================================
// НАЗВА ФАЙЛУ: family_notes_full_screen.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Повноцінне вікно для перегляду та керування сімейними нотатками
// ============================================================================

import 'package:flutter/material.dart';
import '../../../models/note_model.dart';
import 'note_card_widget.dart';
import 'add_note_dialog_widget.dart';
import 'edit_note_dialog_widget.dart'; // <--- Імпортуємо наш новий віджет

class FamilyNotesFullScreen extends StatefulWidget {
  final List<FamilyNote> notes;
  final Function(FamilyNote) onNoteAdded;
  final Function(int, FamilyNote) onNoteEdited;
  final Function(int) onNoteDeleted;

  const FamilyNotesFullScreen({
    super.key,
    required this.notes,
    required this.onNoteAdded,
    required this.onNoteEdited,
    required this.onNoteDeleted,
  });

  @override
  State<FamilyNotesFullScreen> createState() => _FamilyNotesFullScreenState();
}

class _FamilyNotesFullScreenState extends State<FamilyNotesFullScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сімейні нотатки та архів'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => AddNoteDialogWidget(
                  onNoteAdded: (newNote) {
                    widget.onNoteAdded(newNote);
                    setState(() {});
                  },
                ),
              );
            },
            tooltip: 'Додати нотатку',
          ),
        ],
      ),
      body: widget.notes.isEmpty
          ? const Center(
              child: Text('Поки немає жодних нотаток', style: TextStyle(color: Colors.grey, fontSize: 16)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: widget.notes.length,
              itemBuilder: (context, index) {
                final note = widget.notes[index];
                return NoteCardWidget(
                  note: note,
                  onEdit: () {
                    // Відкриваємо новий віджет редагування
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => EditNoteDialogWidget(
                        note: note,
                        onNoteEdited: (updatedNote) {
                          widget.onNoteEdited(index, updatedNote);
                          setState(() {}); // Оновлюємо список
                        },
                      ),
                    );
                  },
                  onDelete: () {
                    widget.onNoteDeleted(index);
                    setState(() {});
                  },
                );
              },
            ),
    );
  }
}
