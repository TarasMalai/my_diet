// ============================================================================
// НАЗВА ФАЙЛУ: diet_settings_service.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Сервіс управління цільовими нормами нутрієнтів
// ============================================================================

// ----------------------------------------------------------------------------
// [ВУЗОЛ 1]: СЕРВІС НАЛАШТУВАНЬ ДІЄТИ (DietSettingsService)
// ----------------------------------------------------------------------------
class DietSettingsService {
  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.1]: РЕАЛІЗАЦІЯ ПАТЕРНУ SINGLETON (Одинак)
  // --------------------------------------------------------------------------
  static final DietSettingsService _instance = DietSettingsService._internal();
  factory DietSettingsService() => _instance;
  DietSettingsService._internal();

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.2]: ЦІЛЬОВІ НОРМИ НУТРІЄНТІВ ЗА ДЕНЬ (Налаштування користувача)
  // --------------------------------------------------------------------------
  // Всі типи double? — це означає:
  // - число (наприклад 300.0) = ціль встановлено
  // - null = ціль відсутня (користувач її не виставив)

  double? targetPhe = 300; // Фенілаланін (ФА)
  double? targetCalories = 2000.0; // Калорії (ккал)
  double? targetProtein = 50.0; // Білки (г)
  double? targetCarbs = 250.0; // Вуглеводи (г)
  double? targetFat = 70.0; // Жири (г)

  double? targetLeu; // Лейцин (мг)
  double? targetTyr; // Тирозин (мг)
  double? targetMet; // Метіонін (мг)
  double? targetLes; // Лізин (мг)

  // Геттер/сеттер для коректного псевдоніма лізину (Lys)
  double? get targetLys => targetLes;
  set targetLys(double? value) => targetLes = value;

  // Додаткові цільові норми для нутрієнтів
  double? targetFiber = 30.0; // Волокна / Клітковина (г)
  double? targetSalt = 100.0; // Сіль (г)
  double? targetSugar = 50.0; // Цукор (г)
  double? targetWater = 2000.0; // Вода (мл)
  double? targetEnergy = 8400.0; // Енергія (кДж)

  // --------------------------------------------------------------------------
  // [ВУЗОЛ 1.3]: МЕТОД ОНОВЛЕННЯ ЦІЛЬОВИХ НОРМ (updateTargets)
  // --------------------------------------------------------------------------
  /// Метод для оновлення цільових значень нутрієнтів.
  /// Передане значення прямо записується у змінну (навіть якщо це null).
  void updateTargets({
    double? phe,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? leu,
    double? tyr,
    double? met,
    double? lys,
    double? fiber,
    double? salt,
    double? sugar,
    double? water,
    double? energy,
  }) {
    targetPhe = phe;
    targetCalories = calories;
    targetProtein = protein;
    targetCarbs = carbs;
    targetFat = fat;

    targetLeu = leu;
    targetTyr = tyr;
    targetMet = met;
    targetLes = lys;

    targetFiber = fiber;
    targetSalt = salt;
    targetSugar = sugar;
    targetWater = water;
    targetEnergy = energy;
  }
}
