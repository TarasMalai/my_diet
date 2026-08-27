// ============================================================================
// НАЗВА ФАЙЛУ: app_number_input_field_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Універсальне числове поле вводу нутрієнтів для Web та Mobile
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/widgets/common_widget/decimal_text_input_formatter.dart';

// ============================================================================
// [ВУЗОЛ 3]: УНІВЕРСАЛЬНЕ ЧИСЛОВЕ ПОЛЕ
// ============================================================================
class AppNumberInputFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;

  const AppNumberInputFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
  });

  void _selectAllText() {
    if (controller.text.isNotEmpty) {
      controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          // Future.microtask захищає від зациклення подій фокусу у Flutter Web
          Future.microtask(_selectAllText);
        }
      },
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [DecimalTextInputFormatter()],
        textInputAction: textInputAction,
        onTap: _selectAllText,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
      ),
    );
  }
}
