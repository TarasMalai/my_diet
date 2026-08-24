// lib/models/food_item_model.dart

class FoodItemModel {
  final String id;
  final String name;
  final String category;
  final String manufacturer; // <-- Додано виробника
  final double weight;
  final double phe;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  const FoodItemModel({
    required this.id,
    required this.name,
    this.category = '',
    this.manufacturer = '', // <-- За замовчуванням порожній рядок
    required this.weight,
    required this.phe,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    return FoodItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      manufacturer: json['manufacturer']?.toString() ?? '', // <-- Зчитуємо з JSON
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      phe: (json['phe'] as num?)?.toDouble() ?? 0.0,
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'manufacturer': manufacturer, // <-- Зберігаємо в JSON
      'weight': weight,
      'phe': phe,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }

  FoodItemModel copyWith({
    String? id,
    String? name,
    String? category,
    String? manufacturer,
    double? weight,
    double? phe,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
  }) {
    return FoodItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      manufacturer: manufacturer ?? this.manufacturer,
      weight: weight ?? this.weight,
      phe: phe ?? this.phe,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
    );
  }
}
