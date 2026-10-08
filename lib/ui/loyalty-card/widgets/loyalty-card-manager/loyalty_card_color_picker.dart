import 'package:flutter/material.dart';

import '../loyalty_card_item.dart';

class LoyaltyCardColorPicker extends StatelessWidget {
  /// Deep Material shades: richer on a card and readable with white text.
  /// Cards saved with another colour keep it as an extra swatch.
  static final List<Color> palette = [
    Colors.red.shade700,
    Colors.pink.shade700,
    Colors.purple.shade700,
    Colors.deepPurple.shade700,
    Colors.indigo.shade700,
    Colors.blue.shade700,
    Colors.lightBlue.shade700,
    Colors.cyan.shade700,
    Colors.teal.shade700,
    Colors.green.shade700,
    Colors.lightGreen.shade700,
    Colors.lime.shade700,
    Colors.yellow.shade700,
    Colors.amber.shade700,
    Colors.orange.shade700,
    Colors.deepOrange.shade700,
    Colors.brown.shade700,
    Colors.grey.shade700,
    Colors.blueGrey.shade700,
    Colors.black,
  ];

  final Color color;

  /// The card's saved color; offered as an extra swatch when it is not part
  /// of [palette], so it is never lost.
  final Color initialColor;
  final ValueChanged<Color> onColorSelected;

  const LoyaltyCardColorPicker({
    super.key,
    required this.color,
    required this.initialColor,
    required this.onColorSelected,
  });

  static bool _sameColor(Color a, Color b) => a.toARGB32() == b.toARGB32();

  @override
  Widget build(BuildContext context) {
    final colors = [
      if (!palette.any((c) => _sameColor(c, initialColor))) initialColor,
      ...palette,
    ];
    final outline = Theme.of(context).colorScheme.onSurface;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final swatch in colors)
          Semantics(
            button: true,
            selected: _sameColor(swatch, color),
            child: InkResponse(
              onTap: () => onColorSelected(swatch),
              radius: 24,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: swatch,
                  shape: BoxShape.circle,
                  border:
                      _sameColor(swatch, color)
                          ? Border.all(color: outline, width: 3)
                          : null,
                ),
                child:
                    _sameColor(swatch, color)
                        ? Icon(
                          Icons.check,
                          color: LoyaltyCardItem.foregroundColorFor(swatch),
                        )
                        : null,
              ),
            ),
          ),
      ],
    );
  }
}
