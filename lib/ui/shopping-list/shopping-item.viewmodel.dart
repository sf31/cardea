import 'dart:collection';

import 'package:cardea/data/models/shopping-item.model.dart';
import 'package:cardea/data/repositories/shopping-item.repository.dart';
import 'package:flutter/material.dart';

class ShoppingItemViewModel with ChangeNotifier {
  final ShoppingItemRepository repository;
  List<ShoppingItem> _itemList = [];

  ShoppingItemViewModel({required this.repository}) : super() {
    _loadItems();
  }

  UnmodifiableListView<ShoppingItem> get itemList =>
      UnmodifiableListView(_itemList);

  Future<void> _loadItems() async {
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

  void setCompleted(String id) {
    int currentIndex = _itemList.indexWhere((c) => c.id == id);
    if (currentIndex != -1) {
      bool completed = _itemList[currentIndex].completedAt != null;
      _itemList[currentIndex].completedAt = completed ? null : DateTime.now();
      repository.update(_itemList[currentIndex]);
      notifyListeners();
    }
  }

  void removeById(String id) {
    _itemList.removeWhere((card) => card.id == id);
    repository.delete(id);
    notifyListeners();
  }

  void addMultiple(List<ShoppingItem> items) {
    for (var item in items) {
      upsert(item);
    }
  }
}
