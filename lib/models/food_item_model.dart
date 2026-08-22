// ============================================================================
// ВУЗОЛ 1: МОДЕЛЬ ОКОРЕМОГО ПРОДУКТУ/СТРАВИ (FoodItemModel)
// ============================================================================
// Цей клас відповідає за один конкретний продукт у тарілці (наприклад, "Яблуко", 150г).
// Використовуємо 'final' для незмінності даних (Immutable pattern) після створення об'єкта.

class FoodItemModel {
  // [ВУЗОЛ 1.1]: Поля класу
  final String id; // Унікальний ідентифікатор продукту в базі
  final String name; // Назва продукту або страви
  final double weight; // Вага в грамах
  final double phe; // Фенілаланін (ФА) в мг
  final double calories; // Калорії в ккал
  final double protein; // Білок у грамах
  final double carbs; // Вуглеводи в грамах
  final double fat; // Жири в грамах

  // [ВУЗОЛ 1.2]: Конструктор з іменованими обов'язковими параметрами
  const FoodItemModel({
    required this.id,
    required this.name,
    required this.weight,
    required this.phe,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  // [ВУЗОЛ 1.3]: Метод для створення копії об'єкта зі зміненими значеннями
  // Знадобиться під час редагування ваги або назви продукту користувачем
  FoodItemModel copyWith({
    String? id,
    String? name,
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
      weight: weight ?? this.weight,
      phe: phe ?? this.phe,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
    );
  }
}
