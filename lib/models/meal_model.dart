// ============================================================================
// ВУЗОЛ 1: ІМПОРТ ЗАЛЕЖНОСТЕЙ
// ============================================================================
// Підключаємо модель продукту, оскільки прийом їжі складається зі списку продуктів
//import 'food_item_model.dart';
import 'package:my_diet/models/food_item_model.dart';
// ============================================================================
// ВУЗОЛ 2: МОДЕЛЬ ПРИЙОМУ ЇЖІ (MealModel)
// ============================================================================
// Описує один картку-прийом (Сніданок, Обід тощо) з усіма його продуктами та нотаткою.

class MealModel {
  // [ВУЗОЛ 2.1]: Поля класу
  final String id; // Унікальний ID прийому їжі
  final String title; // Назва ("Сніданок", "Другий сніданок", "Обід")
  final String? note; // Необов'язкова нотатка до прийому їжі
  final List<FoodItemModel> items; // Список спожитих продуктів у цьому прийомі

  // [ВУЗОЛ 2.2]: Конструктор
  const MealModel({required this.id, required this.title, this.note, required this.items});

  // [ВУЗОЛ 2.3]: Геттери динамічного підрахунку загальної суми нутрієнтів
  // Автоматично сумують показники всіх продуктів у списку 'items'

  double get totalPhe => items.fold(0.0, (sum, item) => sum + item.phe);
  double get totalCalories => items.fold(0.0, (sum, item) => sum + item.calories);
  double get totalProtein => items.fold(0.0, (sum, item) => sum + item.protein);
  double get totalCarbs => items.fold(0.0, (sum, item) => sum + item.carbs);
  double get totalFat => items.fold(0.0, (sum, item) => sum + item.fat);

  // [ВУЗОЛ 2.4]: Метод копіювання для зручного оновлення нотатки чи списку продуктів
  MealModel copyWith({String? id, String? title, String? note, List<FoodItemModel>? items}) {
    return MealModel(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      items: items ?? this.items,
    );
  }
}
