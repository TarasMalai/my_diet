// ============================================================================
// НАЗВА ФАЙЛУ: product_model.dart
// ПРОЄКТ: Моя дієта
// ============================================================================

class ProductModel {
  final String id;
  final String name;
  final String category;
  final double weight;

  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final double phe;

  final double leucine;
  final double tyrosine;
  final double methionine;
  final double lysine;

  final double fiber;
  final double salt;
  final double sugar;
  final double water;
  final double energy;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    this.weight = 100.0,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.phe,
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
  // [ВУЗОЛ 1]: УНІВЕРСАЛЬНИЙ ЗЧИТУВАЧ JSON З ПІДТРИМКОЮ РІЗНИХ КЛЮЧІВ
  // --------------------------------------------------------------------------
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Допоміжна функція пошуку значення за кількома альтернативними ключами
    double parseNum(List<String> keys) {
      for (final key in keys) {
        if (json.containsKey(key) && json[key] != null) {
          return (json[key] as num).toDouble();
        }
      }
      return 0.0;
    }

    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Загальне',
      weight: parseNum(['weight', 'weight_g', 'вага']),
      calories: parseNum(['calories', 'kcal', 'ккал']),
      protein: parseNum(['protein', 'protein_g', 'білки']),
      fat: parseNum(['fat', 'fat_g', 'жири']),
      carbs: parseNum(['carbs', 'carbohydrates', 'вуглеводи']),
      phe: parseNum(['phe', 'phenylalanine', 'фа']),

      // Гнучкий зчитувач амінокислот (підтримує ключі tyr, leu, met, lys)
      leucine: parseNum(['leucine', 'leu', 'Leu', 'лейцин']),
      tyrosine: parseNum(['tyrosine', 'tyr', 'Tyr', 'тирозин']),
      methionine: parseNum(['methionine', 'met', 'Met', 'метіонін']),
      lysine: parseNum(['lysine', 'lys', 'Lys', 'лізин']),

      // Додаткові показники
      fiber: parseNum(['fiber', 'fiber_g', 'клітковина']),
      salt: parseNum(['salt', 'salt_g', 'сіль']),
      sugar: parseNum(['sugar', 'sugar_g', 'цукор']),
      water: parseNum(['water', 'water_g', 'вода']),
      energy: parseNum(['energy', 'energy_kj', 'kJ', 'енергія']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'weight': weight,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
      'phe': phe,
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
}
