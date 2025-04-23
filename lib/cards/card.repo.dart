import 'dart:collection';
import 'dart:ui';

import 'package:flutter/foundation.dart';

class LoyaltyCard {
  String id;
  String name;
  String barcode;
  Color color;
  String imageUrl;

  LoyaltyCard({
    required this.id,
    required this.name,
    required this.barcode,
    required this.color,
    required this.imageUrl,
  });

  factory LoyaltyCard.fromJson(Map<String, dynamic> json) {
    return LoyaltyCard(
      id: json['id'],
      name: json['name'],
      barcode: json['barcode'],
      color: json['color'],
      imageUrl: json['imageUrl'],
    );
  }
}

class CardRepo extends ChangeNotifier {
  final List<LoyaltyCard> _cardList = [];

  UnmodifiableListView<LoyaltyCard> get cardList =>
      UnmodifiableListView(_cardList);

  void add(LoyaltyCard card) {
    _cardList.add(card);
    notifyListeners();
  }

  void removeById(String id) {
    _cardList.removeWhere((card) => card.id == id);
    notifyListeners();
  }
}
