import 'dart:convert';

import 'package:flutter/material.dart';

import '../../data/services/shared_prefs.service.dart';

class SettingsViewModel with ChangeNotifier {
  final SharedPreferencesService _sharedPrefs;

  SettingsViewModel({required SharedPreferencesService sharedPrefs})
    : _sharedPrefs = sharedPrefs,
      super();

  Future<String> exportJson(bool exportCards, bool exportShopping) async {
    final cardList = [];
    final shoppingItemList = [];

    final data = {
      'loyaltyCards':
          exportCards ? cardList.map((e) => e.toMap()).toList() : [],
      'shoppingItems':
          exportShopping ? shoppingItemList.map((e) => e.toMap()).toList() : [],
    };
    return jsonEncode(data);
  }
}
