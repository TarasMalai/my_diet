// ============================================================================
// НАЗВА ФАЙЛУ: app_formatters.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Утиліти для форматування тексту, інгредієнтів тощо
// ============================================================================

class AppFormatters {
  /// Форматує список інгредієнтів у короткий рядок (до 3 назв + залишок)
  static String formatIngredientsPreview(List<dynamic>? ingredients) {
    if (ingredients == null || ingredients.isEmpty) return '';

    final names = ingredients
        .map((ing) {
          // Спроба отримати назву залежно від моделі (name)
          try {
            return ing.name.toString();
          } catch (_) {
            return '';
          }
        })
        .where((n) => n.trim().isNotEmpty)
        .toList();

    if (names.isEmpty) return '';

    if (names.length <= 3) {
      return names.join(', ');
    } else {
      return '${names.take(3).join(', ')} (+ще ${names.length - 3})';
    }
  }
}
