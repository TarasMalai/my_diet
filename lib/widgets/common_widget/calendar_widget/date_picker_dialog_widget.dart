// ============================================================================
// НАЗВА ФАЙЛУ: date_picker_dialog_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Кастомний діалог календаря з адаптивною версткою (Row для ПК,
//               Column для смартфонів), збільшеною шапкою та кнопками дій.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: ГЛОБАЛЬНА ФУНКЦІЯ ВИКЛИКУ ДІАЛОГУ
// ----------------------------------------------------------------------------
/// Відкриває модальне вікно кастомного календаря із лівою/нижньою панеллю.
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Автоматично визначаємо чи це мобільний екран (менше 450px)
          final bool isMobile = MediaQuery.of(context).size.width < 450;

          if (isMobile) {
            return _buildMobileLayout(context);
          } else {
            return _buildDesktopLayout(context);
          }
        },
      ),
    );
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.3.1]: ДЕСКТОПНИЙ ВАРІАНТ ВЕРСТКИ (ГОРИЗОНТАЛЬНИЙ ROW)
  // --------------------------------------------------------------------------
  Widget _buildDesktopLayout(BuildContext context) {
    return Container(
      width: 530,
      height: 390,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Ліва панель з двома блоками дат
          SizedBox(
            width: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateBlock(label: 'Вибрана дата', date: _selectedDate, isClickable: false, onTap: null),
                const Spacer(),
                _buildDateBlock(
                  label: 'Поточна дата',
                  date: _today,
                  isClickable: true,
                  onTap: () {
                    setState(() {
                      _selectedDate = _today;
                      _displayedMonth = DateTime(_today.year, _today.month);
                    });
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),

          const VerticalDivider(width: 24, thickness: 1, color: Colors.grey),

          // Права панель із календарем та кнопками
          Expanded(
            child: Column(
              children: [
                _buildMonthHeader(),
                const SizedBox(height: 10),
                _buildDaysOfWeekHeader(),
                const SizedBox(height: 6),
                Expanded(child: _buildCalendarGrid()),
                _buildActionButtons(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.3.2]: МОБІЛЬНИЙ ВАРІАНТ ВЕРСТКИ (ВЕРТИКАЛЬНИЙ COLUMN)
  // --------------------------------------------------------------------------
  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Шапка місяця та сітка
            _buildMonthHeader(),
            const SizedBox(height: 12),
            _buildDaysOfWeekHeader(),
            const SizedBox(height: 8),
            SizedBox(
              height: 230, // Фіксована висота сітки для мобільного
              child: _buildCalendarGrid(),
            ),
            const Divider(height: 20, thickness: 1),

            // Інформаційні блоки дат розміщуємо в один горизонтальний рядок знизу
            Row(
              children: [
                Expanded(
                  child: _buildDateBlock(label: 'Вибрана дата', date: _selectedDate, isClickable: false, onTap: null),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDateBlock(
                    label: 'Поточна дата',
                    date: _today,
                    isClickable: true,
                    onTap: () {
                      setState(() {
                        _selectedDate = _today;
                        _displayedMonth = DateTime(_today.year, _today.month);
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Кнопки дій знизу
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.4]: ДОПОМІЖНІ ВІДЖЕТИ ТА БЛОКИ
  // --------------------------------------------------------------------------

  /// [ВУЗОЛ 2.4.1]: Збільшена шапка місяця та більші стрілочки
  Widget _buildMonthHeader() {
    final rawMonth = DateFormat('LLLL yyyy', 'uk_UA').format(_displayedMonth);
    final formattedMonth = rawMonth[0].toUpperCase() + rawMonth.substring(1); // З великої літери

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Назва місяця і року (Збільшена)
        Text(
          '$formattedMonth р.',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal),
        ),
        // Кнопки гортання (Збільшені іконки та область кліку)
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, size: 28),
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(),
              tooltip: 'Попередній місяць',
              onPressed: () => _changeMonth(-1),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.chevron_right, size: 28),
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(),
              tooltip: 'Наступний місяць',
              onPressed: () => _changeMonth(1),
            ),
          ],
        ),
      ],
    );
  }

  /// [ВУЗОЛ 2.4.2]: Заголовки днів тижня
  Widget _buildDaysOfWeekHeader() {
    return Row(
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
    );
  }

  /// [ВУЗОЛ 2.4.3]: Повноцінні виділені кнопки дій ("Скасувати" та "ОК")
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Кнопка Скасувати
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.grey.shade700,
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Скасувати'),
        ),
        const SizedBox(width: 10),

        // Кнопка ОК
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
          ),
          onPressed: () => Navigator.of(context).pop(_selectedDate),
          child: const Text('ОК', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  /// [ВУЗОЛ 2.4.4]: Картка відображення дати
  Widget _buildDateBlock({
    required String label,
    required DateTime date,
    required bool isClickable,
    required VoidCallback? onTap,
  }) {
    final bool isSameAsToday = DateUtils.isSameDay(_selectedDate, _today);

    final Color bgColor = isClickable
        ? Colors.teal.shade50
        : (isSameAsToday ? Colors.teal.shade50 : Colors.amber.shade50);

    final Color borderColor = isClickable
        ? Colors.teal.shade200
        : (isSameAsToday ? Colors.teal.shade300 : Colors.amber.shade300);

    final Color labelColor = isClickable
        ? Colors.teal.shade800
        : (isSameAsToday ? Colors.teal.shade800 : Colors.amber.shade900);

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
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
          Text(
            dayNum,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black, height: 1.1),
          ),
          Text(
            monthName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
          Text(yearNum, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        ],
      ),
    );

    if (!isClickable) return cardContent;

    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(10), child: cardContent);
  }

  /// [ВУЗОЛ 2.4.5]: Сітка днів місяця
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
                  ? Colors.teal
                  : isToday
                  ? Colors.teal.shade100
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$dayNumber',
              style: TextStyle(
                fontSize: 13,
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
class _DayHeader extends StatelessWidget {
  final String day;

  const _DayHeader(this.day);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        day,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.bold),
      ),
    );
  }
}
