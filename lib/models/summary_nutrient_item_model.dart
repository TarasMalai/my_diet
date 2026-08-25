// ============================================================================
// НАЗВА ФАЙЛУ: summary_nutrient_item_model.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Модель даних для плиточки підсумкового нутрієнта
// ============================================================================

import 'package:flutter/material.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: МОДЕЛЬ ДАНИХ ЕЛЕМЕНТА НУТРІЄНТА (SummaryNutrientItemModel)
// ----------------------------------------------------------------------------
class SummaryNutrientItemModel {
  final String label;
  final double current;
  final double? target;
  final String unit;
  final Color baseColor;
  final IconData icon;
  final Map<String, double>? aminoMap; // Карта амінокислот для плитки ФА

  SummaryNutrientItemModel({
    required this.label,
    required this.current,
    this.target,
    required this.unit,
    required this.baseColor,
    required this.icon,
    this.aminoMap,
  });

  /// Перевірка чи перевищено встановлену ціль
  bool get isExceeded => target != null && target! > 0 && current > target!;

  /// Обчислення відсотка прогресу від 0.0 до 1.0
  double get progress => (target != null && target! > 0) ? (current / target!).clamp(0.0, 1.0) : 0.0;
}
