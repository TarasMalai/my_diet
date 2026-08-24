// ============================================================================
// НАЗВА ФАЙЛУ: calendar_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Спільний візуальний віджет календаря з перемикачем днів
//              та викликом нашого кастомного діалогу вибору дати.
// ============================================================================

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: ІМПОРТИ СИСТЕМНИХ ПАКЕТІВ ТА МОДУЛІВ
// ----------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Потрібно для форматування дати та місяця

// [ВУЗОЛ 1.1: Кастомний діалог вибору дати]
// Імпортуємо наш діалог із вкладеної папки calendar_widget/
import 'package:my_diet/widgets/common_widget/calendar_widget/date_picker_dialog_widget.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 2]: ГОЛОВНИЙ КЛАС ВІДЖЕТА (CalendarWidget)
// ----------------------------------------------------------------------------
/// Віджет календаря з кнопками "Назад/Вперед" та клікабельним центром.
/// [ВУЗОЛ 2.0: StatelessWidget]
/// Віджет є безстатусним, оскільки повністю керується зовнішнім станом (selectedDate),
/// який передається з батьківського екрана або DateService.
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
    // [ВУЗОЛ 2.1.1]: ФОРМАТУВАННЯ ДАТИ (Називний відмінок для днів тижня)
    // ------------------------------------------------------------------------
    // Список днів тижня українською для коректного відображення в називному відмінку
    final List<String> days = ['Понеділок', 'Вівторок', 'Середа', 'Четвер', 'П’ятниця', 'Субота', 'Неділя'];

    // Отримуємо назву дня (називний відмінок) та день з місяцем
    final String dayName = days[selectedDate.weekday - 1];
    final String dateAndMonth = DateFormat('d MMMM', 'uk_UA').format(selectedDate);

    // Формуємо фінальні текстові рядки для відображення
    final String topRowText = '$dayName, $dateAndMonth';
    final String bottomRowText = DateFormat('yyyy', 'uk_UA').format(selectedDate);

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
                // Віднімаємо 1 день від поточної дати
                final previousDay = selectedDate.subtract(const Duration(days: 1));
                onDateSelected(previousDay);
              },
              tooltip: 'Попередній день',
            ),

            // ----------------------------------------------------------------
            // [ВУЗОЛ 2.1.2.2]: ЦЕНТРАЛЬНИЙ ДВОРЯДКОВИЙ БЛОК ДАТИ (Клікабельний)
            // ----------------------------------------------------------------
            Expanded(
              child: Center(
                child: InkWell(
                  // [ВУЗОЛ 2.1.2.2.1: Виклик кастомного DatePicker]
                  // Асинхронний виклик діалогового вікна вибору дати
                  onTap: () async {
                    final DateTime? pickedDate = await showCustomAppDatePicker(
                      context: context,
                      initialDate: selectedDate,
                    );

                    // Якщо користувач підтвердив вибір дати (натиснув "ОК")
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
                        // [ВУЗОЛ 2.1.2.2.2: Верхній рядок - день і місяць]
                        Text(
                          topRowText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 2),

                        // [ВУЗОЛ 2.1.2.2.3: Нижній рядок - рік]
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
            // [ВУЗОЛ 2.1.2.3]: ПРАВА КНОПКА (Наступний день)
            // ----------------------------------------------------------------
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.teal, size: 22),
              onPressed: () {
                // Додаємо 1 день до поточної дати
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
