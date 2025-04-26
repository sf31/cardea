import 'package:cardea/core/repositories/generic.repository.dart';
import 'package:cardea/data/loyalty-card.entity.dart';
import 'package:sqflite/sqflite.dart';

class LoyaltyCardRepository extends GenericRepository<LoyaltyCard> {
  LoyaltyCardRepository({required Database db}) : super(db, 'loyalty_cards');

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
}
