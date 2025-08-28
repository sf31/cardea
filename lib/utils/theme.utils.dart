import 'package:flutter/material.dart';

bool isDarkMode(BuildContext ctx) {
  return Theme.of(ctx).brightness == Brightness.dark;
}

TextStyle themedInputTextStyle(BuildContext ctx) {
  return TextStyle(
    color: isDarkMode(ctx) ? Colors.grey[300] : Colors.grey[900],
  );
}

InputDecoration themedInputDecoration(BuildContext ctx) {
  return InputDecoration(
    fillColor: isDarkMode(ctx) ? Colors.grey[850] : Colors.grey[200],
    filled: true,
    hintStyle: TextStyle(
      color: isDarkMode(ctx) ? Colors.grey[500] : Colors.grey[700],
    ),
  );
}
