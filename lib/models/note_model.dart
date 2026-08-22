// ============================================================================
// НАЗВА ФАЙЛУ: note_model.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Модель даних для сімейної нотатки
// ============================================================================

import 'package:flutter/material.dart';

enum NotePriority { low, medium, high } // Зелений, Жовтий, Червоний

class FamilyNote {
  final String id;
  final String authorName;
  final String content;
  final NotePriority priority;
  final DateTime timestamp;
  final String? attachmentPath; // Універсальний шлях до файлу (JPG або PDF)
  final bool isImage; // Прапорець для швидкої перевірки типу вкладення

  FamilyNote({
    required this.id,
    required this.authorName,
    required this.content,
    required this.priority,
    required this.timestamp,
    this.attachmentPath,
    this.isImage = false,
  });

  // Допоміжний геттер для отримання кольору пріоритету
  Color get priorityColor {
    switch (priority) {
      case NotePriority.low:
        return Colors.green.shade400;
      case NotePriority.medium:
        return Colors.amber.shade600;
      case NotePriority.high:
        return Colors.red.shade600;
    }
  }
}
