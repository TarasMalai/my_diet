// ============================================================================
// НАЗВА ФАЙЛУ: diet_settings_service.dart
// ПРИЗНАЧЕННЯ: Сервіс управління цільовими нормами нутрієнтів
// ============================================================================

class DietSettingsService {
  // Синглтон для доступу з будь-якого місця додатка
  static final DietSettingsService _instance = DietSettingsService._internal();
  factory DietSettingsService() => _instance;
  DietSettingsService._internal();

  // --------------------------------------------------------------------------
  // ЦІЛЬОВІ НОРМИ ЗА ДЕНЬ (Демі-значення / Налаштування користувача)
  // --------------------------------------------------------------------------
  double targetPhe = 300.0; // Фенілаланін (ФА)
  double targetCalories = 2000.0; // Калорії (ккал)
  double targetProtein = 50.0; // Білки (г)
  double targetCarbs = 250.0; // Вуглеводи (г)
  double targetFat = 70.0; // Жири (г)

  // Якщо ціль дорівнює 0 або null — віджет автоматично покаже тільки спожите
  double? targetLeu; // Лейцин (мг) - за замовчуванням без цілі
  double? targetTyr; // Тирозин (мг)
  double? targetMet; // Метіонін (мг)
  double? targetLes; // Лізин (мг)

  // Метод для майбутнього екранa налаштувань
  void updateTargets({double? phe, double? calories, double? protein, double? carbs, double? fat}) {
    if (phe != null) targetPhe = phe;
    if (calories != null) targetCalories = calories;
    if (protein != null) targetProtein = protein;
    if (carbs != null) targetCarbs = carbs;
    if (fat != null) targetFat = fat;
  }
}
