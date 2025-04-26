import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

Future<Brightness> getBrightness() async {
  final prefs = await SharedPreferences.getInstance();
  final brightness = prefs.getString('brightness');
  return brightness == 'dark' ? Brightness.dark : Brightness.light;
}

Future<void> setBrightness(Brightness brightness) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(
    'brightness',
    brightness == Brightness.dark ? 'dark' : 'light',
  );
}
