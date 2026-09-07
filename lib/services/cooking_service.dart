// ============================================================================
// НАЗВА ФАЙЛУ: cooking_service.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Сервіс тимчасового збору інгредієнтів для готування страв
// ============================================================================

import 'package:my_diet/models/food_item_model.dart';
import 'package:my_diet/models/pantry_item_model.dart';
import 'package:my_diet/services/pantry_service.dart';

class CookingService {
  static final CookingService _instance = CookingService._internal();
  factory CookingService() => _instance;
  CookingService._internal();

  // Тимчасовий список інгредієнтів майбутньої страви
  final List<FoodItemModel> _ingredients = [];

  List<FoodItemModel> get ingredients => List.unmodifiable(_ingredients);

  /// Додати інгредієнт до майбутньої страви
  void addIngredient(FoodItemModel item) {
    _ingredients.add(item);
  }

  /// Видалити інгредієнт зі списку
  void removeIngredient(String id) {
    _ingredients.removeWhere((item) => item.id == id);
  }

  /// Очистити котел (повернути все до нуля)
  void clear() {
    _ingredients.clear();
  }

  /// Підрахунок сумарних нутрієнтів та сирої маси всіх інгредієнтів разом
  Map<String, double> calculateTotals() {
    double totalWeight = 0;
    double totalPhe = 0;
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;
    double totalLeucine = 0;
    double totalTyrosine = 0;
    double totalMethionine = 0;
    double totalLysine = 0;
    double totalFiber = 0;
    double totalSalt = 0;
    double totalSugar = 0;
    double totalWater = 0;
    double totalEnergy = 0;

    for (var item in _ingredients) {
      totalWeight += item.weight;
      totalPhe += item.phe;
      totalCalories += item.calories;
      totalProtein += item.protein;
      totalCarbs += item.carbs;
      totalFat += item.fat;
      totalLeucine += item.leucine;
      totalTyrosine += item.tyrosine;
      totalMethionine += item.methionine;
      totalLysine += item.lysine;
      totalFiber += item.fiber;
      totalSalt += item.salt;
      totalSugar += item.sugar;
      totalWater += item.water;
      totalEnergy += item.energy;
    }

    return {
      'weight': totalWeight,
      'phe': totalPhe,
      'calories': totalCalories,
      'protein': totalProtein,
      'carbs': totalCarbs,
      'fat': totalFat,
      'leucine': totalLeucine,
      'tyrosine': totalTyrosine,
      'methionine': totalMethionine,
      'lysine': totalLysine,
      'fiber': totalFiber,
      'salt': totalSalt,
      'sugar': totalSugar,
      'water': totalWater,
      'energy': totalEnergy,
    };
  }

  /// Фінальне приготування та збереження страви в Інвентар (Комору)
  /// [dishName] - назва готової страви (наприклад, "Суп овочевий")
  /// [finalWeight] - маса страви після варіння/приготування (грам)
  bool finishCookingAndSaveToPantry(String dishName, double finalWeight) {
    if (_ingredients.isEmpty || finalWeight <= 0) return false;

    final totals = calculateTotals();

    // Коефіцієнт перерахунку на 100 грам ГОТОВОЇ страви
    // Формула: (Сумарна кількість речовини на весь казан / фінальну вагу казана) * 100
    double getPer100g(double totalValue) {
      return (totalValue / finalWeight) * 100;
    }

    final pantryItem = PantryItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productId: '',
      name: dishName,
      weightInGram: finalWeight, // Скільки всього готової страви вийшло
      isRecipe: true, // Позначаємо, що це заготовлена страва
      phe: getPer100g(totals['phe']!),
      calories: getPer100g(totals['calories']!),
      protein: getPer100g(totals['protein']!),
      carbs: getPer100g(totals['carbs']!),
      fat: getPer100g(totals['fat']!),
      leucine: getPer100g(totals['leucine']!),
      tyrosine: getPer100g(totals['tyrosine']!),
      methionine: getPer100g(totals['methionine']!),
      lysine: getPer100g(totals['lysine']!),
      fiber: getPer100g(totals['fiber']!),
      salt: getPer100g(totals['salt']!),
      sugar: getPer100g(totals['sugar']!),
      water: getPer100g(totals['water']!),
      energy: getPer100g(totals['energy']!),
    );

    // Зберігаємо страву одразу в Інвентар!
    PantryService().saveItem(pantryItem);

    // Очищаємо котел після готування
    clear();
    return true;
  }
}
