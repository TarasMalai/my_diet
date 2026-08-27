// ============================================================================
// НАЗВА ФАЙЛУ: product_repository.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Локальний репозиторій для роботи з базою продуктів.
//              Підтримує збереження та скидання даних як у Chrome, так і на ПК.
// ============================================================================

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Використовуємо абсолютний імпорт через назву пакета проєкту
import 'package:my_diet/models/product_model.dart';

class ProductRepository {
  // Ключ, за яким база JSON зберігається в пам'яті пристрою/браузера
  static const String _storageKey = 'user_products_db_json';

  /// [ВУЗОЛ 1]: ЗАВАНТАЖЕННЯ ПРОДУКТІВ
  /// Завантажує список продуктів з локальної пам'яті.
  /// Якщо пам'ять порожня (перший запуск) — читає еталон з assets та зберігає його.
  Future<List<ProductModel>> loadProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? jsonString = prefs.getString(_storageKey);

      // Якщо в локальному сховищі ще немає даних, зчитуємо початковий JSON з assets
      if (jsonString == null || jsonString.isEmpty) {
        jsonString = await rootBundle.loadString('assets/products_database.json');
        await prefs.setString(_storageKey, jsonString);
      }

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Помилка завантаження продуктів: $e');
      return [];
    }
  }

  /// [ВУЗОЛ 2]: ЗБЕРЕЖЕННЯ ЗМІН
  /// Зберігає оновлений список продуктів у локальне сховище
  Future<void> saveProducts(List<ProductModel> products) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String jsonString = jsonEncode(products.map((p) => p.toJson()).toList());
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      debugPrint('Помилка збереження продуктів: $e');
    }
  }

  /// [ВУЗОЛ 3]: СКИДАННЯ ДО ЕТАЛОНУ
  /// Перезаписує збережені дані початковим файлом з assets
  Future<List<ProductModel>> resetToDefault() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String assetContent = await rootBundle.loadString('assets/products_database.json');

      await prefs.setString(_storageKey, assetContent);

      final List<dynamic> jsonList = jsonDecode(assetContent);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Помилка скидання бази продуктів: $e');
      return [];
    }
  }
}
