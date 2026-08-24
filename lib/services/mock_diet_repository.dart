// ============================================================================
// НАЗВА ФАЙЛУ: mock_diet_repository.dart
// ПРИЗНАЧЕННЯ: Сховище даних із підтримкою додавання, видалення та сортування прийомів
// ============================================================================

import 'package:flutter/foundation.dart';
import '../models/meal_model.dart';
import '../models/food_item_model.dart';

class MockDietRepository {
  static final MockDietRepository _instance = MockDietRepository._internal();
  factory MockDietRepository() => _instance;

  final ValueNotifier<int> _changeNotifier = ValueNotifier<int>(0);
  ValueListenable<int> get listenable => _changeNotifier;

  final Map<String, List<MealModel>> _database = {};

  MockDietRepository._internal();

  String _formatKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  /// Отримати прийоми їжі за дату (за замовчуванням створює 3 базові)
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

  /// [ВУЗОЛ 1]: Створення нового прийому їжі (наприклад, "Перекус")
  void addMeal(DateTime date, String title) {
    final meals = getMealsForDate(date);
    final newMeal = MealModel(id: 'm_${DateTime.now().millisecondsSinceEpoch}', title: title.toUpperCase(), items: []);
    meals.add(newMeal);
    _database[_formatKey(date)] = List.from(meals);
    _notifyListeners();
  }

  /// [ВУЗОЛ 2]: Видалення цілого прийому їжі
  void deleteMeal(DateTime date, String mealId) {
    final meals = getMealsForDate(date);
    meals.removeWhere((m) => m.id == mealId);
    _database[_formatKey(date)] = List.from(meals);
    _notifyListeners();
  }

  /// [ВУЗОЛ 3]: Зміна порядку прийомів їжі (Drag and Drop)
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

  /// Очистити прийом їжі
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

  void _notifyListeners() {
    _changeNotifier.value = DateTime.now().millisecondsSinceEpoch;
  }
}
