// ============================================================================
// НАЗВА ФАЙЛУ: pantry_service.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Сервіс управління інвентарем, запасами та залишками страв
// ============================================================================

import 'package:my_diet/models/pantry_item_model.dart';

class PantryService {
  // Синглтон для зручного глобального доступу
  static final PantryService _instance = PantryService._internal();
  factory PantryService() => _instance;
  PantryService._internal();

  // Локальний список запасів (у майбутньому можна замінити на SQLite / Hive / SharedPreferences)
  final List<PantryItemModel> _pantryItems = [];

  /// Отримати всі поточні запаси з інвентаря
  List<PantryItemModel> getItems() {
    return List.unmodifiable(_pantryItems);
  }

  /// Додати продукт або готову страву в інвентар (або оновити, якщо вже існує)
  void saveItem(PantryItemModel item) {
    final index = _pantryItems.indexWhere((element) => element.id == item.id);
    if (index != -1) {
      _pantryItems[index] = item;
    } else {
      _pantryItems.add(item);
    }
  }

  /// Списати вагу продукту з інвентаря (наприклад, використали для готування)
  /// Якщо вага стає <= 0, продукт автоматично видаляється з інвентаря.
  void deductWeight(String itemId, double weightToDeduct) {
    final index = _pantryItems.indexWhere((element) => element.id == itemId);
    if (index != -1) {
      final currentItem = _pantryItems[index];
      currentItem.weightInGram -= weightToDeduct;

      if (currentItem.weightInGram <= 0) {
        _pantryItems.removeAt(index);
      }
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
  void removeItem(String id) {
    _pantryItems.removeWhere((item) => item.id == id);
  }
}
