import 'dart:collection';

import 'package:cardea/data/models/loyalty_card.model.dart';
import 'package:cardea/data/repositories/loyalty_card.repository.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty_card_sort.dart';
import 'package:flutter/material.dart';

class LoyaltyCardViewModel with ChangeNotifier {
  final LoyaltyCardRepository repository;
  List<LoyaltyCard> _cardList = [];
  SortOption sortBy = SortOption.alphabetical;
  String? filterString;
  String? errorMessage;

  static Iterable<LoyaltyCard> filterCards(
    Iterable<LoyaltyCard> cards,
    String? filter,
  ) {
    if (filter == null || filter.isEmpty) return cards;

    final query = filter.toLowerCase();
    return cards.where((card) => card.name.toLowerCase().contains(query));
  }

  LoyaltyCardViewModel({required this.repository}) : super() {
    loadCards();
  }

  UnmodifiableListView<LoyaltyCard> get cardList =>
      UnmodifiableListView(_cardList);

  UnmodifiableListView<LoyaltyCard>? get filteredCardList {
    final filter = filterString;
    if (filter == null || filter.isEmpty) return null;

    return UnmodifiableListView(filterCards(_cardList, filter));
  }

  Future<void> loadCards() async {
    _cardList = await repository.getAll();
    sortBy = await repository.getSortBy();
    _sortCards();
    notifyListeners();
  }

  Future<bool> upsert(LoyaltyCard card) async {
    int currentIndex = _cardList.indexWhere((c) => c.id == card.id);
    try {
      if (currentIndex != -1) {
        await repository.update(card);
        _cardList[currentIndex] = card;
      } else {
        await repository.create(card);
        _cardList.add(card);
      }
      errorMessage = null;
      _sortCards();
      notifyListeners();
      return true;
    } catch (_) {
      errorMessage = 'Unable to save changes.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeById(String id) async {
    try {
      await repository.delete(id);
      _cardList.removeWhere((card) => card.id == id);
      errorMessage = null;
      notifyListeners();
      return true;
    } catch (_) {
      errorMessage = 'Unable to save changes.';
      notifyListeners();
      return false;
    }
  }

  void setSortBy(SortOption newSortBy) async {
    await repository.setSortBy(newSortBy);
    sortBy = newSortBy;
    _sortCards();
    notifyListeners();
  }

  Future<bool> incrementUsageCount(LoyaltyCard card) async {
    int index = _cardList.indexWhere((c) => c.id == card.id);
    if (index != -1) {
      final updatedCard = LoyaltyCard(
        id: _cardList[index].id,
        name: _cardList[index].name,
        barcode: _cardList[index].barcode,
        barcodeFormat: _cardList[index].barcodeFormat,
        color: _cardList[index].color,
        usageCount: _cardList[index].usageCount + 1,
        updatedAt: _cardList[index].updatedAt,
      );
      try {
        await repository.update(updatedCard);
        _cardList[index] = updatedCard;
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

  void clearError() {
    if (errorMessage != null) {
      errorMessage = null;
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
    if (sortBy == SortOption.alphabetical) {
      _cardList.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    } else if (sortBy == SortOption.mostUsed) {
      _cardList.sort((a, b) => b.usageCount.compareTo(a.usageCount));
    }
  }

  void onFilter(String? filter) {
    filterString = filter;
    notifyListeners();
  }
}
