// ============================================================================
// НАЗВА ФАЙЛУ: product_search_helper_utils.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Утилітний клас для фільтрації та пріоритетного сортування
//              продуктів за пошуковим запитом.
// ШЛЯХ: lib/utils/product_search_helper.dart
// ============================================================================

import 'package:my_diet/models/product_model.dart';

class ProductSearchHelper {
  /// Фільтрує та сортує список продуктів за пошуковим запитом.
  /// Пріоритет сортування:
  /// 1. Точний збіг назви з запитом.
  /// 2. Назва продукту починається із запиту.
  /// 3. Збіг за категорією або входження всередині слова (за алфавітом).
  static List<ProductModel> filterAndSort(List<ProductModel> allProducts, String queryText) {
    final query = queryText.trim().toLowerCase();

    if (query.isEmpty) {
      return List.from(allProducts);
    }

    // Фільтрація за назвою або категорією
    final matches = allProducts.where((p) {
      final nameMatches = p.name.toLowerCase().contains(query);
      final categoryMatches = p.category.toLowerCase().contains(query);
      return nameMatches || categoryMatches;
    }).toList();

    // Сортування за пріоритетом збігу
    matches.sort((a, b) {
      final aName = a.name.toLowerCase();
      final bName = b.name.toLowerCase();

      // 1. Точний збіг назви
      final aExact = aName == query;
      final bExact = bName == query;
      if (aExact && !bExact) return -1;
      if (!aExact && bExact) return 1;

      // 2. Початок назви із запиту
      final aStarts = aName.startsWith(query);
      final bStarts = bName.startsWith(query);
      if (aStarts && !bStarts) return -1;
      if (!aStarts && bStarts) return 1;

      // 3. За алфавітом за замовчуванням
      return aName.compareTo(bName);
    });

    return matches;
  }
}
