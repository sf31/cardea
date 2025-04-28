import 'dart:collection';

import 'package:cardea/data/models/loyalty-card.model.dart';
import 'package:cardea/data/repositories/loyalty-card.repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoyaltyCardViewModel with ChangeNotifier {
  final LoyaltyCardRepository repository;
  List<LoyaltyCard> _cardList = [];
  String _sortBy = 'alphabetical';

  LoyaltyCardViewModel({required this.repository}) : super() {
    loadCards();
  }

  UnmodifiableListView<LoyaltyCard> get cardList =>
      UnmodifiableListView(_cardList);

  Future<void> loadCards() async {
    _cardList = await repository.getAll();
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

  void setSortPreference(String sortBy) async {
    _sortBy = sortBy;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sortBy', sortBy);
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

  void _sortCards() {
    if (_sortBy == 'alphabetical') {
      _cardList.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    } else if (_sortBy == 'most-used') {
      _cardList.sort((a, b) => b.usageCount.compareTo(a.usageCount));
    }
  }
}
