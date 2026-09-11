// ============================================================================
// НАЗВА ФАЙЛУ: diet_repository.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Репозиторій для керування та персистентного збереження раціону
// ============================================================================

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_diet/models/meal_model.dart';
import 'package:my_diet/models/food_item_model.dart';

class DietRepository {
  static final DietRepository _instance = DietRepository._internal();
  factory DietRepository() => _instance;
  DietRepository._internal();

  static const String _storageKey = 'user_diet_database_v1';

  final ValueNotifier<int> listenable = ValueNotifier<int>(0);
  Map<String, List<MealModel>> _database = {};

  bool _isInitialized = false;

  /// Ініціалізація та завантаження збережених даних із локальної пам'яті
  Future<void> init() async {
    if (_isInitialized) return;

    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_storageKey);

    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(jsonString);
        _database = decoded.map((key, value) {
          final List<dynamic> list = value as List<dynamic>;
          final meals = list.map((e) => MealModel.fromJson(e as Map<String, dynamic>)).toList();
          return MapEntry(key, meals);
        });
      } catch (e) {
        debugPrint('Помилка зчитування бази раціону з SharedPreferences: $e');
        _database = {};
      }
    }

    _isInitialized = true;
    _notifyListeners();
  }

  /// Приватний метод збереження стану на диск
  Future<void> _saveToDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> jsonMap = _database.map((key, list) {
        return MapEntry(key, list.map((meal) => meal.toJson()).toList());
      });
      await prefs.setString(_storageKey, jsonEncode(jsonMap));
    } catch (e) {
      debugPrint('Помилка збереження бази раціону: $e');
    }
  }

  void _notifyListeners() {
    listenable.value++;
  }

  String _formatDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  /// Отримання прийомів їжі на обрану дату.
  /// Якщо записів немає або список порожній — автоматично створюються 3 основні прийоми.
  List<MealModel> getMealsForDate(DateTime date) {
    final key = _formatDateKey(date);

    // Якщо даних для цієї дати ще немає АБО список порожній
    if (!_database.containsKey(key) || _database[key]!.isEmpty) {
      _database[key] = [
        MealModel(id: '${DateTime.now().millisecondsSinceEpoch}_1', title: 'СНІДАНОК', items: []),
        MealModel(id: '${DateTime.now().millisecondsSinceEpoch}_2', title: 'ОБІД', items: []),
        MealModel(id: '${DateTime.now().millisecondsSinceEpoch}_3', title: 'ВЕЧЕРЯ', items: []),
      ];
      _saveToDisk(); // Зберігаємо дефолтний шаблон у локальну пам'ять
    }

    return _database[key]!;
  }

  /// Додавання нового прийому їжі
  Future<void> addMeal(DateTime date, String title) async {
    final key = _formatDateKey(date);
    final meals = _database[key] ?? [];

    final newMeal = MealModel(id: DateTime.now().millisecondsSinceEpoch.toString(), title: title, items: []);

    _database[key] = [...meals, newMeal];
    await _saveToDisk();
    _notifyListeners();
  }

  /// Додавання продукту до конкретного прийому їжі
  Future<void> addFoodToMeal(DateTime date, String mealId, FoodItemModel food) async {
    final key = _formatDateKey(date);
    final meals = _database[key];
    if (meals == null) return;

    final index = meals.indexWhere((m) => m.id == mealId);
    if (index != -1) {
      final updatedItems = List<FoodItemModel>.from(meals[index].items)..add(food);
      meals[index] = meals[index].copyWith(items: updatedItems);
      await _saveToDisk();
      _notifyListeners();
    }
  }

  /// Видалення продукту з прийому їжі
  Future<void> removeFoodFromMeal(DateTime date, String mealId, String foodId) async {
    final key = _formatDateKey(date);
    final meals = _database[key];
    if (meals == null) return;

    final index = meals.indexWhere((m) => m.id == mealId);
    if (index != -1) {
      final updatedItems = meals[index].items.where((f) => f.id != foodId).toList();
      meals[index] = meals[index].copyWith(items: updatedItems);
      await _saveToDisk();
      _notifyListeners();
    }
  }

  /// Видалення всього прийому їжі
  Future<void> deleteMeal(DateTime date, String mealId) async {
    final key = _formatDateKey(date);
    final meals = _database[key];
    if (meals == null) return;

    _database[key] = meals.where((m) => m.id != mealId).toList();
    await _saveToDisk();
    _notifyListeners();
  }

  /// Оновлення нотатки прийому їжі
  Future<void> updateMealNote(DateTime date, String mealId, String note) async {
    final key = _formatDateKey(date);
    final meals = _database[key];
    if (meals == null) return;

    final index = meals.indexWhere((m) => m.id == mealId);
    if (index != -1) {
      meals[index] = meals[index].copyWith(note: note);
      await _saveToDisk();
      _notifyListeners();
    }
  }
}
