import 'package:cardea/ui/loyalty-card/widgets/loyalty_card_sort.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<void> setLoyaltyCardSortBy(SortOption sortBy) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sortBy', sortBy.name);
  }

  Future<SortOption> getLoyaltyCardSortBy() async {
    final prefs = await SharedPreferences.getInstance();
    final sortBy = prefs.getString('sortBy');
    if (sortBy != null) {
      return SortOption.values.firstWhere(
        (e) => e.name == sortBy,
        orElse: () => SortOption.alphabetical,
      );
    }
    return SortOption.alphabetical;
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
