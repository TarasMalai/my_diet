// ============================================================================
// НАЗВА ФАЙЛУ: calendar_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Спільний візуальний віджет календаря з перемикачем днів,
//              кольоровою рамкою статусу (збігається з date_picker_dialog_widget.dart)
//              та викликом кастомного діалогу вибору дати.
// ============================================================================

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: ІМПОРТИ СИСТЕМНИХ ПАКЕТІВ ТА МОДУЛІВ
// ----------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Потрібно для форматування дати та місяця

// [ВУЗОЛ 1.1: Кастомний діалог вибору дати]
import 'package:my_diet/widgets/common_widget/calendar_widget/date_picker_dialog_widget.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 2]: ГОЛОВНИЙ КЛАС ВІДЖЕТА (CalendarWidget)
// ----------------------------------------------------------------------------
/// Віджет календаря з кнопками "Назад/Вперед" та клікабельним центром.
class CalendarWidget extends StatelessWidget {
  /// Поточна обрана дата у форматі DateTime
  final DateTime selectedDate;

  /// Функція зворотного виклику (callback) для передачі обраної дати нагору
  final Function(DateTime) onDateSelected;

  const CalendarWidget({super.key, required this.selectedDate, required this.onDateSelected});

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.1]: ПОБУДОВА ІНТЕРФЕЙСУ (BUILD)
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    // ------------------------------------------------------------------------
    // [ВУЗОЛ 2.1.1]: ФОРМАТУВАННЯ ДАТИ ТА ПЕРЕВІРКА СТАТУСУ СЬОГОДНІ
    // ------------------------------------------------------------------------
    final List<String> days = ['Понеділок', 'Вівторок', 'Середа', 'Четвер', 'П’ятниця', 'Субота', 'Неділя'];

    final String dayName = days[selectedDate.weekday - 1];
    final String dateAndMonth = DateFormat('d MMMM', 'uk_UA').format(selectedDate);

    final String topRowText = '$dayName, $dateAndMonth';
    final String bottomRowText = DateFormat('yyyy', 'uk_UA').format(selectedDate);

    // [ВУЗОЛ 2.1.1.1: Перевірка збігу з поточною датою через DateUtils]
    final DateTime today = DateTime.now();
    final bool isSameAsToday = DateUtils.isSameDay(selectedDate, today);

    // [ВУЗОЛ 2.1.1.2: Точна кольорова палітра з date_picker_dialog_widget.dart]
    final Color bgColor = isSameAsToday ? Colors.teal.shade50 : Colors.amber.shade50;
    final Color borderColor = isSameAsToday ? Colors.teal.shade300 : Colors.amber.shade300;
    final Color textColor = isSameAsToday ? Colors.teal.shade800 : Colors.amber.shade900;

    // ------------------------------------------------------------------------
    // [ВУЗОЛ 2.1.2]: ВІЗУАЛЬНИЙ КАРКАС ВІДЖЕТА (Card)
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
            // [ВУЗОЛ 2.1.2.1]: ЛІВА КНОПКА (Попередній день)
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
            // [ВУЗОЛ 2.1.2.2]: ЦЕНТРАЛЬНИЙ БЛОК ДАТИ З ТОЧНИМ СТИЛЕМ ДІАЛОГУ
            // ----------------------------------------------------------------
            Expanded(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: borderColor, width: 1.2),
                  ),
                  child: InkWell(
                    onTap: () async {
                      final DateTime? pickedDate = await showCustomAppDatePicker(
                        context: context,
                        initialDate: selectedDate,
                      );

                      if (pickedDate != null) {
                        onDateSelected(pickedDate);
                      }
                    },
                    borderRadius: BorderRadius.circular(10.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // [ВУЗОЛ 2.1.2.2.1: День і місяць]
                          Text(
                            topRowText,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
                          ),
                          const SizedBox(height: 2),

                          // [ВУЗОЛ 2.1.2.2.2: Рік]
                          Text(
                            bottomRowText,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ----------------------------------------------------------------
            // [ВУЗОЛ 2.1.2.3]: ПРАВА КНОПКА (Наступний день)
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
