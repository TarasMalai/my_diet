// ============================================================================
// НАЗВА ФАЙЛУ: mock_diet_repository_service.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Репозиторій даних з підтримкою додавання, видалення, редагування та сортування прийомів їжі
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:my_diet/models/meal_model.dart';
import 'package:my_diet/models/food_item_model.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: ТЕСТОВИЙ РЕПОЗИТОРІЙ ДІЄТИ (MockDietRepository - Singleton)
// ----------------------------------------------------------------------------
class MockDietRepository {
  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.1]: РЕАЛІЗАЦІЯ SINGLETON ТА СПОВІЩЕННЯ ПРО ЗМІНИ
  // --------------------------------------------------------------------------
  static final MockDietRepository _instance = MockDietRepository._internal();
  factory MockDietRepository() => _instance;

  final ValueNotifier<int> _changeNotifier = ValueNotifier<int>(0);
  ValueListenable<int> get listenable => _changeNotifier;

  // Локальна база даних у пам'яті: "РРРР-ММ-ДД" -> Список прийомів їжі
  final Map<String, List<MealModel>> _database = {};

  MockDietRepository._internal();

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.2]: ДОПОМІЖНІ МЕТОДИ ТА ОТРЕМАЕННЯ ДАНИХ
  // --------------------------------------------------------------------------
  /// Форматування дати у зручний ключ для ключового сховища
  String _formatKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  /// Отримати прийоми їжі за обрану дату (за замовчуванням створює 3 базові)
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
  // [ВУЗОЛ 2]: УПРАВЛІННЯ ПРИЙОМАМИ ЇЖІ (Створення, Видалення, Сортування)
  // --------------------------------------------------------------------------
  /// Створення нового прийому їжі (наприклад, "Перекус")
  void addMeal(DateTime date, String title) {
    final meals = getMealsForDate(date);
    final newMeal = MealModel(id: 'm_${DateTime.now().millisecondsSinceEpoch}', title: title.toUpperCase(), items: []);
    meals.add(newMeal);
    _database[_formatKey(date)] = List.from(meals);
    _notifyListeners();
  }

  /// Видалення цілого прийому їжі
  void deleteMeal(DateTime date, String mealId) {
    final meals = getMealsForDate(date);
    meals.removeWhere((m) => m.id == mealId);
    _database[_formatKey(date)] = List.from(meals);
    _notifyListeners();
  }

  /// Зміна порядку прийомів їжі (Drag and Drop)
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

  /// Повне очищення списку продуктів у прийомі їжі
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
  // [ВУЗОЛ 3]: УПРАВЛІННЯ ПРОДУКТАМИ В ПРИЙОМІ ЇЖІ
  // --------------------------------------------------------------------------
  /// Додати продукт до конкретного прийому їжі
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

  /// Видалити конкретний продукт з прийому їжі
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
  // [ВУЗОЛ 4]: УПРАВЛІННЯ НОТАТКАМИ ТА ОНОВЛЕННЯ СТАНУ
  // --------------------------------------------------------------------------
  /// Оновити нотатку для прийому їжі
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

  /// Сповістити слухачів про зміну даних
  void _notifyListeners() {
    _changeNotifier.value = DateTime.now().millisecondsSinceEpoch;
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 5]: ДЕННІ ПІДСУМКИ НУТРІЄНТІВ ТА АМІНОКИСЛОТ [ДОДАНО 25.08.2026]
  // --------------------------------------------------------------------------
  /// Розрахувати загальні підсумки всіх нутрієнтів за обрану дату
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
