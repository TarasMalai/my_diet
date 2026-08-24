// ============================================================================
// НАЗВА ФАЙЛУ: family_notes_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Компактна мініатюра-індикатор сімейних нотаток для головного екрана
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/models/note_model.dart';
import 'package:my_diet/widgets/main_screen_widget/family_notes_widget/family_notes_full_screen_widget.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: ГОЛОВНИЙ КЛАС ВІДЖЕТА СІМЕЙНИХ НОТАТОК (FamilyNotesWidget)
// ----------------------------------------------------------------------------
class FamilyNotesWidget extends StatefulWidget {
  const FamilyNotesWidget({super.key});

  @override
  State<FamilyNotesWidget> createState() => _FamilyNotesWidgetState();
}

// ----------------------------------------------------------------------------
// [ВУЗОЛ 2]: СТАН ВІДЖЕТА (_FamilyNotesWidgetState)
// ----------------------------------------------------------------------------
class _FamilyNotesWidgetState extends State<FamilyNotesWidget> {
  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.1]: ДАНІ ТА СТАН НОТАТОК
  // --------------------------------------------------------------------------
  // Тестовий список нотаток
  final List<FamilyNote> _notes = [
    FamilyNote(
      id: '1',
      authorName: 'Мама (Адміністратор)',
      content: 'Зверніть увагу: сьогодні зменшуємо кількість білка на 5г.',
      priority: NotePriority.medium,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  // Визначаємо загальний колір рамки на основі найвищого пріоритету серед нотаток
  Color get _indicatorColor {
    if (_notes.isEmpty) {
      return Colors.grey.shade300; // Якщо немає нотаток — нейтральний сірий
    }
    if (_notes.any((n) => n.priority == NotePriority.high)) {
      return Colors.red.shade400; // Є червоні — підсвічуємо червоним
    }
    if (_notes.any((n) => n.priority == NotePriority.medium)) {
      return Colors.amber.shade600; // Є жовті — жовтим
    }
    return Colors.green.shade500; // Якщо є тільки зелені (низькі) — підсвічуємо зеленим
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.2]: ВІЗУАЛЬНИЙ КАРКАС ТА НАВІГАЦІЯ (BUILD)
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Відкриваємо повноцінне вікно нотаток на весь екран
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FamilyNotesFullScreen(
              notes: _notes,
              onNoteAdded: (newNote) {
                setState(() {
                  _notes.insert(0, newNote);
                });
              },
              onNoteEdited: (index, updatedNote) {
                setState(() {
                  _notes[index] = updatedNote;
                });
              },
              onNoteDeleted: (index) {
                setState(() {
                  _notes.removeAt(index);
                });
              },
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: _indicatorColor, width: _notes.isEmpty ? 1.0 : 2.0),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            // ----------------------------------------------------------------
            // [ВУЗОЛ 2.2.1]: ІКОНКА ІНДИКАТОРА
            // ----------------------------------------------------------------
            Icon(Icons.chat_bubble_outline, color: _notes.isEmpty ? Colors.blueGrey : _indicatorColor, size: 22),
            const SizedBox(width: 12),

            // ----------------------------------------------------------------
            // [ВУЗОЛ 2.2.2]: ТЕКСТОВИЙ БЛОК (ЗАГОЛОВОК ТА КІЛЬКІСТЬ)
            // ----------------------------------------------------------------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Сімейні нотатки',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _notes.isEmpty ? 'Немає активних повідомлень' : 'Активних нотаток: ${_notes.length}',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            // ----------------------------------------------------------------
            // [ВУЗОЛ 2.2.3]: СТРІЛОЧКА ПЕРЕХОДУ
            // ----------------------------------------------------------------
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
