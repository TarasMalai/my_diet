// ============================================================================
// НАЗВА ФАЙЛУ: cooking_dish_model.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Модель даних для страви в процесі приготування з розрахунком
//              готової маси, нутрієнтів на 100г та фіксацією дати архівації
// ============================================================================

import 'package:my_diet/models/food_item_model.dart';

class CookingDishModel {
  final String id;
  String name;
  List<FoodItemModel> ingredients;
  double tareWeight; // Вага тари (посуду) в грамах
  double finalGrossWeight; // Фінальна вага (з тарою або без)
  bool useTare; // Враховувати тару при відніманні
  String notes; // Нотатки до приготування
  DateTime createdAt;
  DateTime? archivedAt; // [ВУЗОЛ]: Дата та час перенесення в архів для відліку 10 днів
  bool isArchived; // Чи перенесено в архів

  CookingDishModel({
    required this.id,
    this.name = '',
    required this.ingredients,
    this.tareWeight = 0.0,
    this.finalGrossWeight = 0.0,
    this.useTare = true,
    this.notes = '',
    required this.createdAt,
    this.archivedAt,
    this.isArchived = false,
  });

  // ==========================================================================
  // [ВУЗОЛ 1]: Розрахунок чистої ваги готової страви
  // ==========================================================================
  double get netWeight {
    if (finalGrossWeight > 0) {
      final calculated = useTare ? (finalGrossWeight - tareWeight) : finalGrossWeight;
      return calculated > 0 ? calculated : 0.0;
    }
    return totalRawWeight;
  }

  // ==========================================================================
  // [ВУЗОЛ 2]: Загальні сирі показники інгредієнтів
  // ==========================================================================
  double get totalRawWeight => ingredients.fold(0.0, (sum, item) => sum + item.weight);
  double get totalPhe => ingredients.fold(0.0, (sum, item) => sum + item.phe);
  double get totalCalories => ingredients.fold(0.0, (sum, item) => sum + item.calories);
  double get totalProtein => ingredients.fold(0.0, (sum, item) => sum + item.protein);
  double get totalFat => ingredients.fold(0.0, (sum, item) => sum + item.fat);
  double get totalCarbs => ingredients.fold(0.0, (sum, item) => sum + item.carbs);

  // ==========================================================================
  // [ВУЗОЛ 3]: Показники на 100г готової страви
  // ==========================================================================
  double get phePer100g => netWeight > 0 ? (totalPhe / netWeight) * 100 : 0.0;
  double get caloriesPer100g => netWeight > 0 ? (totalCalories / netWeight) * 100 : 0.0;
  double get proteinPer100g => netWeight > 0 ? (totalProtein / netWeight) * 100 : 0.0;
  double get fatPer100g => netWeight > 0 ? (totalFat / netWeight) * 100 : 0.0;
  double get carbsPer100g => netWeight > 0 ? (totalCarbs / netWeight) * 100 : 0.0;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'ingredients': ingredients.map((i) => i.toJson()).toList(),
    'tareWeight': tareWeight,
    'finalGrossWeight': finalGrossWeight,
    'useTare': useTare,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'archivedAt': archivedAt?.toIso8601String(),
    'isArchived': isArchived,
  };

  factory CookingDishModel.fromJson(Map<String, dynamic> json) => CookingDishModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    ingredients: (json['ingredients'] as List? ?? []).map((i) => FoodItemModel.fromJson(i)).toList(),
    tareWeight: (json['tareWeight'] as num?)?.toDouble() ?? 0.0,
    finalGrossWeight: (json['finalGrossWeight'] as num?)?.toDouble() ?? 0.0,
    useTare: json['useTare'] ?? true,
    notes: json['notes'] ?? '',
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    archivedAt: json['archivedAt'] != null ? DateTime.parse(json['archivedAt']) : null,
    isArchived: json['isArchived'] ?? false,
  );
}
