import 'package:flutter/material.dart';

import '../loyalty_card_item.dart';

class LoyaltyCardColorPicker extends StatelessWidget {
  /// The palette offered by the previous picker, so existing cards keep
  /// matching a swatch.
  static const List<Color> palette = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
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
