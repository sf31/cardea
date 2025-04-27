import 'dart:collection';

import 'package:cardea/core/repositories/shopping-item.repository.dart';
import 'package:cardea/data/shopping-item.entity.dart';
import 'package:flutter/material.dart';

class ShoppingItemProvider with ChangeNotifier {
  final ShoppingItemRepository repository;
  List<ShoppingItem> _itemList = [];

  ShoppingItemProvider({required this.repository}) : super() {
    loadItems();
  }

  UnmodifiableListView<ShoppingItem> get itemList =>
      UnmodifiableListView(_itemList);

  Future<void> loadItems() async {
    _itemList = await repository.getAll();
    notifyListeners();
  }

  void upsert(ShoppingItem item) {
    int currentIndex = _itemList.indexWhere((c) => c.id == item.id);
    if (currentIndex != -1) {
      _itemList[currentIndex] = item;
      repository.update(item);
    } else {
      _itemList.add(item);
      repository.create(item);
    }
    notifyListeners();
  }

  void removeById(String id) {
    _itemList.removeWhere((card) => card.id == id);
    repository.delete(id);
    notifyListeners();
  }
}
