// ============================================================================
// НАЗВА ФАЙЛУ: diet_state_service.dart
// ПРИЗНАЧЕННЯ: Єдине джерело даних для всіх нутрієнтів проєкту
// ============================================================================

import 'package:flutter/material.dart';

enum NutrientType { fa, protein, carbs, fats, calories, water }

class NutrientItem {
  final String label;
  final String unit;
  final IconData icon;
  final Color baseColor;
  double current;
  double target;

  NutrientItem({
    required this.label,
    required this.unit,
    required this.icon,
    required this.baseColor,
    required this.current,
    required this.target,
  });

  bool get isExceeded => target > 0 && current > target;

  double get progress {
    if (target <= 0) return 0.0;
    return (current / target).clamp(0.0, 1.0);
  }

  double get overflowRatio {
    if (target <= 0) return 0.0;
    return current / target;
  }
}

class DietStateService {
  static final DietStateService _instance = DietStateService._internal();
  factory DietStateService() => _instance;
  DietStateService._internal();

  // Центральні дані (редаговані в одному місці для всього додатка)
  final ValueNotifier<Map<NutrientType, NutrientItem>> state = ValueNotifier({
    NutrientType.fa: NutrientItem(
      label: 'Фенілаланін (ФА)',
      unit: 'мг',
      icon: Icons.balance, // Піктограма вагів
      baseColor: const Color(0xFF1E60C8), // Синій колір ФА
      current: 100.0, // Змінюйте тут для тестування
      target: 300.0,
    ),
    NutrientType.protein: NutrientItem(
      label: 'Загальний білок',
      unit: 'г',
      icon: Icons.fitness_center,
      baseColor: const Color(0xFF007A6E), // Смарагдово-зелений
      current: 10.0,
      target: 35.0,
    ),
    NutrientType.calories: NutrientItem(
      label: 'Калорії',
      unit: 'ккал',
      icon: Icons.local_fire_department,
      baseColor: const Color(0xFFE65100), // Помаранчевий
      current: 1350.0,
      target: 1500.0,
    ),
    NutrientType.carbs: NutrientItem(
      label: 'Вуглеводи',
      unit: 'г',
      icon: Icons.grain,
      baseColor: const Color(0xFFF57C00),
      current: 120.4,
      target: 250.0,
    ),
    NutrientType.fats: NutrientItem(
      label: 'Жири',
      unit: 'г',
      icon: Icons.opacity,
      baseColor: const Color(0xFF8D6E63),
      current: 35.2,
      target: 70.0,
    ),
  });

  void updateNutrient(NutrientType type, {double? current, double? target}) {
    final currentState = Map<NutrientType, NutrientItem>.from(state.value);
    if (currentState.containsKey(type)) {
      if (current != null) currentState[type]!.current = current;
      if (target != null) currentState[type]!.target = target;
      state.value = currentState;
    }
  }
}
