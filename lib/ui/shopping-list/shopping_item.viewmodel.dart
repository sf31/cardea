import 'dart:collection';

import 'package:cardea/data/models/shopping_item.model.dart';
import 'package:cardea/data/repositories/shopping_item.repository.dart';
import 'package:flutter/material.dart';

class ShoppingItemViewModel with ChangeNotifier {
  final ShoppingItemRepository repository;
  List<ShoppingItem> _itemList = [];
  bool isLoading = true;
  bool hasLoaded = false;
  bool loadFailed = false;

  ShoppingItemViewModel({required this.repository}) : super() {
    loadItems();
  }

  UnmodifiableListView<ShoppingItem> get allItems =>
      UnmodifiableListView(_itemList);

  bool get isReady => hasLoaded && !isLoading;

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

  Future<bool> loadItems() async {
    isLoading = true;
    loadFailed = false;
    notifyListeners();

    try {
      _itemList = await repository.getAll();
      hasLoaded = true;
      return true;
    } catch (_) {
      hasLoaded = false;
      loadFailed = true;
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> upsert(ShoppingItem item) async {
    if (!isReady) return false;

    int currentIndex = _itemList.indexWhere((c) => c.id == item.id);
    try {
      if (currentIndex != -1) {
        await repository.update(item);
        _itemList[currentIndex] = item;
      } else {
        await repository.create(item);
        _itemList.add(item);
      }
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> toggleCompleted(String id) async {
    if (!isReady) return false;

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
        notifyListeners();
        return true;
      } catch (_) {
        return false;
      }
    }
    return false;
  }

  Future<bool> removeById(String id) async {
    if (!isReady) return false;

    try {
      await repository.delete(id);
      _itemList.removeWhere((card) => card.id == id);
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> setAll(List<ShoppingItem> items) async {
    await repository.setAll(items);
    _itemList = items;
    notifyListeners();
  }
}
