// ============================================================================
// НАЗВА ФАЙЛУ: banner_service.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Сервіс керування ротацією повідомлень та порад для нижнього банера.
// ============================================================================

import 'dart:async';
import 'package:flutter/material.dart';

/// Модель даних для одного сповіщення
class BannerMessage {
  final String title;
  final String subtitle;
  final IconData icon;

  const BannerMessage({required this.title, required this.subtitle, required this.icon});
}

/// Сервіс-Одинак (Singleton), який змінює повідомлення щохвилини
class BannerService {
  static final BannerService _instance = BannerService._internal();
  factory BannerService() => _instance;

  BannerService._internal() {
    _startTimer();
  }

  Timer? _timer;

  // Список порад про воду та здорову дієту
  static final List<BannerMessage> _messages = [
    const BannerMessage(
      title: 'Водний баланс',
      subtitle: 'Не забувайте пити чисту воду протягом дня. Склянка води прямо зараз покращить метаболізм!',
      icon: Icons.water_drop_outlined,
    ),
    const BannerMessage(
      title: 'Порада щодо гідратації',
      subtitle: 'Відчуття голоду часто плутають із спрагою. Спробуйте випити трохи води перед перекусом.',
      icon: Icons.local_drink_outlined,
    ),
    const BannerMessage(
      title: 'Контроль БЖВ',
      subtitle: 'Дотримання норми білків та амінокислот — запорука гарного самопочуття на кожен день.',
      icon: Icons.fitness_center_outlined,
    ),
    const BannerMessage(
      title: 'Баланс і дієта',
      subtitle: 'Регулярні прийоми їжі у фіксований час допомагають краще засвоювати нутрієнти.',
      icon: Icons.access_time_rounded,
    ),
  ];

  late final ValueNotifier<BannerMessage> currentMessage = ValueNotifier<BannerMessage>(_messages[0]);
  int _currentIndex = 0;

  void _startTimer() {
    // Зміна повідомлення кожні 60 секунд
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _currentIndex = (_currentIndex + 1) % _messages.length;
      currentMessage.value = _messages[_currentIndex];
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}
