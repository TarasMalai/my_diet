// ============================================================================
// НАЗВА ФАЙЛУ: app_text_input_field_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Універсальне текстове поле з автовиділенням та безпечним фокусом
// ============================================================================

import 'package:flutter/material.dart';

// ============================================================================
// [ВУЗОЛ 2]: УНІВЕРСАЛЬНЕ ТЕКСТОВЕ ПОЛЕ
// ============================================================================
class AppTextInputFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final bool isRequired;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;

  const AppTextInputFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.isRequired = false,
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
        textInputAction: textInputAction,
        onTap: _selectAllText,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        validator: (value) {
          if (isRequired && (value == null || value.trim().isEmpty)) {
            return 'Обов\'язкове поле';
          }
          return null;
        },
      ),
    );
  }
}
