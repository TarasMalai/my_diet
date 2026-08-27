// ============================================================================
// НАЗВА ФАЙЛУ: mock_diet_repository_service.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Репозиторій даних з підтримкою прийомів їжі та бази продуктів
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:my_diet/models/meal_model.dart';
import 'package:my_diet/models/food_item_model.dart';
import 'package:my_diet/models/product_model.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: ТЕСТОВИЙ РЕПОЗИТОРІЙ ДІЄТИ (MockDietRepository - Singleton)
// ----------------------------------------------------------------------------
class MockDietRepository {
  static final MockDietRepository _instance = MockDietRepository._internal();
  factory MockDietRepository() => _instance;

  final ValueNotifier<int> _changeNotifier = ValueNotifier<int>(0);
  ValueListenable<int> get listenable => _changeNotifier;

  // Локальна база даних у пам'яті: "РРРР-ММ-ДД" -> Список прийомів їжі
  final Map<String, List<MealModel>> _database = {};

  // База продуктів
  final List<ProductModel> _products = [
    ProductModel(
      id: 'p1',
      name: 'Яблуко',
      category: 'Фрукти',
      phe: 10,
      calories: 52,
      protein: 0.3,
      carbs: 13.8,
      fat: 0.2,
    ),
    ProductModel(
      id: 'p2',
      name: 'Картопля',
      category: 'Овочі',
      phe: 80,
      calories: 77,
      protein: 2.0,
      carbs: 17.0,
      fat: 0.1,
    ),
  ];

  MockDietRepository._internal();

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.2]: ДОПОМІЖНІ МЕТОДИ ТА ОТРИМАННЯ ДАНИХ
  // --------------------------------------------------------------------------
  String _formatKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  List<MealModel> getMealsForDate(DateTime date) {
    final key = _formatKey(date);
    if (!_database.containsKey(key)) {
      _database[key] = [
        MealModel(id: 'm1_${DateTime.now().millisecondsSinceEpoch}', title: 'СНІДАНОК', items: []),
        MealModel(id: 'm2_${DateTime.now().millisecondsSinceEpoch}', title: 'ОБІД', items: []),
        MealModel(id: 'm3_${DateTime.now().millisecondsSinceEpoch}', title: 'ВЕЧЕРЯ', items: []),
      ];
    }
    return _database[key]!;
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2]: УПРАВЛІННЯ БАЗОЮ ПРОДУКТІВ
  // --------------------------------------------------------------------------
  List<ProductModel> get products => List.unmodifiable(_products);

  void addProduct(ProductModel product) {
    _products.add(product);
    _notifyListeners();
  }

  void updateProduct(ProductModel updatedProduct) {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      _notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    _notifyListeners();
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 3]: УПРАВЛІННЯ ПРИЙОМАМИ ЇЖІ (Створення, Видалення, Сортування)
  // --------------------------------------------------------------------------
  void addMeal(DateTime date, String title) {
    final meals = getMealsForDate(date);
    final newMeal = MealModel(id: 'm_${DateTime.now().millisecondsSinceEpoch}', title: title.toUpperCase(), items: []);
    meals.add(newMeal);
    _database[_formatKey(date)] = List.from(meals);
    _notifyListeners();
  }

  void deleteMeal(DateTime date, String mealId) {
    final meals = getMealsForDate(date);
    meals.removeWhere((m) => m.id == mealId);
    _database[_formatKey(date)] = List.from(meals);
    _notifyListeners();
  }

  void reorderMeals(DateTime date, int oldIndex, int newIndex) {
    final meals = getMealsForDate(date);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final MealModel item = meals.removeAt(oldIndex);
    meals.insert(newIndex, item);
    _database[_formatKey(date)] = List.from(meals);
    _notifyListeners();
  }

  void clearMeal(DateTime date, String mealId) {
    final meals = getMealsForDate(date);
    final mealIndex = meals.indexWhere((m) => m.id == mealId);
    if (mealIndex != -1) {
      meals[mealIndex] = MealModel(
        id: meals[mealIndex].id,
        title: meals[mealIndex].title,
        items: [],
        note: meals[mealIndex].note,
      );
      _database[_formatKey(date)] = List.from(meals);
    }
    _notifyListeners();
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 4]: УПРАВЛІННЯ ПРОДУКТАМИ В ПРИЙОМІ ЇЖІ
  // --------------------------------------------------------------------------
  void addFoodToMeal(DateTime date, String mealId, FoodItemModel item) {
    final meals = getMealsForDate(date);
    final mealIndex = meals.indexWhere((m) => m.id == mealId);
    if (mealIndex != -1) {
      final updatedItems = List<FoodItemModel>.from(meals[mealIndex].items)..add(item);
      meals[mealIndex] = MealModel(
        id: meals[mealIndex].id,
        title: meals[mealIndex].title,
        items: updatedItems,
        note: meals[mealIndex].note,
      );
      _database[_formatKey(date)] = List.from(meals);
    }
    _notifyListeners();
  }

  void removeFoodFromMeal(DateTime date, String mealId, String itemId) {
    final meals = getMealsForDate(date);
    final mealIndex = meals.indexWhere((m) => m.id == mealId);
    if (mealIndex != -1) {
      final updatedItems = List<FoodItemModel>.from(meals[mealIndex].items)..removeWhere((item) => item.id == itemId);
      meals[mealIndex] = MealModel(
        id: meals[mealIndex].id,
        title: meals[mealIndex].title,
        items: updatedItems,
        note: meals[mealIndex].note,
      );
      _database[_formatKey(date)] = List.from(meals);
    }
    _notifyListeners();
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 5]: УПРАВЛІННЯ НОТАТКАМИ ТА ОНОВЛЕННЯ СТАНУ
  // --------------------------------------------------------------------------
  void updateMealNote(DateTime date, String mealId, String note) {
    final meals = getMealsForDate(date);
    final mealIndex = meals.indexWhere((m) => m.id == mealId);
    if (mealIndex != -1) {
      final currentMeal = meals[mealIndex];
      meals[mealIndex] = MealModel(id: currentMeal.id, title: currentMeal.title, items: currentMeal.items, note: note);
      _database[_formatKey(date)] = List.from(meals);
    }
    _notifyListeners();
  }

  void _notifyListeners() {
    _changeNotifier.value = DateTime.now().millisecondsSinceEpoch;
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 6]: ДЕННІ ПІДСУМКИ НУТРІЄНТІВ ТА АМІНОКИСЛОТ
  // --------------------------------------------------------------------------
  Map<String, double> getDailyTotalsForDate(DateTime date) {
    final meals = getMealsForDate(date);
    double phe = 0.0;
    double calories = 0.0;
    double protein = 0.0;
    double carbs = 0.0;
    double fat = 0.0;
    double leucine = 0.0;
    double tyrosine = 0.0;
    double methionine = 0.0;
    double lysine = 0.0;
    double fiber = 0.0;
    double salt = 0.0;
    double sugar = 0.0;
    double water = 0.0;
    double energy = 0.0;

    for (final meal in meals) {
      phe += meal.totalPhe;
      calories += meal.totalCalories;
      protein += meal.totalProtein;
      carbs += meal.totalCarbs;
      fat += meal.totalFat;
      leucine += meal.totalLeucine;
      tyrosine += meal.totalTyrosine;
      methionine += meal.totalMethionine;
      lysine += meal.totalLysine;
      fiber += meal.totalFiber;
      salt += meal.totalSalt;
      sugar += meal.totalSugar;
      water += meal.totalWater;
      energy += meal.totalEnergy;
    }

    return {
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
    };
  }
}
