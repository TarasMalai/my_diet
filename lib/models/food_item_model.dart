// ============================================================================
// НАЗВА ФАЙЛУ: food_item_model.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Модель даних для окремого продукту харчування (поживна цінність та вага)
// ============================================================================

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: МОДЕЛЬ ПРОДУКТУ / ХАРЧОВОГО ЕЛЕМЕНТА (FoodItemModel)
// ----------------------------------------------------------------------------
class FoodItemModel {
  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.1]: ПОЛЯ МОДЕЛІ (Властивості продукту)
  // --------------------------------------------------------------------------
  final String id;
  final String name;
  final String category; // Категорія продукту
  final double weight;
  final double phe;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  // [ДОДАНО]: Розширені амінокислоти
  final double leucine; // Лейцин (Leu)
  final double tyrosine; // Тирозин (Tyr)
  final double methionine; // Метіонін (Met)
  final double lysine; // Лізин (Lys)

  // [ДОДАНО]: Додаткові нутрієнти
  final double fiber; // Волокна / Клітковина
  final double salt; // Сіль
  final double sugar; // Цукор
  final double water; // Вода
  final double energy; // Енергія (кДж або розширена енергетична цінність)

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.2]: ГОЛОВНИЙ КОНСТРУКТОР
  // --------------------------------------------------------------------------
  const FoodItemModel({
    required this.id,
    required this.name,
    this.category = '', // За замовчуванням порожній рядок
    required this.weight,
    required this.phe,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    // [ДОДАНО]: Поля за замовчуванням для нових нутрієнтів та амінокислот
    this.leucine = 0.0,
    this.tyrosine = 0.0,
    this.methionine = 0.0,
    this.lysine = 0.0,
    this.fiber = 0.0,
    this.salt = 0.0,
    this.sugar = 0.0,
    this.water = 0.0,
    this.energy = 0.0,
  });

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.3]: СЕРІАЛІЗАЦІЯ З JSON (FoodItemModel.fromJson)
  // --------------------------------------------------------------------------
  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    return FoodItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '', // Зчитуємо з JSON
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      phe: (json['phe'] as num?)?.toDouble() ?? 0.0,
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0.0,
      // [ДОДАНО]: Зчитування нових амінокислот та нутрієнтів з JSON
      leucine: (json['leucine'] as num?)?.toDouble() ?? 0.0,
      tyrosine: (json['tyrosine'] as num?)?.toDouble() ?? 0.0,
      methionine: (json['methionine'] as num?)?.toDouble() ?? 0.0,
      lysine: (json['lysine'] as num?)?.toDouble() ?? 0.0,
      fiber: (json['fiber'] as num?)?.toDouble() ?? 0.0,
      salt: (json['salt'] as num?)?.toDouble() ?? 0.0,
      sugar: (json['sugar'] as num?)?.toDouble() ?? 0.0,
      water: (json['water'] as num?)?.toDouble() ?? 0.0,
      energy: (json['energy'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.4]: СЕРІАЛІЗАЦІЯ В JSON (toJson)
  // --------------------------------------------------------------------------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category, // Зберігаємо в JSON
      'weight': weight,
      'phe': phe,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      // [ДОДАНО]: Серіалізація нових полів в JSON
      'leucine': leucine,
      'tyrosine': tyrosine,
      'methionine': methionine,
      'lysine': lysine,
      'fiber': fiber,
      'salt': salt,
      'sugar': sugar,
      'water': water,
      'energy': energy,
    };
  }

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.5]: КОПІЮВАННЯ ОБ'ЄКТА З ЗМІНАМИ (copyWith)
  // --------------------------------------------------------------------------
  FoodItemModel copyWith({
    String? id,
    String? name,
    String? category,
    double? weight,
    double? phe,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    // [ДОДАНО]: Нові параметри в copyWith
    double? leucine,
    double? tyrosine,
    double? methionine,
    double? lysine,
    double? fiber,
    double? salt,
    double? sugar,
    double? water,
    double? energy,
  }) {
    return FoodItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      weight: weight ?? this.weight,
      phe: phe ?? this.phe,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      // [ДОДАНО]: Призначення оновлених полів
      leucine: leucine ?? this.leucine,
      tyrosine: tyrosine ?? this.tyrosine,
      methionine: methionine ?? this.methionine,
      lysine: lysine ?? this.lysine,
      fiber: fiber ?? this.fiber,
      salt: salt ?? this.salt,
      sugar: sugar ?? this.sugar,
      water: water ?? this.water,
      energy: energy ?? this.energy,
    );
  }
}
