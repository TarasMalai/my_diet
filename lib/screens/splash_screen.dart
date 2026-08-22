// ============================================================================
// НАЗВА ФАЙЛУ: splash_screen.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Екран заставки (Splash Screen). Показує логотип програми та
//              анімацію завантаження (крутілку), після чого через 3 секунди
//              автоматично перенаправляє користувача на головний екран.
// ============================================================================

import 'dart:async'; // 1.1. Потрібно для роботи таймера затримки
import 'package:flutter/material.dart';
import 'main_screen.dart'; // 1.2. Імпортуємо головний екран для подальшого переходу

// ----------------------------------------------------------------------------
// 1. КЛАС СТАНУ ЗАСТАВКИ (SplashScreen)
// ----------------------------------------------------------------------------
/// Оскільки заставка містить динамічний таймер, використовуємо StatefulWidget.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// ----------------------------------------------------------------------------
// 2. ЛОГІКА ТА ВІЗУАЛЬНЕ ОФОРМЛЕННЯ ( _SplashScreenState )
// ----------------------------------------------------------------------------
class _SplashScreenState extends State<SplashScreen> {
  // --------------------------------------------------------------------------
  // ВУЗОЛ 2.1: ІНІЦІАЛІЗАЦІЯ ТА АВТОМАТИЧНИЙ ТАЙМЕР
  // --------------------------------------------------------------------------
  /// Метод спрацьовує один раз одразу після появи заставки на екрані.
  @override
  void initState() {
    super.initState();

    // Запускаємо таймер зворотного відліку на 3 секунди
    Timer(const Duration(seconds: 3), () {
      // Захисна перевірка: чи існує ще віджет на екрані, щоб уникнути помилок
      if (!mounted) return;

      // Повністю замінюємо заставку на MainScreen (користувач не зможе повернутися назад)
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainScreen()));
    });
  }

  // --------------------------------------------------------------------------
  // ВУЗОЛ 2.2: ВІЗУАЛЬНИЙ КАРКАС (BUILD)
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Задаємо фірмовий зелений фон для заставки
      backgroundColor: Colors.green,

      body: Center(
        child: Column(
          // Центруємо весь вміст по вертикалі
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 2.2.1. Головний текстовий логотип програми
            Text(
              'Моя дієта',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2),
            ),

            // 2.2.2. Відступ між назвою та підзаголовком
            SizedBox(height: 8),

            // 2.2.3. Підзаголовок додатка
            Text('Ваш персональний помічник', style: TextStyle(fontSize: 16, color: Colors.white70)),

            // 2.2.4. Відступ перед індикатором завантаження
            SizedBox(height: 40),

            // 2.2.5. Круговий індикатор завантаження (крутілка) білого кольору
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
          ],
        ),
      ),
    );
  }
}
