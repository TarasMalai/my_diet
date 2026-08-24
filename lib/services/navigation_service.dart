// ============================================================================
// НАЗВА ФАЙЛУ: navigation_service.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Централізований сервіс для керування навігацією (переходами)
//              між екранами додатку.
// ============================================================================

import 'package:flutter/material.dart';
// Імпортуємо екран детального харчування
import 'package:my_diet/screens/food_details_screen.dart';

class NavigationService {
  /// Перехід на екран детального споживання їжі.
  /// Параметр дати більше не потрібен, бо екран детально читає її з DateService.
  static void navigateToFoodDetails(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const FoodDetailsScreen()));
  }

  // Тут у майбутньому можна додавати інші методи навігації
}
