import 'dart:collection';

import 'package:cardea/data/models/shopping_item.model.dart';
import 'package:cardea/data/repositories/shopping_item.repository.dart';
import 'package:flutter/material.dart';

class ShoppingItemViewModel with ChangeNotifier {
  final ShoppingItemRepository repository;
  List<ShoppingItem> _itemList = [];
  String? errorMessage;

  ShoppingItemViewModel({required this.repository}) : super() {
    _loadItems();
  }

  UnmodifiableListView<ShoppingItem> get itemList {
    final toDoItems =
        _itemList.where((item) => item.completedAt == null).toList();
    return UnmodifiableListView(toDoItems);
  }

  UnmodifiableListView<ShoppingItem> get itemListDone {
    final doneItems =
        _itemList.where((item) => item.completedAt != null).toList();
    return UnmodifiableListView(doneItems);
  }

  Future<void> _loadItems() async {
    _itemList = await repository.getAll();
    notifyListeners();
  }

  Future<bool> upsert(ShoppingItem item) async {
    int currentIndex = _itemList.indexWhere((c) => c.id == item.id);
    try {
      if (currentIndex != -1) {
        await repository.update(item);
        _itemList[currentIndex] = item;
      } else {
        await repository.create(item);
        _itemList.add(item);
      }
      errorMessage = null;
      notifyListeners();
      return true;
    } catch (_) {
      errorMessage = 'Unable to save changes.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> setCompleted(String id) async {
    int currentIndex = _itemList.indexWhere((c) => c.id == id);
    if (currentIndex != -1) {
      bool completed = _itemList[currentIndex].completedAt != null;
      final updatedItem = ShoppingItem(
        id: _itemList[currentIndex].id,
        name: _itemList[currentIndex].name,
        updatedAt: _itemList[currentIndex].updatedAt,
        completedAt: completed ? null : DateTime.now(),
      );
      try {
        await repository.update(updatedItem);
        _itemList[currentIndex] = updatedItem;
        errorMessage = null;
        notifyListeners();
        return true;
      } catch (_) {
        errorMessage = 'Unable to save changes.';
        notifyListeners();
        return false;
      }
    }
    return false;
  }

  Future<bool> removeById(String id) async {
    try {
      await repository.delete(id);
      _itemList.removeWhere((card) => card.id == id);
      errorMessage = null;
      notifyListeners();
      return true;
    } catch (_) {
      errorMessage = 'Unable to save changes.';
      notifyListeners();
      return false;
    }
  }

  Future<void> setAll(List<ShoppingItem> items) async {
    await repository.setAll(items);
    _itemList = items;
    notifyListeners();
  }

  void clearError() {
    if (errorMessage != null) {
      errorMessage = null;
      notifyListeners();
    }
  }
}
