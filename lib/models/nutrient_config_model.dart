// ============================================================================
// ФАЙЛ: lib/models/nutrient_config.dart
// ПРИЗНАЧЕННЯ: Базові типи та конфігурація нутрієнтів
// ============================================================================

import 'package:flutter/material.dart';

/// Перелік усіх типів нутрієнтів у додатку
enum NutrientType { fa, calories, protein, water, carbs, fats }

/// Модель конфігурації нутрієнта (назва, одиниці, колір, іконка)
class NutrientConfig {
  final NutrientType type;
  final String label;
  final String unit;
  final Color color;
  final IconData icon;

  const NutrientConfig({
    required this.type,
    required this.label,
    required this.unit,
    required this.color,
    required this.icon,
  });

  NutrientConfig copyWith({NutrientType? type, String? label, String? unit, Color? color, IconData? icon}) {
    return NutrientConfig(
      type: type ?? this.type,
      label: label ?? this.label,
      unit: unit ?? this.unit,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }
}
