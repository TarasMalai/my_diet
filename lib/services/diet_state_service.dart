// ============================================================================
// НАЗВА ФАЙЛУ: diet_state_service.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Єдине джерело даних для всіх нутрієнтів проєкту (Singleton + ValueNotifier)
// ============================================================================

import 'package:flutter/material.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: ЕНУМЕРАТОР ТИПІВ НУТРІЄНТІВ (NutrientType)
// ----------------------------------------------------------------------------
enum NutrientType {
  fa,
  protein,
  carbs,
  fats,
  calories,
  water,
  // [ДОДАНО]: Розширені амінокислоти
  leucine,
  tyrosine,
  methionine,
  lysine,
  // [ДОДАНО]: Додаткові нутрієнти
  fiber,
  salt,
  sugar,
  energy,
}

// ----------------------------------------------------------------------------
// [ВУЗОЛ 2]: МОДЕЛЬ ЕЛЕМЕНТА НУТРІЄНТА (NutrientItem)
// ----------------------------------------------------------------------------
class NutrientItem {
  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.1]: ПОЛЯ МОДЕЛІ (Властивості та поточний стан)
  // --------------------------------------------------------------------------
  final String label;
  final String unit;
  final IconData icon;
  final Color baseColor;
  double current;
  double? target; // <-- Тепер double? (ліміти беруться з DietSettingsService)

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.2]: ГОЛОВНИЙ КОНСТРУКТОР
  // --------------------------------------------------------------------------
  NutrientItem({
    required this.label,
    required this.unit,
    required this.icon,
    required this.baseColor,
    required this.current,
    this.target, // <-- Знято обов'язковість required
  });

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.3]: ГЕТТЕРИ ПРОГРЕСУ ТА ПЕРЕВИЩЕННЯ НОРМИ
  // --------------------------------------------------------------------------
  bool get hasTarget => target != null && target! > 0;

  bool get isExceeded => hasTarget && current > target!;

  double get progress {
    if (!hasTarget) return 0.0;
    return (current / target!).clamp(0.0, 1.0);
  }

  double get overflowRatio {
    if (!hasTarget) return 0.0;
    return current / target!;
  }
}

// ----------------------------------------------------------------------------
// [ВУЗОЛ 3]: СЕРВІС СТАНУ ДІЄТИ (DietStateService)
// ----------------------------------------------------------------------------
class DietStateService {
  // --------------------------------------------------------------------------
  // [ВУЗОЛ 3.1]: РЕАЛІЗАЦІЯ ПАТЕРНУ SINGLETON (Одинак)
  // --------------------------------------------------------------------------
  static final DietStateService _instance = DietStateService._internal();
  factory DietStateService() => _instance;
  DietStateService._internal();

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 3.2]: ЦЕНТРАЛЬНІ ДАНІ СТАНУ (ValueNotifier state)
  // --------------------------------------------------------------------------
  /// Центральні дані (редаговані в одному місці для всього додатка)
  final ValueNotifier<Map<NutrientType, NutrientItem>> state = ValueNotifier({
    NutrientType.fa: NutrientItem(
      label: 'Фенілаланін (ФА)',
      unit: 'ФА',
      icon: Icons.balance,
      baseColor: const Color(0xFF1E60C8),
      current: 0.0,
    ),
    NutrientType.protein: NutrientItem(
      label: 'Загальний білок',
      unit: 'г',
      icon: Icons.fitness_center,
      baseColor: const Color(0xFF007A6E),
      current: 0.0,
    ),
    NutrientType.calories: NutrientItem(
      label: 'Калорії',
      unit: 'ккал',
      icon: Icons.local_fire_department,
      baseColor: const Color(0xFFE65100),
      current: 0.0,
    ),
    NutrientType.carbs: NutrientItem(
      label: 'Вуглеводи',
      unit: 'г',
      icon: Icons.grain,
      baseColor: const Color(0xFFF57C00),
      current: 0.0,
    ),
    NutrientType.fats: NutrientItem(
      label: 'Жири',
      unit: 'г',
      icon: Icons.opacity,
      baseColor: const Color(0xFF8D6E63),
      current: 0.0,
    ),
    // [ДОДАНО]: Ініціалізація води
    NutrientType.water: NutrientItem(
      label: 'Вода',
      unit: 'мл',
      icon: Icons.water_drop,
      baseColor: const Color(0xFF0288D1),
      current: 0.0,
    ),
    // [ДОДАНО]: Амінокислоти
    NutrientType.leucine: NutrientItem(
      label: 'Лейцин (Leu)',
      unit: 'мг',
      icon: Icons.science,
      baseColor: const Color(0xFF4A148C),
      current: 0.0,
    ),
    NutrientType.tyrosine: NutrientItem(
      label: 'Тирозин (Tyr)',
      unit: 'мг',
      icon: Icons.biotech,
      baseColor: const Color(0xFF7B1FA2),
      current: 0.0,
    ),
    NutrientType.methionine: NutrientItem(
      label: 'Метіонін (Met)',
      unit: 'мг',
      icon: Icons.nature_people,
      baseColor: const Color(0xFF9C27B0),
      current: 0.0,
    ),
    NutrientType.lysine: NutrientItem(
      label: 'Лізин (Lys)',
      unit: 'мг',
      icon: Icons.bubble_chart,
      baseColor: const Color(0xFFAB47BC),
      current: 0.0,
    ),
    // [ДОДАНО]: Додаткові нутрієнти
    NutrientType.fiber: NutrientItem(
      label: 'Волокна / Клітковина',
      unit: 'г',
      icon: Icons.grass,
      baseColor: const Color(0xFF4CAF50),
      current: 0.0,
    ),
    NutrientType.salt: NutrientItem(
      label: 'Сіль',
      unit: 'г',
      icon: Icons.rice_bowl,
      baseColor: const Color(0xFF607D8B),
      current: 0.0,
    ),
    NutrientType.sugar: NutrientItem(
      label: 'Цукор',
      unit: 'г',
      icon: Icons.cookie,
      baseColor: const Color(0xFFE91E63),
      current: 0.0,
    ),
    NutrientType.energy: NutrientItem(
      label: 'Енергія',
      unit: 'кДж',
      icon: Icons.bolt,
      baseColor: const Color(0xFFFFC107),
      current: 0.0,
    ),
  });

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 3.3]: МЕТОД ОНОВЛЕННЯ ПОКАЗНИКІВ (updateNutrient)
  // --------------------------------------------------------------------------
  void updateNutrient(NutrientType type, {double? current, double? target}) {
    final currentState = Map<NutrientType, NutrientItem>.from(state.value);
    if (currentState.containsKey(type)) {
      if (current != null) currentState[type]!.current = current;
      if (target != null) currentState[type]!.target = target;
      state.value = currentState;
    }
  }
}
