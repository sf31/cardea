import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<void> setLoyaltyCardSortBy(String sortBy) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sortBy', sortBy);
  }

  Future<String> getLoyaltyCardSortBy() async {
    final prefs = await SharedPreferences.getInstance();
    final sortBy = prefs.getString('sortBy') ?? 'alphabetical';
    return sortBy;
  }

  Future<void> setThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode);
  }

  Future<String?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('themeMode');
  }

  Future<void> setEarlyAccessAlertShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('earlyAccessAlertShown', true);
  }

  Future<bool> earlyAccessAlertShown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('earlyAccessAlertShown') ?? false;
  }
}
