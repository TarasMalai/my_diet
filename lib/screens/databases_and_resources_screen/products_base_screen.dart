// ============================================================================
// НАЗВА ФАЙЛУ: products_base_screen.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Екран бази продуктів. Забезпечує відображення, пошук,
//              сортування, додавання, редагування, видалення продуктів
//              та захищене скидання бази до еталонного стану.
// ШЛЯХ: lib/screens/databases_and_resources_screen/products_base_screen.dart
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/models/product_model.dart';
import 'package:my_diet/repositories/product_repository.dart';
import 'package:my_diet/widgets/databases_and_resources_widget/products_base_widget/product_card_widget.dart';
import 'package:my_diet/widgets/databases_and_resources_widget/products_base_widget/product_edit_dialog_widget.dart';
import 'package:my_diet/widgets/databases_and_resources_widget/products_base_widget/product_search_bar_widget.dart';
import 'package:my_diet/widgets/common_widget/banner_widget/app_scaffold_widget.dart';

class ProductsBaseScreen extends StatefulWidget {
  const ProductsBaseScreen({super.key});

  @override
  State<ProductsBaseScreen> createState() => _ProductsBaseScreenState();
}

class _ProductsBaseScreenState extends State<ProductsBaseScreen> {
  final ProductRepository _repository = ProductRepository();
  final TextEditingController _searchController = TextEditingController();

  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterProducts);
    _searchController.dispose();
    super.dispose();
  }

  /// [ВУЗОЛ 1]: Завантаження списку продуктів із репозиторію
  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    final products = await _repository.loadProducts();
    setState(() {
      _allProducts = products;
      _isLoading = false;
    });
    _filterProducts();
  }

  /// [ВУЗОЛ 2]: Фільтрація та сортування продуктів за пошуковим запитом
  void _filterProducts() {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _filteredProducts = List.from(_allProducts);
      });
      return;
    }

    final matches = _allProducts.where((p) {
      final nameMatches = p.name.toLowerCase().contains(query);
      final categoryMatches = p.category.toLowerCase().contains(query);
      return nameMatches || categoryMatches;
    }).toList();

    matches.sort((a, b) {
      final aName = a.name.toLowerCase();
      final bName = b.name.toLowerCase();

      final aExact = aName == query;
      final bExact = bName == query;
      if (aExact && !bExact) return -1;
      if (!aExact && bExact) return 1;

      final aStarts = aName.startsWith(query);
      final bStarts = bName.startsWith(query);
      if (aStarts && !bStarts) return -1;
      if (!aStarts && bStarts) return 1;

      return aName.compareTo(bName);
    });

    setState(() {
      _filteredProducts = matches;
    });
  }

  /// [ВУЗОЛ 3]: Відкриття діалогу створення нового продукту
  Future<void> _openAddProductDialog() async {
    final newProduct = await showDialog<dynamic>(
      context: context,
      builder: (context) => const ProductEditDialogWidget(),
    );

    if (newProduct is ProductModel) {
      final updatedList = List<ProductModel>.from(_allProducts)..insert(0, newProduct);
      await _repository.saveProducts(updatedList);
      await _loadProducts();
    }
  }

  /// [ВУЗОЛ 4]: Відкриття діалогу редагування існуючого продукту
  Future<void> _openEditProductDialog(ProductModel product) async {
    final result = await showDialog<dynamic>(
      context: context,
      builder: (context) => ProductEditDialogWidget(product: product),
    );

    if (result == 'delete') {
      await _deleteProduct(product);
    } else if (result is ProductModel) {
      final index = _allProducts.indexWhere((p) => p.id == result.id);
      if (index != -1) {
        _allProducts[index] = result;
        await _repository.saveProducts(_allProducts);
        await _loadProducts();
      }
    }
  }

  /// [ВУЗОЛ 5]: Скидання бази до еталону з обов'язковим діалогом підтвердження (перенесено у верхнє меню)
  Future<void> _confirmAndResetDatabase() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Скидання бази даних'),
        content: const Text(
          'Ви дійсно хочете скинути базу продуктів до початкового еталонного стану? Усі ваші власні зміни або додані користувацькі продукти будуть втрачені.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Скасувати')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Скинути'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final resetProducts = await _repository.resetToDefault();
      setState(() {
        _allProducts = resetProducts;
      });
      _filterProducts();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Базу успішно скинуто до еталонного стану')));
      }
    }
  }

  /// [ВУЗОЛ 6]: Видалення окремого продукту з підтвердженням
  Future<void> _deleteProduct(ProductModel product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Видалення продукту'),
        content: Text('Ви дійсно бажаєте видалити "${product.name.isEmpty ? 'Без назви' : product.name}" з бази?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Скасувати')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Видалити'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _allProducts.removeWhere((p) => p.id == product.id);
      await _repository.saveProducts(_allProducts);
      await _loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBar: AppBar(
        title: const Text('База продуктів'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        actions: [
          // Захищене верхнє меню для опцій керування базою даних
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'reset') {
                _confirmAndResetDatabase();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.refresh, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Скинути до еталону'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : Column(
              children: [
                ProductSearchBarWidget(controller: _searchController, onChanged: () {}),
                Expanded(
                  child: _filteredProducts.isEmpty
                      ? const Center(
                          child: Text('Продуктів не знайдено', style: TextStyle(fontSize: 16, color: Colors.grey)),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 90),
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = _filteredProducts[index];
                            return ProductCardWidget(
                              product: product,
                              onEdit: () => _openEditProductDialog(product),
                              onDelete: () => _deleteProduct(product),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_product_btn',
        onPressed: _openAddProductDialog,
        backgroundColor: Colors.teal.shade700,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Додати продукт', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
