// ============================================================================
// НАЗВА ФАЙЛУ: cooking_service.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Сервіс керування процесом готування (активні чернетки),
//              збереженням рецептів у архів та фіксації в інвентар (10 днів)
// ============================================================================

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_diet/models/cooking_dish_model.dart';
import 'package:my_diet/models/food_item_model.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: ІМПОРТИ СЕРВІСІВ ТА МОДЕЛЕЙ ДЛЯ ІНВЕНТАРЮ
// ----------------------------------------------------------------------------
import 'package:my_diet/models/pantry_item_model.dart';
import 'package:my_diet/services/pantry_service.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 2]: ГОЛОВНИЙ СЕРВІС КУХОННОГО КОТЛА (CookingService)
// ----------------------------------------------------------------------------
class CookingService {
  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.1]: СІНГЛТОН ТА КЛЮЧІ ЗБЕРЕЖЕННЯ
  // --------------------------------------------------------------------------
  static final CookingService _instance = CookingService._internal();
  factory CookingService() => _instance;
  CookingService._internal();

  static const String _activeDishesKey = 'active_cooking_dishes';
  static const String _archivedDishesKey = 'archived_cooking_dishes';

  List<CookingDishModel> activeDishes = [];
  List<CookingDishModel> archivedDishes = [];

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.2]: ІНІЦІАЛІЗАЦІЯ ТА ЗБЕРЕЖЕННЯ СТАНІВ
  // --------------------------------------------------------------------------
  /// Ініціалізація при старті додатка (завантаження активних та архівних чернеток)
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    final activeJson = prefs.getString(_activeDishesKey);
    if (activeJson != null) {
      final List decoded = jsonDecode(activeJson);
      activeDishes = decoded.map((e) => CookingDishModel.fromJson(e)).toList();
    }

    final archiveJson = prefs.getString(_archivedDishesKey);
    if (archiveJson != null) {
      final List decoded = jsonDecode(archiveJson);
      archivedDishes = decoded.map((e) => CookingDishModel.fromJson(e)).toList();
    }

    await _cleanOldArchive();
  }

  /// Збереження станів у локальну пам'ять (SharedPreferences)
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeDishesKey, jsonEncode(activeDishes.map((e) => e.toJson()).toList()));
    await prefs.setString(_archivedDishesKey, jsonEncode(archivedDishes.map((e) => e.toJson()).toList()));
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.3]: РОБОТА З АКТИВНИМИ ЧЕРНЕТКАМИ (ГОТУВАННЯ)
  // --------------------------------------------------------------------------
  /// Створення нової чернетки готування
  Future<CookingDishModel> createNewDish() async {
    final newDish = CookingDishModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '',
      ingredients: [],
      createdAt: DateTime.now(),
    );

    activeDishes.add(newDish);
    await _saveData();
    return newDish;
  }

  /// Автоматичне збереження будь-яких правок під час готування
  Future<void> updateDish(CookingDishModel updatedDish) async {
    final index = activeDishes.indexWhere((d) => d.id == updatedDish.id);
    if (index != -1) {
      activeDishes[index] = updatedDish;
      await _saveData();
    }
  }

  /// Видалення чернетки (без збереження в архів)
  Future<void> deleteActiveDish(String id) async {
    activeDishes.removeWhere((d) => d.id == id);
    await _saveData();
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.4]: ЗБЕРЕЖЕННЯ В РЕЦЕПТИ (АРХІВУВАННЯ БЕЗ ВИДАЛЕННЯ З КОТЛА)
  // --------------------------------------------------------------------------
  /// Натискання кнопки «В Рецепти» в деталях страви.
  /// Зберігає/оновлює копію в Архіві, але залишає страву в активному готуванні.
  Future<void> saveToMyRecipes(CookingDishModel dish) async {
    dish.archivedAt = DateTime.now();
    dish.isArchived = true;

    final archiveIndex = archivedDishes.indexWhere((d) => d.id == dish.id);
    if (archiveIndex != -1) {
      archivedDishes[archiveIndex] = dish;
    } else {
      archivedDishes.insert(0, dish);
    }

    await updateDish(dish); // Зберігаємо також і активні правки
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.5]: ЗАВЕРШЕННЯ ГОТУВАННЯ ТА ПЕРЕДАЧА В ІНВЕНТАР
  // --------------------------------------------------------------------------
  /// Натискання кнопки «ГОТОВО» / Холодильник.
  /// Розраховує КБЖВ на 100г готової страви, відправляє в Інвентар + Архів
  /// та ПРИБИРАЄ з екрана активного готування.
  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.5]: ЗАВЕРШЕННЯ ГОТУВАННЯ ТА ПЕРЕДАЧА В ІНВЕНТАР
  // --------------------------------------------------------------------------
  /// Натискання кнопки «ГОТОВО» / Холодильник.
  /// Розраховує КБЖВ на 100г готової страви, відправляє в Інвентар + Архів
  /// та ПРИБИРАЄ з екрана активного готування.
  Future<void> finishCooking(CookingDishModel dish) async {
    dish.archivedAt = DateTime.now();
    dish.isArchived = true;

    // 1. Копіюємо/оновлюємо в архіві
    final archiveIndex = archivedDishes.indexWhere((d) => d.id == dish.id);
    if (archiveIndex != -1) {
      archivedDishes[archiveIndex] = dish;
    } else {
      archivedDishes.insert(0, dish);
    }

    // 2. Розрахунок поживних речовин на 100г готової страви та додавання в Інвентар
    final netWeight = dish.netWeight > 0 ? dish.netWeight : 1.0;
    final factor100g = 100.0 / netWeight;

    // Конвертуємо інгредієнти страви у формат FoodItemModel для інвентарю
    final pantryIngredients = dish.ingredients.map((item) {
      return FoodItemModel.fromJson(item.toJson());
    }).toList();

    final pantryItem = PantryItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productId: 'cooked_${dish.id}',
      name: dish.name.trim().isEmpty ? 'Приготовлена страва' : dish.name.trim(),
      weightInGram: dish.netWeight,
      phe: dish.phePer100g,
      calories: dish.caloriesPer100g,
      protein: dish.proteinPer100g,
      carbs: dish.carbsPer100g,
      fat: dish.fatPer100g,
      ingredients: pantryIngredients, // <--- ДОДАНО ПЕРЕДАЧУ ІНГРЕДІЄНТІВ
      // Для решти нутрієнтів, якщо для них немає гетерів *Per100g у CookingDishModel:
      leucine: dish.totalLeucine * factor100g,
      tyrosine: dish.totalTyrosine * factor100g,
      methionine: dish.totalMethionine * factor100g,
      lysine: dish.totalLysine * factor100g,
      fiber: dish.totalFiber * factor100g,
      salt: dish.totalSalt * factor100g,
      sugar: dish.totalSugar * factor100g,
      water: dish.totalWater * factor100g,
      energy: dish.totalEnergy * factor100g,
    );

    final pantryService = PantryService();
    await pantryService.loadItems();
    await pantryService.saveItem(pantryItem);

    // 3. Видаляємо з активних чернеток
    activeDishes.removeWhere((d) => d.id == dish.id);

    await _saveData();
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.6]: РОБОТА З АРХІВОМ ТА ПОВТОРНЕ ГОТУВАННЯ
  // --------------------------------------------------------------------------
  /// Видалення страви з Архіву за її ID
  Future<void> deleteFromArchive(String id) async {
    archivedDishes.removeWhere((d) => d.id == id);
    await _saveData();
  }

  /// Запуск повторного готування рецепта з Архіву (створення копії в активні)
  Future<CookingDishModel> cookAgain(CookingDishModel archDish) async {
    final clonedIngredients = archDish.ingredients.map((item) {
      return FoodItemModel.fromJson(item.toJson());
    }).toList();

    final newDish = CookingDishModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: archDish.name,
      ingredients: clonedIngredients,
      tareWeight: archDish.tareWeight,
      finalGrossWeight: archDish.finalGrossWeight,
      useTare: archDish.useTare,
      notes: archDish.notes,
      createdAt: DateTime.now(),
      isArchived: false,
    );

    activeDishes.add(newDish);
    await _saveData();
    return newDish;
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2.7]: АВТО-ОЧИЩЕННЯ СТАРОГО АРХІВУ
  // --------------------------------------------------------------------------
  /// Авто-очищення архіву (понад 10 днів)
  Future<void> _cleanOldArchive() async {
    final now = DateTime.now();
    final initialLength = archivedDishes.length;

    archivedDishes.removeWhere((dish) {
      final archiveTime = dish.archivedAt ?? dish.createdAt;
      return now.difference(archiveTime).inDays >= 10;
    });

    if (archivedDishes.length != initialLength) {
      await _saveData();
    }
  }
}
