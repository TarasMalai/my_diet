// ============================================================================
// НАЗВА ФАЙЛУ: decimal_text_input_formatter.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Універсальний форматер вводу чисел (крапка/кома) для Web та Mobile
// ============================================================================

import 'package:flutter/services.dart';

// ============================================================================
// [ВУЗОЛ 1]: ФОРМАТЕР ДЛЯ ЧИСЛОВИХ ПОЛІВ
// ============================================================================
class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Дозволяємо лише цифри та максимум одну крапку або кому
    final regExp = RegExp(r'^\d*[\.,]?\d*$');

    if (regExp.hasMatch(newValue.text)) {
      return newValue;
    }

    return oldValue;
  }
}
