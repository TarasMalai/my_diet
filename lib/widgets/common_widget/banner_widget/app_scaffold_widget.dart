// ============================================================================
// НАЗВА ФАЙЛУ: app_scaffold_widget.dart
// ПРОЄКТ: Моя дієта
// ПРИЗНАЧЕННЯ: Спільна обгортка екранів додатку із вбудованим нижнім
//              банером сповіщень та захистом від системних кнопок.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:my_diet/services/banner_service.dart';
import 'package:my_diet/widgets/common_widget/banner_widget.dart';

/// Універсальний каркас екрана (Scaffold), який автоматично додає
/// нижній банер із динамічною ротацією повідомлень.
class AppScaffoldWidget extends StatelessWidget {
  /// Заголовок екрана (якщо потрібен AppBar)
  final PreferredSizeWidget? appBar;

  /// Виринаюче меню справа (EndDrawer)
  final Widget? endDrawer;

  /// Основний вміст екрана
  final Widget body;

  /// Допоміжна плаваюча кнопка (FloatingActionButton), якщо є
  final Widget? floatingActionButton;

  /// Дія при натисканні на банер
  final VoidCallback? onBannerTap;

  /// Чи показувати банер на цьому екрані (за замовчуванням true)
  final bool showBanner;

  const AppScaffoldWidget({
    super.key,
    required this.body,
    this.appBar,
    this.endDrawer,
    this.floatingActionButton,
    this.onBannerTap,
    this.showBanner = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      endDrawer: endDrawer,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: showBanner
          ? SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Реактивна підписка на автоматичну ротацію повідомлень
                  ValueListenableBuilder<BannerMessage>(
                    valueListenable: BannerService().currentMessage,
                    builder: (context, message, child) {
                      return BannerWidget(
                        title: message.title,
                        subtitle: message.subtitle,
                        icon: message.icon,
                        onTap: onBannerTap,
                      );
                    },
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
