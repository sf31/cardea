import 'package:cardea/data/services/shared_prefs.service.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  ThemeProvider() {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  Future<void> _loadTheme() async {
    final mode = await _prefsService.getThemeMode();
    _themeMode = _getTheme(mode);
    notifyListeners();
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _prefsService.setThemeMode(isDark ? 'dark' : 'light');
    notifyListeners();
  }

  ThemeMode _getTheme(String? mode) {
    switch (mode) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }
}
