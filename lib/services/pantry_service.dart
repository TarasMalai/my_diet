// ============================================================================
// НАЗВА ФАЙЛУ: pantry_service.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Сервіс управління інвентарем, запасами та залишками страв
// ============================================================================

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_diet/models/pantry_item_model.dart';

class PantryService {
  static final PantryService _instance = PantryService._internal();
  factory PantryService() => _instance;
  PantryService._internal();

  static const String _pantryStorageKey = 'my_diet_pantry_items_key';
  final List<PantryItemModel> _pantryItems = [];
  bool _isLoaded = false;

  /// Завантаження даних із SharedPreferences при запуску
  Future<void> loadItems() async {
    if (_isLoaded) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_pantryStorageKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decodedList = jsonDecode(jsonString);
        _pantryItems.clear();
        for (var item in decodedList) {
          _pantryItems.add(PantryItemModel.fromMap(Map<String, dynamic>.from(item)));
        }
      }
      _isLoaded = true;
    } catch (e) {
      // Якщо виникла помилка під час зчитування JSON
      _isLoaded = true;
    }
  }

  /// Збереження поточного стану списку на диск
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> mapList = _pantryItems.map((item) => item.toMap()).toList();
      final String jsonString = jsonEncode(mapList);
      await prefs.setString(_pantryStorageKey, jsonString);
    } catch (_) {}
  }

  /// Отримати всі поточні запаси з інвентаря
  List<PantryItemModel> getItems() {
    return List.unmodifiable(_pantryItems);
  }

  /// Додати продукт або готову страву в інвентар (або оновити, якщо вже існує)
  Future<void> saveItem(PantryItemModel item) async {
    final index = _pantryItems.indexWhere((element) => element.id == item.id);
    if (index != -1) {
      _pantryItems[index] = item;
    } else {
      _pantryItems.add(item);
    }
    await _saveToStorage();
  }

  /// Списати вагу продукту з інвентаря
  Future<void> deductWeight(String itemId, double weightToDeduct) async {
    final index = _pantryItems.indexWhere((element) => element.id == itemId);
    if (index != -1) {
      final currentItem = _pantryItems[index];
      currentItem.weightInGram -= weightToDeduct;

      if (currentItem.weightInGram <= 0) {
        _pantryItems.removeAt(index);
      }
      await _saveToStorage();
    }
  }

  /// Пошук продукту в інвентарі за ID або назвою
  PantryItemModel? findItem(String query) {
    final lowerQuery = query.toLowerCase().trim();
    try {
      return _pantryItems.firstWhere((item) => item.id == lowerQuery || item.name.toLowerCase() == lowerQuery);
    } catch (_) {
      return null;
    }
  }

  /// Повністю видалити позицію з інвентаря
  Future<void> removeItem(String id) async {
    _pantryItems.removeWhere((item) => item.id == id);
    await _saveToStorage();
  }
}
