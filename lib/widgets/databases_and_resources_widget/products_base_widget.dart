// ============================================================================
// НАЗВА ФАЙЛУ: products_base_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Головний віджет екрана бази продуктів. Забезпечує відображення,
//              пошук, сортування за релевантністю, додавання, редагування,
//              видалення та скидання списку продуктів через ProductRepository.
// ШЛЯХ: lib/widgets/databases_and_resources_widget/products_base_widget.dart
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/models/product_model.dart';
import 'package:my_diet/repositories/product_repository.dart';
import 'package:my_diet/widgets/databases_and_resources_widget/products_base_widget/product_card_widget.dart';
import 'package:my_diet/widgets/databases_and_resources_widget/products_base_widget/product_edit_dialog_widget.dart';
import 'package:my_diet/widgets/databases_and_resources_widget/products_base_widget/product_search_bar_widget.dart';

/// [ВУЗОЛ 1]: ГОЛОВНИЙ ВІДЖЕТ БАЗИ ПРОДУКТІВ
class ProductsBaseWidget extends StatefulWidget {
  const ProductsBaseWidget({super.key});

  @override
  State<ProductsBaseWidget> createState() => _ProductsBaseWidgetState();
}

class _ProductsBaseWidgetState extends State<ProductsBaseWidget> {
  // --------------------------------------------------------------------------
  // СЕРВІСИ ТА СТАН ВІДЖЕТА
  // --------------------------------------------------------------------------

  /// Репозиторій для роботи з даними продуктів (SharedPreferences / Assets JSON)
  final ProductRepository _repository = ProductRepository();

  /// Контролер для зчитування пошукового запиту з текстового поля
  final TextEditingController _searchController = TextEditingController();

  /// Повний список усіх завантажених продуктів із локальної бази
  List<ProductModel> _allProducts = [];

  /// Відфільтрований та відсортований список продуктів для відображення
  List<ProductModel> _filteredProducts = [];

  /// Прапорець фонового завантаження даних
  bool _isLoading = true;

  // --------------------------------------------------------------------------
  // ЖИТТЄВИЙ ЦИКЛ (LIFECYCLE)
  // --------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    // Первинне завантаження бази продуктів при ініціалізації віджета
    _loadProducts();
    // Підключення слухача до пошукового рядка для миттєвого реагування на ввід
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    // Звільнення ресурсів контролера та слухача при знищенні віджета
    _searchController.removeListener(_filterProducts);
    _searchController.dispose();
    super.dispose();
  }

  // --------------------------------------------------------------------------
  // БІЗНЕС-ЛОГІКА ТА ЗЧИТУВАННЯ ДАНИХ
  // --------------------------------------------------------------------------

  /// [ВУЗОЛ 2]: ЗЧИТУВАННЯ ПРОДУКТІВ З РЕПОЗИТОРІЮ
  /// Асинхронно отримує список продуктів та оновлює локальний стан
  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    final products = await _repository.loadProducts();
    setState(() {
      _allProducts = products;
      _isLoading = false;
    });
    // Примусово застосовуємо фільтрацію для нового завантаженого списку
    _filterProducts();
  }

  /// [ВУЗОЛ 3]: ФІЛЬТРАЦІЯ ТА РОЗУМНЕ СОРТУВАННЯ
  /// Здійснює пошук за назвою та категорією, сортує результати за релевантністю:
  /// 1. Точні збіги -> 2. Початок слова -> 3. Алфавітний порядок
  void _filterProducts() {
    final query = _searchController.text.trim().toLowerCase();

    // Якщо пошуковий рядок порожній — показуємо весь список продуктів
    if (query.isEmpty) {
      setState(() {
        _filteredProducts = List.from(_allProducts);
      });
      return;
    }

    // 1. Первинна фільтрація продуктів за назвою або категорією
    final matches = _allProducts.where((p) {
      final nameMatches = p.name.toLowerCase().contains(query);
      final categoryMatches = p.category.toLowerCase().contains(query);
      return nameMatches || categoryMatches;
    }).toList();

    // 2. Багаторівневе сортування отриманого списку за релевантністю
    matches.sort((a, b) {
      final aName = a.name.toLowerCase();
      final bName = b.name.toLowerCase();

      // Рівень 1: Точний збіг назви з шуканим запитом
      final aExact = aName == query;
      final bExact = bName == query;
      if (aExact && !bExact) return -1;
      if (!aExact && bExact) return 1;

      // Рівень 2: Назва продукту починається з шуканої фрази
      final aStarts = aName.startsWith(query);
      final bStarts = bName.startsWith(query);
      if (aStarts && !bStarts) return -1;
      if (!aStarts && bStarts) return 1;

      // Рівень 3: Стандартне алфавітне сортування
      return aName.compareTo(bName);
    });

    setState(() {
      _filteredProducts = matches;
    });
  }

  /// [ВУЗОЛ 4]: ДОДАВАННЯ НОВОГО ПРОДУКТУ
  /// Відкриває діалог створення та зберігає оновлений список у сховище
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

  /// [ВУЗОЛ 5]: РЕДАГУВАННЯ ТА ОБРОБКА ВИДАЛЕННЯ З ДІАЛОГУ
  /// Відкриває модальний діалог із заповненими даними вибраного продукту.
  /// Очікує повернутий ProductModel (для збереження) або рядок 'delete' (для видалення).
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

  /// [ВУЗОЛ 6]: СКИДАННЯ БАЗИ ДО ЕТАЛОНУ
  /// Перезаписує збережені дані початковим JSON з assets та оновлює екран
  Future<void> _resetDatabase() async {
    final resetProducts = await _repository.resetToDefault();
    setState(() {
      _allProducts = resetProducts;
    });
    _filterProducts();
  }

  /// [ВУЗОЛ 7]: ВИДАЛЕННЯ ПРОДУКТУ З ПІДТВЕРДЖЕННЯМ
  /// Відображає попереджувальний діалог і видаляє продукт із локального списку та сховища
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

  // --------------------------------------------------------------------------
  // ПОБУДОВА ІНТЕРФЕЙСУ (UI BUILD)
  // --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Індикатор завантаження під час первинного звернення до репозиторію
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.teal));
    }

    return Scaffold(
      body: Column(
        children: [
          // Пошуковий рядок (ізольований віджет)
          ProductSearchBarWidget(controller: _searchController, onChanged: () {}),

          // Основна область: список продуктів або заглушка порожнього пошуку
          Expanded(
            child: _filteredProducts.isEmpty
                ? const Center(
                    child: Text('Продуктів не знайдено', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
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

      // Плаваючі кнопки дій (Скидання еталону та Додавання нового продукту)
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'reset_btn',
            onPressed: _resetDatabase,
            backgroundColor: Colors.grey.shade400,
            tooltip: 'Скинути до еталону з JSON',
            child: const Icon(Icons.refresh, color: Colors.white),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.extended(
            heroTag: 'add_btn',
            onPressed: _openAddProductDialog,
            backgroundColor: Colors.teal.shade700,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Додати продукт', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
