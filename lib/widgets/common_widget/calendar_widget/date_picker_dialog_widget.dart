// ============================================================================
// НАЗВА ФАЙЛУ: date_picker_dialog_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Кастомний діалог календаря з двома блоками дат у лівій панелі,
//              сіткою днів місяця, навігацією та українською локалізацією.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: ГЛОБАЛЬНА ФУНКЦІЯ ВИКЛИКУ ДІАЛОГУ
// ----------------------------------------------------------------------------
/// Відкриває модальне вікно кастомного календаря із лівою панеллю.
/// Повертає обрану дату [DateTime] або `null`, якщо користувач натиснув "Скасувати".
Future<DateTime?> showCustomAppDatePicker({required BuildContext context, required DateTime initialDate}) {
  return showDialog<DateTime>(
    context: context,
    builder: (BuildContext context) {
      return CustomDatePickerDialog(initialDate: initialDate);
    },
  );
}

// ----------------------------------------------------------------------------
// [ВУЗОЛ 2]: ГОЛОВНИЙ КЛАС ДІАЛОГУ (StatefulWidget)
// ----------------------------------------------------------------------------
class CustomDatePickerDialog extends StatefulWidget {
  /// Початкова дата, що виділяється при першому відкритті вікна
  final DateTime initialDate;

  const CustomDatePickerDialog({super.key, required this.initialDate});

