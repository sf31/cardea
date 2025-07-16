import 'package:cardea/utils/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<void> setLoyaltyCardSortBy(String sortBy) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sortBy', sortBy);
  }

  Future<Result<String?>> getLoyaltyCardSortBy() async {
    final prefs = await SharedPreferences.getInstance();
    final sortBy = prefs.getString('sortBy') ?? 'alphabetical';
    return Result.ok(sortBy);
  }
}
