import 'dart:convert';

import 'package:cardea/data/models/loyalty_card.model.dart';
import 'package:cardea/data/models/shopping_item.model.dart';
import 'package:flutter/material.dart';

import '../../data/repositories/loyalty_card.repository.dart';
import '../../data/repositories/shopping_item.repository.dart';
import '../../data/services/shared_prefs.service.dart';

class SettingsViewModel with ChangeNotifier {
  final SharedPreferencesService _sharedPrefs;
  final LoyaltyCardRepository _loyaltyCardRepository;
  final ShoppingItemRepository _shoppingItemRepository;

  SettingsViewModel({
    required SharedPreferencesService sharedPrefs,
    required LoyaltyCardRepository loyaltyCardRepository,
    required ShoppingItemRepository shoppingItemRepository,
  }) : _shoppingItemRepository = shoppingItemRepository,
       _loyaltyCardRepository = loyaltyCardRepository,
       _sharedPrefs = sharedPrefs,
       super();

  Future<String> exportJson(bool exportCards, bool exportShopping) async {
    final cardList = await _loyaltyCardRepository.getAll();
    final shoppingItemList = await _shoppingItemRepository.getAll();

    final data = {
      'loyaltyCards':
          exportCards ? cardList.map((e) => e.toMap()).toList() : [],
      'shoppingItems':
          exportShopping ? shoppingItemList.map((e) => e.toMap()).toList() : [],
    };
    return jsonEncode(data);
  }

  Future<void> importJson(String json) async {
    try {
      final data = jsonDecode(json);
      final loyaltyCardsRaw = data['loyaltyCards'] ?? [];
      final shoppingItemsRaw = data['shoppingItems'] ?? [];

      await _loyaltyCardRepository.clear();
      await _shoppingItemRepository.clear();

      for (var card in loyaltyCardsRaw) {
        await _loyaltyCardRepository.create(LoyaltyCard.fromMap(card));
      }

      for (var item in shoppingItemsRaw) {
        await _shoppingItemRepository.create(ShoppingItem.fromMap(item));
      }
    } catch (e) {
      throw FormatException('Failed to import data: $e');
    }
  }
}
