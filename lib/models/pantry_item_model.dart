// ============================================================================
// НАЗВА ФАЙЛУ: pantry_item_model.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Модель даних для продуктів у Інвентарі та збережених страв
// ============================================================================

import 'package:my_diet/models/food_item_model.dart';

class PantryItemModel {
  final String id;
  final String productId; // Посилання на глобальний продукт (якщо є)
  final String name;
  double weightInGram; // Поточна вага/запас вдома (наприклад, 1200.0 г)

  // Нутрієнти НА 100 ГРАМ (для зручного перерахунку порцій)
  final double phe;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double leucine;
  final double tyrosine;
  final double methionine;
  final double lysine;
  final double fiber;
  final double salt;
  final double sugar;
  final double water;
  final double energy;

  final bool isRecipe; // Прапорець: чи це заготовлена страва/рецепт
  final DateTime updatedAt;

  // Поле для зберігання списку інгредієнтів (для готових страв)
  final List<FoodItemModel>? ingredients;
  final String? ingredientsSummary; // Короткий текстовий опис складу

  PantryItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.weightInGram,
    required this.phe,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.leucine = 0.0,
    this.tyrosine = 0.0,
    this.methionine = 0.0,
    this.lysine = 0.0,
    this.fiber = 0.0,
    this.salt = 0.0,
    this.sugar = 0.0,
    this.water = 0.0,
    this.energy = 0.0,
    this.isRecipe = false,
    DateTime? updatedAt,
    this.ingredients,
    this.ingredientsSummary,
  }) : updatedAt = updatedAt ?? DateTime.now();

  // Конвертація в Map для зберігання (наприклад, у локальній базі чи JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'weightInGram': weightInGram,
      'phe': phe,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'leucine': leucine,
      'tyrosine': tyrosine,
      'methionine': methionine,
      'lysine': lysine,
      'fiber': fiber,
      'salt': salt,
      'sugar': sugar,
      'water': water,
      'energy': energy,
      'isRecipe': isRecipe ? 1 : 0,
      'updatedAt': updatedAt.toIso8601String(),
      'ingredients': ingredients?.map((i) => i.toJson()).toList(),
      'ingredientsSummary': ingredientsSummary ?? ingredients?.map((i) => i.name).join(', '),
    };
  }

  // Створення об'єкта з Map
  factory PantryItemModel.fromMap(Map<String, dynamic> map) {
    return PantryItemModel(
      id: map['id'] ?? '',
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      weightInGram: (map['weightInGram'] ?? 0.0).toDouble(),
      phe: (map['phe'] ?? 0.0).toDouble(),
      calories: (map['calories'] ?? 0.0).toDouble(),
      protein: (map['protein'] ?? 0.0).toDouble(),
      carbs: (map['carbs'] ?? 0.0).toDouble(),
      fat: (map['fat'] ?? 0.0).toDouble(),
      leucine: (map['leucine'] ?? 0.0).toDouble(),
      tyrosine: (map['tyrosine'] ?? 0.0).toDouble(),
      methionine: (map['methionine'] ?? 0.0).toDouble(),
      lysine: (map['lysine'] ?? 0.0).toDouble(),
      fiber: (map['fiber'] ?? 0.0).toDouble(),
      salt: (map['salt'] ?? 0.0).toDouble(),
      sugar: (map['sugar'] ?? 0.0).toDouble(),
      water: (map['water'] ?? 0.0).toDouble(),
      energy: (map['energy'] ?? 0.0).toDouble(),
      isRecipe: map['isRecipe'] == 1 || map['isRecipe'] == true,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : DateTime.now(),
      ingredients: map['ingredients'] != null
          ? (map['ingredients'] as List).map((i) => FoodItemModel.fromJson(Map<String, dynamic>.from(i))).toList()
          : null,
      ingredientsSummary: map['ingredientsSummary'],
    );
  }
}
