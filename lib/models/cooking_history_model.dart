// ============================================================================
// НАЗВА ФАЙЛУ: cooking_history_model.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Модель даних для збереження історії приготування страви
//              (включно зі списком інгредієнтів та фінальною вагою для повторення)
// ============================================================================

import 'package:my_diet/models/food_item_model.dart';

class CookingHistoryModel {
  final String id;
  final String dishName;
  final double finalWeight;
  final List<FoodItemModel> ingredients;
  final DateTime cookedAt;

  CookingHistoryModel({
    required this.id,
    required this.dishName,
    required this.finalWeight,
    required this.ingredients,
    required this.cookedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'dishName': dishName,
    'finalWeight': finalWeight,
    'ingredients': ingredients.map((i) => i.toJson()).toList(),
    'cookedAt': cookedAt.toIso8601String(),
  };

  factory CookingHistoryModel.fromJson(Map<String, dynamic> json) => CookingHistoryModel(
    id: json['id'],
    dishName: json['dishName'],
    finalWeight: (json['finalWeight'] as num).toDouble(),
    ingredients: (json['ingredients'] as List).map((i) => FoodItemModel.fromJson(i)).toList(),
    cookedAt: DateTime.parse(json['cookedAt']),
  );
}
