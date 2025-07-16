import 'package:cardea/data/repositories/generic.repository.dart';
import 'package:sqflite/sqflite.dart';

import '../models/loyalty_card.model.dart';

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
