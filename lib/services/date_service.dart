import 'package:flutter/material.dart';

/// Глобальний сервіс управління датою в додатку (Singleton)
class DateService {
  static final DateService _instance = DateService._internal();
  factory DateService() => _instance;
  DateService._internal();

  /// Реактивна змінна дати. При старті програми автоматично ставить DateTime.now()
  final ValueNotifier<DateTime> selectedDate = ValueNotifier<DateTime>(DateTime.now());

  /// Метод для зміни дати з будь-якого вікна
  void updateDate(DateTime newDate) {
    selectedDate.value = newDate;
  }
}
