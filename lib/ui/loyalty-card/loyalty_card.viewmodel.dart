import 'dart:collection';

import 'package:cardea/data/models/loyalty_card.model.dart';
import 'package:cardea/data/repositories/loyalty_card.repository.dart';
import 'package:flutter/material.dart';

class LoyaltyCardViewModel with ChangeNotifier {
  final LoyaltyCardRepository repository;
  List<LoyaltyCard> _cardList = [];
  int totalCardCount = 0;
  String sortBy = 'alphabetical';
  bool showSearch = false;
  String? searchText;

  LoyaltyCardViewModel({required this.repository}) : super() {
    loadCards();
  }

  UnmodifiableListView<LoyaltyCard> get cardList =>
      UnmodifiableListView(_cardList);

  Future<void> loadCards() async {
    _cardList = await repository.getAll();
    sortBy = await repository.getSortBy();
    totalCardCount = _cardList.length;
    _sortCards();
    notifyListeners();
  }

  void upsert(LoyaltyCard card) {
    int currentIndex = _cardList.indexWhere((c) => c.id == card.id);
    if (currentIndex != -1) {
      _cardList[currentIndex] = card;
      repository.update(card);
    } else {
      _cardList.add(card);
      repository.create(card);
    }
    _sortCards();
    notifyListeners();
  }

  void removeById(String id) {
    _cardList.removeWhere((card) => card.id == id);
    repository.delete(id);
    notifyListeners();
  }

  void setSortBy(String newSortBy) async {
    await repository.setSortBy(newSortBy);
    sortBy = newSortBy;
    _sortCards();
    notifyListeners();
  }

  void incrementUsageCount(LoyaltyCard card) {
    int index = _cardList.indexWhere((c) => c.id == card.id);
    if (index != -1) {
      _cardList[index].usageCount++;
      repository.update(_cardList[index]);
      notifyListeners();
    }
  }

  Future<void> setAll(List<LoyaltyCard> cards) async {
    await repository.setAll(cards);
    _cardList = cards;
    _sortCards();
    notifyListeners();
  }

  void _sortCards() {
    if (sortBy == 'alphabetical') {
      _cardList.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    } else if (sortBy == 'most-used') {
      _cardList.sort((a, b) => b.usageCount.compareTo(a.usageCount));
    }
  }

  Future<void> onSearch(String filter) async {
    searchText = filter;
    if (filter.isNotEmpty) {
      _cardList =
          _cardList.where((card) {
            return card.name.toLowerCase().contains(filter.toLowerCase());
          }).toList();
    } else {
      await loadCards(); // Reload all cards if search is cleared
    }
    notifyListeners();
  }

  void toggleSearch() {
    showSearch = !showSearch;
    if (!showSearch) {
      searchText = null; // Clear search filter when toggling off
      loadCards(); // Reload all cards when search is closed
    }
    notifyListeners();
  }
}
