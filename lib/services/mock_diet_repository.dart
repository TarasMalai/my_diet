// ============================================================================
// НАЗВА ФАЙЛУ: mock_diet_repository.dart
// ПРИЗНАЧЕННЯ: Сховище даних без початкових заглушок (всі дні початково порожні)
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

  /// Отримати прийоми їжі за дату (якщо дати немає в базі — створює порожні)
  List<MealModel> getMealsForDate(DateTime date) {
    final key = _formatKey(date);
    if (!_database.containsKey(key)) {
      _database[key] = [
        MealModel(id: 'm1', title: 'СНІДАНОК', items: []),
        MealModel(id: 'm2', title: 'ПЕРЕКУС', items: []),
        MealModel(id: 'm3', title: 'ОБІД', items: []),
        MealModel(id: 'm4', title: 'ВЕЧЕРЯ', items: []),
      ];
    }
    return _database[key]!;
  }

  /// Додати продукт до конкретного прийому їжі
  void addFoodToMeal(DateTime date, String mealId, FoodItemModel item) {
    final meals = getMealsForDate(date);
    final mealIndex = meals.indexWhere((m) => m.id == mealId);
    if (mealIndex != -1) {
      // Створюємо новий список items, щоб Flutter точно помітив зміну даних
      final updatedItems = List<FoodItemModel>.from(meals[mealIndex].items)..add(item);
      meals[mealIndex] = MealModel(id: meals[mealIndex].id, title: meals[mealIndex].title, items: updatedItems);
      _database[_formatKey(date)] = List.from(meals);
    }
    _changeNotifier.value =
        DateTime.now().millisecondsSinceEpoch; // Унікальне значення для стовідсоткового спрацювання слухача
  }

  /// Очистити прийом їжі
  void clearMeal(DateTime date, String mealId) {
    final meals = getMealsForDate(date);
    final mealIndex = meals.indexWhere((m) => m.id == mealId);
    if (mealIndex != -1) {
      meals[mealIndex] = MealModel(id: meals[mealIndex].id, title: meals[mealIndex].title, items: []);
      _database[_formatKey(date)] = List.from(meals);
    }
    _changeNotifier.value = DateTime.now().millisecondsSinceEpoch;
  }
}
