// ============================================================================
// НАЗВА ФАЙЛУ: cooking_history_service.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Сервіс для збереження, завантаження та автоочищення історії
//              приготування страв (зберігаємо лише останні 10 днів)
// ============================================================================

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_diet/models/cooking_history_model.dart';

class CookingHistoryService {
  static const String _storageKey = 'cooking_history_recipes_key';

  /// Отримати історію приготування (автоматично видаляє записи старші за 10 днів)
  static Future<List<CookingHistoryModel>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_storageKey);
    if (jsonString == null) return [];

    try {
      final List decoded = jsonDecode(jsonString);
      final List<CookingHistoryModel> allHistory = decoded.map((item) => CookingHistoryModel.fromJson(item)).toList();

      // Фільтруємо: залишаємо лише те, що було приготовано за останні 10 днів
      final now = DateTime.now();
      final validHistory = allHistory.where((recipe) {
        final difference = now.difference(recipe.cookedAt).inDays;
        return difference <= 10;
      }).toList();

      // Якщо щось відфільтрували, оновлюємо сховище
      if (validHistory.length != allHistory.length) {
        await _saveRawHistory(validHistory);
      }

      return validHistory;
    } catch (_) {
      return [];
    }
  }

  /// Додати новий рецепт / запис в історію
  static Future<void> saveRecipe(CookingHistoryModel recipe) async {
    final history = await loadHistory();
    history.insert(0, recipe); // Додаємо на початок
    await _saveRawHistory(history);
  }

  /// Видалити запис з історії за ID
  static Future<void> deleteRecipe(String id) async {
    final history = await loadHistory();
    history.removeWhere((r) => r.id == id);
    await _saveRawHistory(history);
  }

  /// Приватний метод для збереження списку в SharedPreferences
  static Future<void> _saveRawHistory(List<CookingHistoryModel> history) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(history.map((r) => r.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }
}
