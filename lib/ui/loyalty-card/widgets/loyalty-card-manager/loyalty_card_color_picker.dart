import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../../../l10n/app_localizations.dart';

class LoyaltyCardColorPicker extends StatelessWidget {
  final Color color;
  final Function onColorSelected;

  const LoyaltyCardColorPicker({
    super.key,
    required this.color,
    required this.onColorSelected,
  });

  void _pickColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)?.loyaltyCardManagerColorLabel ?? '',
          ),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: color,
              onColorChanged: (Color selectedColor) {
                onColorSelected(selectedColor);
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => _pickColor(context),
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ],
    );
  }
}
