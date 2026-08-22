import 'package:flutter/material.dart';
import '../models/nutrient_config_model.dart';
import '../services/nutrient_config_service.dart';

/// Глобальний сервіс налаштувань кольорів та іконок нутрієнтів.
class NutrientConfigService {
  static final NutrientConfigService _instance = NutrientConfigService._internal();
  factory NutrientConfigService() => _instance;
  NutrientConfigService._internal();

  /// Реактивний словник налаштувань (підписані віджети оновлюються автоматично)
  final ValueNotifier<Map<NutrientType, NutrientConfig>> configs = ValueNotifier({
    NutrientType.fa: const NutrientConfig(
      type: NutrientType.fa,
      label: 'Фенілаланін',
      unit: 'ФА',
      color: Colors.deepPurple,
      icon: Icons.science_outlined,
    ),
    NutrientType.calories: const NutrientConfig(
      type: NutrientType.calories,
      label: 'Калорії',
      unit: 'ккал',
      color: Colors.orange,
      icon: Icons.local_fire_department,
    ),
    NutrientType.protein: const NutrientConfig(
      type: NutrientType.protein,
      label: 'Білок',
      unit: 'г',
      color: Colors.blue,
      icon: Icons.fitness_center,
    ),
    NutrientType.water: const NutrientConfig(
      type: NutrientType.water,
      label: 'Вода',
      unit: 'мл',
      color: Colors.cyan,
      icon: Icons.water_drop_outlined,
    ),
    NutrientType.carbs: const NutrientConfig(
      type: NutrientType.carbs,
      label: 'Вуглеводи',
      unit: 'г',
      color: Colors.amber,
      icon: Icons.grain,
    ),
  });

  /// Метод для майбутнього екрана Налаштувань (зміна кольору або іконки)
  void updateNutrient(NutrientType type, {Color? newColor, IconData? newIcon}) {
    final updatedMap = Map<NutrientType, NutrientConfig>.from(configs.value);
    if (updatedMap.containsKey(type)) {
      updatedMap[type] = updatedMap[type]!.copyWith(color: newColor, icon: newIcon);
      configs.value = updatedMap; // Повідомляє всі віджети про зміни
    }
  }
}
