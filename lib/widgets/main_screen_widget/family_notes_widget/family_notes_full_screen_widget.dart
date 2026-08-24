// ============================================================================
// НАЗВА ФАЙЛУ: family_notes_full_screen.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Повноцінне вікно для перегляду та керування сімейними нотатками
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/models/note_model.dart';
import 'package:my_diet/widgets/main_screen_widget/family_notes_widget/note_card_widget.dart';
import 'package:my_diet/widgets/main_screen_widget/family_notes_widget/add_note_dialog_widget.dart';
import 'package:my_diet/widgets/main_screen_widget/family_notes_widget/edit_note_dialog_widget.dart'; // <--- Імпортуємо наш новий віджет

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: ГОЛОВНИЙ КЛАС ЕКРАНУ СІМЕЙНИХ НОТАТОК (FamilyNotesFullScreen)
// ----------------------------------------------------------------------------
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

// ----------------------------------------------------------------------------
// [ВУЗОЛ 2]: СТАН ЕКРАНУ СІМЕЙНИХ НОТАТОК (_FamilyNotesFullScreenState)
// ----------------------------------------------------------------------------
class _FamilyNotesFullScreenState extends State<FamilyNotesFullScreen> {
  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.1]: ВІЗУАЛЬНИЙ КАРКАС ТА ІНТЕРФЕЙС (BUILD)
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ----------------------------------------------------------------------
      // [ВУЗОЛ 2.1.1]: APPBAR ТА КНОПКА ДОДАВАННЯ НОТАТКИ
      // ----------------------------------------------------------------------
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
      // ----------------------------------------------------------------------
      // [ВУЗОЛ 2.1.2]: ТІЛО ЕКРАНУ (СПИСОК АБО ПУСТИЙ СТАН)
      // ----------------------------------------------------------------------
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
