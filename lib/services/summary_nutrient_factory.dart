// ============================================================================
// НАЗВА ФАЙЛУ: summary_nutrient_factory.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Фабрика розрахунку та формування списку підсумкових нутрієнтів
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/models/summary_nutrient_item_model.dart';
import 'package:my_diet/models/meal_model.dart'; // Вкажіть правильний імпорт вашої моделі прийому їжі
import 'package:my_diet/services/diet_settings_service.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: ФАБРИКА СФОРМОВАНИХ НУТРІЄНТІВ (SummaryNutrientFactory)
// ----------------------------------------------------------------------------
class SummaryNutrientFactory {
  /// Метод приймає список прийомів їжі та налаштування цілей,
  /// підраховує загальні суми та повертає готовий список моделей для UI.
  static List<SummaryNutrientItemModel> buildSummaryList({
    required List<MealModel> meals,
    required DietSettingsService settings,
  }) {
    // 1. Змінні для збереження сумарних значень
    double totalPhe = 0;
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    // Амінокислоти
    double totalLeu = 0;
    double totalTyr = 0;
    double totalMet = 0;
    double totalLys = 0;

    // Додаткові мікронутрієнти
    double totalFiber = 0;
    double totalSugar = 0;
    double totalSalt = 0;
    double totalWater = 0;
    double totalEnergy = 0;

    // TODO: Майбутні нутрієнти (наприклад, Залізо)
    // double totalIron = 0;

    // 2. Агрегація сум зі всіх прийомів їжі та продуктів
    for (var meal in meals) {
      totalPhe += meal.totalPhe;
      totalCalories += meal.totalCalories;
      totalProtein += meal.totalProtein;
      totalCarbs += meal.totalCarbs;
      totalFat += meal.totalFat;

      for (var item in meal.items) {
        totalLeu += item.leucine;
        totalTyr += item.tyrosine;
        totalMet += item.methionine;
        totalLys += item.lysine;

        totalFiber += item.fiber;
        totalSugar += item.sugar;
        totalSalt += item.salt;
        totalWater += item.water;
        totalEnergy += item.energy;

        // totalIron += item.iron; // Якщо в майбутньому додасте iron в продуктах
      }
    }

    // 3. Формування готового списку плиток для відображення
    return [
      // 1. Фенілаланін + амінокислоти
      SummaryNutrientItemModel(
        label: 'Фенілаланін',
        current: totalPhe,
        target: settings.targetPhe,
        unit: 'ФА',
        baseColor: Colors.purple,
        icon: Icons.science,
        aminoMap: {'Leu': totalLeu, 'Tyr': totalTyr, 'Met': totalMet, 'Lys': totalLys},
      ),
      // 2. Калорії
      SummaryNutrientItemModel(
        label: 'Калорії',
        current: totalCalories,
        target: settings.targetCalories,
        unit: 'ккал',
        baseColor: Colors.orange,
        icon: Icons.local_fire_department,
      ),
      // 3. Білки
      SummaryNutrientItemModel(
        label: 'Білки',
        current: totalProtein,
        target: settings.targetProtein,
        unit: 'г',
        baseColor: Colors.blue,
        icon: Icons.fitness_center,
      ),
      // 4. Вуглеводи
      SummaryNutrientItemModel(
        label: 'Вуглеводи',
        current: totalCarbs,
        target: settings.targetCarbs,
        unit: 'г',
        baseColor: Colors.amber,
        icon: Icons.grain,
      ),
      // 5. Жири
      SummaryNutrientItemModel(
        label: 'Жири',
        current: totalFat,
        target: settings.targetFat,
        unit: 'г',
        baseColor: Colors.redAccent,
        icon: Icons.opacity,
      ),
      // 6. Клітковина
      SummaryNutrientItemModel(
        label: 'Клітковина',
        current: totalFiber,
        target: settings.targetFiber,
        unit: 'г',
        baseColor: Colors.green,
        icon: Icons.grass,
      ),
      // 7. Цукор
      SummaryNutrientItemModel(
        label: 'Цукор',
        current: totalSugar,
        target: settings.targetSugar,
        unit: 'г',
        baseColor: Colors.pink,
        icon: Icons.cookie_outlined,
      ),
      // 8. Сіль
      SummaryNutrientItemModel(
        label: 'Сіль',
        current: totalSalt,
        target: settings.targetSalt,
        unit: 'г',
        baseColor: Colors.grey,
        icon: Icons.grain,
      ),
      // 9. Вода
      SummaryNutrientItemModel(
        label: 'Вода',
        current: totalWater,
        target: settings.targetWater,
        unit: 'мл',
        baseColor: Colors.lightBlue,
        icon: Icons.water_drop_outlined,
      ),
      // 10. Енергія
      SummaryNutrientItemModel(
        label: 'Енергія',
        current: totalEnergy,
        target: settings.targetEnergy,
        unit: 'кДж',
        baseColor: Colors.deepOrange,
        icon: Icons.bolt,
      ),

      /* ПРИКЛАД ЯК ДОДАТИ ЗАЛІЗО В МАЙБУТНЬОМУ:
      SummaryNutrientItemModel(
        label: 'Залізо',
        current: totalIron,
        target: settings.targetIron,
        unit: 'мг',
        baseColor: Colors.blueGrey,
        icon: Icons.fitness_center,
      ),
      */
    ];
  }
}
