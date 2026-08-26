// ============================================================================
// НАЗВА ФАЙЛУ: products_base_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Головний екран-хаб бази продуктів. Керує стан-менеджментом,
//              пошуком, скиданням даних та відображенням списку.
// ШЛЯХ: lib/widgets/databases_and_resources_widget/products_base_widget.dart
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/models/product_model.dart';
import 'package:my_diet/repositories/product_repository.dart';
import 'package:my_diet/widgets/databases_and_resources_widget/products_base_widget/product_card_widget.dart';
import 'package:my_diet/widgets/databases_and_resources_widget/products_base_widget/product_search_bar_widget.dart';

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: ГОЛОВНИЙ ВІДЖЕТ БАЗИ ПРОДУКТІВ (ProductsBaseWidget)
// ----------------------------------------------------------------------------
class ProductsBaseWidget extends StatefulWidget {
  const ProductsBaseWidget({super.key});

  @override
  State<ProductsBaseWidget> createState() => _ProductsBaseWidgetState();
}

class _ProductsBaseWidgetState extends State<ProductsBaseWidget> {
  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.1]: СТАН ТА КОНТРОЛЕРИ
  // --------------------------------------------------------------------------
  final ProductRepository _repository = ProductRepository();
  final TextEditingController _searchController = TextEditingController();

  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 2]: ЛОГІКА ЗАВАНТАЖЕННЯ ТА ФІЛЬТРАЦІЇ
  // --------------------------------------------------------------------------

  /// [ВУЗОЛ 2.1]: Первинне завантаження з репозиторію
  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    final products = await _repository.loadProducts();
    setState(() {
      _allProducts = products;
      _filteredProducts = products;
      _isLoading = false;
    });
  }

  /// [ВУЗОЛ 2.2]: Фільтрація та релевантне сортування за запитом
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = List.from(_allProducts);
      } else {
        // 1. Відбірка співпадінь
        final matched = _allProducts.where((product) {
          final name = product.name.toLowerCase();
          final category = product.category.toLowerCase();
          return name.contains(query) || category.contains(query);
        }).toList();

        // 2. Сортування за релевантністю
        matched.sort((a, b) {
          final aName = a.name.toLowerCase();
          final bName = b.name.toLowerCase();

          // Пріоритет 1: Точний збіг назви
          final aExact = aName == query;
          final bExact = bName == query;
          if (aExact && !bExact) return -1;
          if (!aExact && bExact) return 1;

          // Пріоритет 2: Назва ПОЧИНАЄТЬСЯ з шуканого слова (напр. "Яблуко...")
          final aStartsWith = aName.startsWith(query);
          final bStartsWith = bName.startsWith(query);
          if (aStartsWith && !bStartsWith) return -1;
          if (!aStartsWith && bStartsWith) return 1;

          // Пріоритет 3: За алфавітом
          return aName.compareTo(bName);
        });

        _filteredProducts = matched;
      }
    });
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 3]: СКИДАННЯ БАЗИ ТА ДІЇ З ПРОДУКТАМИ
  // --------------------------------------------------------------------------

  /// [ВУЗОЛ 3.1]: Скидання бази до початкового еталону з assets
  Future<void> _resetToDefault() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Скидання бази'),
        content: const Text('Ви дійсно бажаєте скинути всі зміни і повернути початкову базу продуктів?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Скасувати')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Скинути', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      final resetProducts = await _repository.resetToDefault();
      setState(() {
        _allProducts = resetProducts;
        _filteredProducts = resetProducts;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Базу продуктів відновлено до початкового стану')));
      }
    }
  }

  /// [ВУЗОЛ 3.2]: Виклики редагування продукту
  void _editProduct(ProductModel product) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Редагування продукту: ${product.name}')));
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 4]: ПУБЛІЧНИЙ ІНТЕРФЕЙС ЕКРАНА (BUILD)
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('База продуктів'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: 'Скинути базу до початкової',
            onPressed: _resetToDefault,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // [ВУЗОЛ 4.1]: ВІДОКРЕБЛЕНИЙ ВІДЖЕТ ПОШУКОВОГО РЯДКА
                ProductSearchBarWidget(controller: _searchController, onChanged: _onSearchChanged),

                // [ВУЗОЛ 4.2]: СПИСОК КАРТОК ПРОДУКТІВ
                Expanded(
                  child: _filteredProducts.isEmpty
                      ? const Center(child: Text('Продуктів не знайдено'))
                      : ListView.builder(
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = _filteredProducts[index];
                            // [ВУЗОЛ 4.2.1]: ВІДОКРЕБЛЕНИЙ ВІДЖЕТ КАРТКИ ПРОДУКТУ
                            return ProductCardWidget(product: product, onEdit: () => _editProduct(product));
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
