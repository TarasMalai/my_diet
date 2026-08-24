// ============================================================================
// ВУЗОЛ: РОЗГОРТАНА ПЛИТКА ФЕНІЛАЛАНІНУ ТА СУПУТНІХ АМІНОКИСЛОТ
// Файл: lib/widgets/main_screen_widget/phe_expansion_tile_widget.dart
// ============================================================================

import 'package:flutter/material.dart';

class PheExpansionTileWidget extends StatefulWidget {
  final double phe;
  final double? targetPhe; // Необов'язкове цільове значення (null або >0)
  final double leu;
  final double tyr;
  final double met;
  final double les;

  const PheExpansionTileWidget({
    super.key,
    required this.phe,
    this.targetPhe,
    this.leu = 0,
    this.tyr = 0,
    this.met = 0,
    this.les = 0,
  });

  @override
  State<PheExpansionTileWidget> createState() => _PheExpansionTileWidgetState();
}

class _PheExpansionTileWidgetState extends State<PheExpansionTileWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final double target = widget.targetPhe ?? 0;
    final bool hasTarget = target > 0;
    final bool isExceeded = hasTarget && widget.phe > target;
    final double overflowRatio = hasTarget ? widget.phe / target : 0;
    final double progress = hasTarget ? (widget.phe / target).clamp(0.0, 1.0) : 0.0;

    final Color baseColor = Colors.purple;
    final Color statusColor = isExceeded ? Colors.red.shade600 : baseColor;
    final Color borderColor = isExceeded ? Colors.red.shade300 : baseColor.withValues(alpha: 0.25);
    final Color cardBgColor = isExceeded
        ? Colors.red.shade50.withValues(alpha: 0.3)
        : baseColor.withValues(alpha: 0.03);

    final String currentStr = widget.phe % 1 == 0 ? widget.phe.toInt().toString() : widget.phe.toStringAsFixed(1);
    final String targetStr = target % 1 == 0 ? target.toInt().toString() : target.toStringAsFixed(1);

    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: borderColor, width: isExceeded ? 1.5 : 1.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(14.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isExceeded ? Colors.red.shade100 : baseColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.science, color: isExceeded ? Colors.red.shade700 : baseColor, size: 18),
                      ),
                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          'Фенілаланін',
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade800, fontWeight: FontWeight.w500),
                        ),
                      ),

                      // Якщо ціль є — виводимо "0 / 300 ФА", якщо немає — просто "0 ФА"
                      Text(
                        hasTarget ? '$currentStr / $targetStr ФА' : '$currentStr ФА',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: statusColor),
                      ),
                      const SizedBox(width: 4),

                      Icon(
                        _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                    ],
                  ),

                  // Смужка прогресу відображається ТІЛЬКИ якщо передана ціль
                  if (hasTarget) ...[
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: isExceeded ? Colors.red.shade100 : baseColor.withValues(alpha: 0.12),
                        valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                        minHeight: 6,
                      ),
                    ),

                    if (isExceeded) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Перевищення у ${overflowRatio.toStringAsFixed(1)} раза!',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red.shade700),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),

          // Супутні амінокислоти розгортаються незалежно від наявності цілі
          if (_isExpanded) ...[
            const Divider(height: 1, thickness: 1, indent: 12, endIndent: 12),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildAminoCard('Лейцин (Leu)', widget.leu, Colors.blue),
                      const SizedBox(width: 8),
                      _buildAminoCard('Тирозин (Tyr)', widget.tyr, Colors.teal),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildAminoCard('Метіонін (Met)', widget.met, Colors.amber.shade900),
                      const SizedBox(width: 8),
                      _buildAminoCard('Лізин (Les)', widget.les, Colors.deepOrange),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAminoCard(String title, double value, Color accentColor) {
    final String valStr = value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: accentColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
            ),
            Text(
              '$valStr мг',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: accentColor),
            ),
          ],
        ),
      ),
    );
  }
}
