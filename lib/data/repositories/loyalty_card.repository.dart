import 'package:cardea/data/repositories/generic.repository.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty_card_sort.dart';
import 'package:sqflite/sqflite.dart';

import '../models/loyalty_card.model.dart';
import '../services/shared_prefs.service.dart';

class LoyaltyCardRepository extends GenericRepository<LoyaltyCard> {
  final SharedPreferencesService _sharedPrefs;

  LoyaltyCardRepository(this._sharedPrefs, Database db)
    : super(db, 'loyalty_cards');

  @override
  LoyaltyCard fromMap(Map<String, dynamic> map) {
    return LoyaltyCard.fromMap(map);
  }

  @override
  String getId(LoyaltyCard card) {
    return card.id;
  }

  @override
  Map<String, Object?> toMap(LoyaltyCard card) {
    return card.toMap();
  }

  Future<void> setSortBy(SortOption sortBy) async {
    await _sharedPrefs.setLoyaltyCardSortBy(sortBy);
  }

  Future<SortOption> getSortBy() async {
    return await _sharedPrefs.getLoyaltyCardSortBy();
  }
}
