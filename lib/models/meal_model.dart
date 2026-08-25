// ============================================================================
// НАЗВА ФАЙЛУ: meal_model.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Модель даних прийому їжі (Сніданок, Обід тощо) та розрахунок підсумків
// ============================================================================

import 'package:my_diet/models/food_item_model.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: МОДЕЛЬ ПРИЙОМУ ЇЖІ (MealModel)
// ----------------------------------------------------------------------------
class MealModel {
  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.1]: ПОЛЯ МОДЕЛІ (Властивості прийому їжі)
  // --------------------------------------------------------------------------
  final String id; // Унікальний ID прийому їжі
  final String title; // Назва ("Сніданок", "Другий сніданок", "Обід")
  final String? note; // Необов'язкова нотатка до прийому їжі
  final List<FoodItemModel> items; // Список спожитих продуктів у цьому прийомі

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.2]: ГОЛОВНИЙ КОНСТРУКТОР
  // --------------------------------------------------------------------------
  const MealModel({required this.id, required this.title, this.note, required this.items});

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.3]: ГЕТТЕРИ ПІДРАХУНКУ ЗАГАЛЬНОЇ СУМИ НУТРІЄНТІВ
  // --------------------------------------------------------------------------
  // Автоматично сумують показники всіх продуктів у списку 'items'
  double get totalPhe => items.fold(0.0, (sum, item) => sum + item.phe);
  double get totalCalories => items.fold(0.0, (sum, item) => sum + item.calories);
  double get totalProtein => items.fold(0.0, (sum, item) => sum + item.protein);
  double get totalCarbs => items.fold(0.0, (sum, item) => sum + item.carbs);
  double get totalFat => items.fold(0.0, (sum, item) => sum + item.fat);

  // [ДОДАНО]: Геттери підрахунку амінокислот
  double get totalLeucine => items.fold(0.0, (sum, item) => sum + item.leucine);
  double get totalTyrosine => items.fold(0.0, (sum, item) => sum + item.tyrosine);
  double get totalMethionine => items.fold(0.0, (sum, item) => sum + item.methionine);
  double get totalLysine => items.fold(0.0, (sum, item) => sum + item.lysine);

  // [ДОДАНО]: Геттери підрахунку додаткових нутрієнтів
  double get totalFiber => items.fold(0.0, (sum, item) => sum + item.fiber);
  double get totalSalt => items.fold(0.0, (sum, item) => sum + item.salt);
  double get totalSugar => items.fold(0.0, (sum, item) => sum + item.sugar);
  double get totalWater => items.fold(0.0, (sum, item) => sum + item.water);
  double get totalEnergy => items.fold(0.0, (sum, item) => sum + item.energy);

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.4]: КОПІЮВАННЯ ОБ'ЄКТА З ЗМІНАМИ (copyWith)
  // --------------------------------------------------------------------------
  MealModel copyWith({String? id, String? title, String? note, List<FoodItemModel>? items}) {
    return MealModel(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      items: items ?? this.items,
    );
  }
}