  @override
  State<CustomDatePickerDialog> createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.1]: ЗМІННІ СТАНУ КАЛЕНДАРЯ
  // --------------------------------------------------------------------------
  /// Активна вибрана дата користувачем у сітці
  late DateTime _selectedDate;

  /// Поточний місяць і рік, які відображаються у сітці календаря
  late DateTime _displayedMonth;

  /// Фіксована системна поточна дата ("Сьогодні")
  final DateTime _today = DateTime.now();

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.2]: ЖИТТЄВИЙ ЦИКЛ ТА ЛОГІКА СТАНУ
  // --------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    // Задаємо вибрану дату з переданих параметрів
    _selectedDate = widget.initialDate;
    // Встановлюємо перший день місяця для відображення відповідної сітки
    _displayedMonth = DateTime(widget.initialDate.year, widget.initialDate.month);
  }

  /// Метод переключення відображуваного місяця на один вперед або назад
  void _changeMonth(int increment) {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + increment);
    });
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.3]: ВІЗУАЛЬНИЙ КАРКАС ДІАЛОГУ (BUILD)
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Закруглення кутів вікна діалогу
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 520, // Фіксована ширина діалогового вікна
        height: 380, // Фіксована висота діалогового вікна
        padding: const EdgeInsets.all(16), // Внутрішній відступ від країв вікна
        child: Row(
          children: [
            // ----------------------------------------------------------------
            // [ВУЗОЛ 2.3.1]: ЛІВА ПАНЕЛЬ (Блоки "Вибрана дата" та "Поточна дата")
            // ----------------------------------------------------------------
            SizedBox(
              width: 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Верхній блок: Інформація про вибрану дату ---
                  _buildDateBlock(label: 'Вибрана дата', date: _selectedDate, isClickable: false, onTap: null),

                  const Spacer(), // Пружинний відступ для притискання нижнього блоку
                  // --- Нижній блок: Клікабельна поточна дата ("Сьогодні") ---
                  _buildDateBlock(
                    label: 'Поточна дата',
                    date: _today,
                    isClickable: true,
                    onTap: () {
                      setState(() {
                        // Перемикаємо вибір та відкритий місяць на сьогоднішній день
                        _selectedDate = _today;
                        _displayedMonth = DateTime(_today.year, _today.month);
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            // ----------------------------------------------------------------
            // [ВУЗОЛ 2.3.2]: РОЗДІЛЮВАЧ (Вертикальна лінія)
            // ----------------------------------------------------------------
            const VerticalDivider(width: 24, thickness: 1, color: Colors.grey),

            // ----------------------------------------------------------------
            // [ВУЗОЛ 2.3.3]: ПРАВА ПАНЕЛЬ (Місяць, дні тижня, сітка і кнопки)
            // ----------------------------------------------------------------
            Expanded(
              child: Column(
                children: [
                  // --- Шапка правої панелі: Назва місяця та стрілки навігації ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Текст місяця і року українською (наприклад, "серпень 2026 р.")
                      Text(
                        '${DateFormat('LLLL yyyy', 'uk_UA').format(_displayedMonth)} р.',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      // Кнопки перемикання місяців
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            tooltip: 'Попередній місяць',
                            onPressed: () => _changeMonth(-1),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.chevron_right, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            tooltip: 'Наступний місяць',
                            onPressed: () => _changeMonth(1),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // --- Рядок заголовків днів тижня (П, В, С, Ч, П, С, Н) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _DayHeader('П'),
                      _DayHeader('В'),
                      _DayHeader('С'),
                      _DayHeader('Ч'),
                      _DayHeader('П'),
                      _DayHeader('С'),
                      _DayHeader('Н'),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // --- Основна сітка днів місяця ---
                  Expanded(child: _buildCalendarGrid()),

                  // --- Нижній блок кнопок підтвердження/скасування ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Кнопка скасування (повертає null)
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(null),
                        child: const Text('Скасувати', style: TextStyle(color: Colors.teal)),
                      ),
                      // Кнопка підтвердження (повертає обрану дату)
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(_selectedDate),
                        child: const Text(
                          'ОК',
                          style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.4]: ДОПОМІЖНІ МЕТОДИ ПОБУДОВИ ЕЛЕМЕНТІВ
  // --------------------------------------------------------------------------

  /// [ВУЗОЛ 2.4.1: _buildDateBlock]
  /// Метод побудови текстового блоку дати для лівої панелі.
  Widget _buildDateBlock({
    required String label,
    required DateTime date,
    required bool isClickable,
    required VoidCallback? onTap,
  }) {
    // Перевірка: чи вибрана дата збігається з поточною системною датою ("Сьогодні")
    final bool isSameAsToday = DateUtils.isSameDay(_selectedDate, _today);

    // Динамічні кольори залежно від стану
    final Color bgColor = isClickable
        ? Colors.teal.shade50
        : (isSameAsToday ? Colors.teal.shade50 : Colors.amber.shade50);

    final Color borderColor = isClickable
        ? Colors.teal.shade200
        : (isSameAsToday ? Colors.teal.shade300 : Colors.amber.shade300);

    final Color labelColor = isClickable
        ? Colors.teal.shade800
        : (isSameAsToday ? Colors.teal.shade800 : Colors.amber.shade900);

    // Форматування тексту дати українською мовою
    final String dayOfWeek = DateFormat('EEEE', 'uk_UA').format(date);
    final String dayNum = DateFormat('d', 'uk_UA').format(date);
    final String monthName = DateFormat('MMMM', 'uk_UA').format(date);
    final String yearNum = DateFormat('yyyy', 'uk_UA').format(date);

    final Widget cardContent = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11, color: labelColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            dayOfWeek,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          Text(
            dayNum,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black, height: 1.1),
          ),
          Text(
            monthName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          Text(yearNum, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ],
      ),
    );

    if (!isClickable) return cardContent;

    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(10), child: cardContent);
  }

  /// [ВУЗОЛ 2.4.2: _buildCalendarGrid]
  /// Побудова динамічної сітки числових днів для обраного місяця.
  Widget _buildCalendarGrid() {
    final int daysInMonth = DateUtils.getDaysInMonth(_displayedMonth.year, _displayedMonth.month);
    final DateTime firstDayOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final int startingWeekday = firstDayOfMonth.weekday - 1; // Понеділок = 0

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: startingWeekday + daysInMonth,
      itemBuilder: (context, index) {
        if (index < startingWeekday) {
          return const SizedBox.shrink();
        }

        final int dayNumber = index - startingWeekday + 1;
        final DateTime currentDate = DateTime(_displayedMonth.year, _displayedMonth.month, dayNumber);

        final bool isSelected = DateUtils.isSameDay(currentDate, _selectedDate);
        final bool isToday = DateUtils.isSameDay(currentDate, _today);

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = currentDate;
            });
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors
                        .teal // Вибраний день
                  : isToday
                  ? Colors
                        .teal
                        .shade100 // Сьогоднішній день
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$dayNumber',
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? Colors.white
                    : isToday
                    ? Colors.teal.shade900
                    : Colors.black87,
                fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ----------------------------------------------------------------------------
// [ВУЗОЛ 3]: ДОПОМІЖНІ ВІДЖЕТИ
// ----------------------------------------------------------------------------
/// Віджет заголовка одного дня тижня в шапці сітки календаря.
class _DayHeader extends StatelessWidget {
  final String day;

  const _DayHeader(this.day);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        day,
        style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.bold),
      ),
    );
  }
}
