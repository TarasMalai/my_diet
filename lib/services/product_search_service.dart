// ============================================================================
// НАЗВА ФАЙЛУ: product_search_service.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Сервіс подвійного пошуку продуктів та страв у Базі продуктів
//              та Інвентарю для щоденника харчування та модуля готування
// ============================================================================

import 'package:my_diet/models/product_model.dart';
import 'package:my_diet/models/pantry_item_model.dart';
import 'package:my_diet/repositories/product_repository.dart';
import 'package:my_diet/services/pantry_service.dart';
import 'package:my_diet/utils/product_search_helper_utils.dart';

class ProductSearchResult {
  final ProductModel? product;
  final PantryItemModel? pantryItem;
  final bool isFromPantry;

  ProductSearchResult.fromProduct(this.product) : pantryItem = null, isFromPantry = false;

  ProductSearchResult.fromPantry(this.pantryItem) : product = null, isFromPantry = true;

  String get displayName => isFromPantry ? pantryItem!.name : product!.name;

  String get subtitle {
    if (isFromPantry) {
      final type = pantryItem!.isRecipe ? 'Страва' : 'Продукт';

      // Формуємо рядок складників (беремо з ingredientsSummary або формуємо зі списку)
      String ingredientsText = '';
      if (pantryItem!.ingredients != null && pantryItem!.ingredients!.isNotEmpty) {
        final names = pantryItem!.ingredients!.map((i) => i.name).toList();
        final summary = names.length <= 3 ? names.join(', ') : '${names.take(3).join(', ')}...';
        ingredientsText = ' ($summary)';
      }

      return '$type$ingredientsText | Залишок: ${pantryItem!.weightInGram.toInt()}г | ФА: ${pantryItem!.phe.toStringAsFixed(1)} мг';
    } else {
      return 'База продуктів | ФА: ${product!.phe} мг | Ккал: ${product!.calories}';
    }
  }
}

class ProductSearchService {
  /// 1. Пошук ТІЛЬКИ в Базі продуктів
  static Future<List<ProductModel>> searchInProductsBase(String query) async {
    final allProducts = await ProductRepository().loadProducts();
    return ProductSearchHelper.filterAndSort(allProducts, query);
  }

  /// 2. Подвійний пошук: Наявні в Інвентарі + База продуктів (для Щоденника)
  static Future<List<ProductSearchResult>> searchForMeal(String query) async {
    if (query.trim().isEmpty) return [];

    final results = <ProductSearchResult>[];
    final cleanQuery = query.toLowerCase().trim();

    // 1. Спочатку шукаємо в Інвентарі
    final pantryItems = PantryService().getItems();
    final matchedPantry = pantryItems.where((item) => item.name.toLowerCase().contains(cleanQuery)).toList();

    for (var pantryItem in matchedPantry) {
      results.add(ProductSearchResult.fromPantry(pantryItem));
    }

    // 2. Додаємо варіанти з Бази продуктів
    final allProducts = await ProductRepository().loadProducts();
    final matchedProducts = ProductSearchHelper.filterAndSort(allProducts, query);

    for (var p in matchedProducts) {
      final bool alreadyInPantryResults = matchedPantry.any(
        (pItem) => pItem.name.toLowerCase() == p.name.toLowerCase() || pItem.productId == p.id,
      );

      if (!alreadyInPantryResults) {
        results.add(ProductSearchResult.fromProduct(p));
      }
    }

    return results;
  }

  /// 3. Пошук для Модуля Готування (ТІЛЬКИ сировина, без готових страв)
  static Future<List<ProductSearchResult>> searchForCooking(String query, {String? currentDishName}) async {
    if (query.trim().isEmpty) return [];

    final results = <ProductSearchResult>[];
    final cleanQuery = query.toLowerCase().trim();

    // 1. Пошук сировини з Інвентарю (суворо ігноруємо готові страви isRecipe == true)
    final pantryItems = PantryService().getItems().where((i) {
      final bool isNotRecipe = !i.isRecipe;
      final bool isNotSelf = currentDishName == null || i.name.toLowerCase() != currentDishName.toLowerCase();
      return isNotRecipe && isNotSelf;
    }).toList();

    final matchedPantry = pantryItems.where((item) => item.name.toLowerCase().contains(cleanQuery)).toList();

    for (var pantryItem in matchedPantry) {
      results.add(ProductSearchResult.fromPantry(pantryItem));
    }

    // 2. Пошук з Бази продуктів
    final allProducts = await ProductRepository().loadProducts();
    final matchedProducts = ProductSearchHelper.filterAndSort(allProducts, query);

    for (var p in matchedProducts) {
      final bool alreadyInPantry = matchedPantry.any(
        (pItem) => pItem.name.toLowerCase() == p.name.toLowerCase() || pItem.productId == p.id,
      );

      if (!alreadyInPantry) {
        results.add(ProductSearchResult.fromProduct(p));
      }
    }

    return results;
  }
}
