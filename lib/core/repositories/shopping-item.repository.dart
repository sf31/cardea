import 'package:cardea/core/repositories/generic.repository.dart';
import 'package:cardea/data/shopping-item.entity.dart';
import 'package:sqflite/sqflite.dart';

class ShoppingItemRepository extends GenericRepository<ShoppingItem> {
  ShoppingItemRepository({required Database db}) : super(db, 'shopping_items');

  @override
  ShoppingItem fromMap(Map<String, dynamic> map) {
    return ShoppingItem.fromMap(map);
  }

  @override
  String getId(ShoppingItem item) {
    return item.id;
  }

  @override
  Map<String, Object?> toMap(ShoppingItem item) {
    return item.toMap();
  }
}
