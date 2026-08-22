// ============================================================================
// НАЗВА ФАЙЛУ: calendar_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Спільний візуальний віджет календаря з перемикачем днів
//              та викликом нашого кастомного діалогу вибору дати.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Імпортуємо наш кастомний діалог із сусідньої папки
import 'calendar_widget/date_picker_dialog_widget.dart';

// ----------------------------------------------------------------------------
// ВУЗОЛ 1: ГОЛОВНИЙ КЛАС ВІДЖЕТА (CalendarWidget)
// ----------------------------------------------------------------------------
class CalendarWidget extends StatelessWidget {
  /// Поточна обрана дата у форматі DateTime
  final DateTime selectedDate;

  /// Функція зворотного виклику для оновлення дати в батьківському екрані
  final Function(DateTime) onDateSelected;

  const CalendarWidget({super.key, required this.selectedDate, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    // ------------------------------------------------------------------------
    // ВУЗОЛ 1.1: ФОРМАТУВАННЯ ДАТИ (називний відмінок для днів тижня)
    // ------------------------------------------------------------------------
    final List<String> days = ['Понеділок', 'Вівторок', 'Середа', 'Четвер', 'П’ятниця', 'Субота', 'Неділя'];

    // Отримуємо назву дня (називний відмінок) та день з місяцем
    final String dayName = days[selectedDate.weekday - 1];
    final String dateAndMonth = DateFormat('d MMMM', 'uk_UA').format(selectedDate);

    // Формуємо фінальний рядок
    final String topRowText = '$dayName, $dateAndMonth';
    final String bottomRowText = DateFormat('yyyy', 'uk_UA').format(selectedDate);

    // ------------------------------------------------------------------------
    // ВУЗОЛ 1.2: ВІЗУАЛЬНИЙ КАРКАС ВІДЖЕТА
    // ------------------------------------------------------------------------
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ----------------------------------------------------------------
            // ВУЗОЛ 1.2.1: ЛІВА КНОПКА (попередній день)
            // ----------------------------------------------------------------
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.teal, size: 22),
              onPressed: () {
                final previousDay = selectedDate.subtract(const Duration(days: 1));
                onDateSelected(previousDay);
              },
              tooltip: 'Попередній день',
            ),

            // ----------------------------------------------------------------
            // ВУЗОЛ 1.2.2: ЦЕНТРАЛЬНИЙ ДВОРЯДКОВИЙ БЛОК ДАТИ (Клікабельний)
            // ----------------------------------------------------------------
            Expanded(
              child: Center(
                child: InkWell(
                  onTap: () async {
                    // Викликаємо наш кастомний діалог та чекаємо на результат
                    final DateTime? pickedDate = await showCustomAppDatePicker(
                      context: context,
                      initialDate: selectedDate,
                    );

                    // Якщо користувач обрав дату і натиснув "ОК" (не null)
                    if (pickedDate != null) {
                      onDateSelected(pickedDate);
                    }
                  },
                  borderRadius: BorderRadius.circular(8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Верхній рядок (день і місяць)
                        Text(
                          topRowText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 2),
                        // Нижній рядок (рік)
                        Text(
                          bottomRowText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ----------------------------------------------------------------
            // ВУЗОЛ 1.2.3: ПРАВА КНОПКА (наступний день)
            // ----------------------------------------------------------------
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.teal, size: 22),
              onPressed: () {
                final nextDay = selectedDate.add(const Duration(days: 1));
                onDateSelected(nextDay);
              },
              tooltip: 'Наступний день',
            ),
          ],
        ),
      ),
    );
  }
}
