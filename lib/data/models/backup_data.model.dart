import 'dart:convert';

import 'loyalty_card.model.dart';
import 'shopping_item.model.dart';

class BackupData {
  static const formatVersion = 1;
  static const loyaltyCardsSection = 'loyaltyCards';
  static const shoppingItemsSection = 'shoppingItems';

  final List<LoyaltyCard>? loyaltyCards;
  final List<ShoppingItem>? shoppingItems;

  const BackupData({this.loyaltyCards, this.shoppingItems});

  String toJson() => jsonEncode(toMap());

  Map<String, Object?> toMap() {
    final includedSections = <String>[];
    final data = <String, Object?>{
      'formatVersion': formatVersion,
      'includedSections': includedSections,
    };

    if (loyaltyCards != null) {
      includedSections.add(loyaltyCardsSection);
      data[loyaltyCardsSection] =
          loyaltyCards!.map((card) => card.toMap()).toList();
    }

    if (shoppingItems != null) {
      includedSections.add(shoppingItemsSection);
      data[shoppingItemsSection] =
          shoppingItems!.map((item) => item.toMap()).toList();
    }

    return data;
  }

  factory BackupData.fromJson(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Backup must contain a JSON object.');
    }
    return BackupData.fromMap(decoded);
  }

  factory BackupData.fromMap(Map<String, dynamic> data) {
    final includedSections = _readIncludedSections(data);

    return BackupData(
      loyaltyCards:
          includedSections.contains(loyaltyCardsSection)
              ? _readLoyaltyCards(data)
              : null,
      shoppingItems:
          includedSections.contains(shoppingItemsSection)
              ? _readShoppingItems(data)
              : null,
    );
  }

  static Set<String> _readIncludedSections(Map<String, dynamic> data) {
    if (!data.containsKey('formatVersion')) {
      return {
        if (data.containsKey(loyaltyCardsSection)) loyaltyCardsSection,
        if (data.containsKey(shoppingItemsSection)) shoppingItemsSection,
      };
    }

    if (data['formatVersion'] != formatVersion) {
      throw const FormatException('Unsupported backup format version.');
    }

    final rawSections = data['includedSections'];
    if (rawSections is! List) {
      throw const FormatException('Backup sections are missing or invalid.');
    }

    final sections = <String>{};
    for (final section in rawSections) {
      if (section is! String ||
          (section != loyaltyCardsSection && section != shoppingItemsSection)) {
        throw const FormatException('Backup contains an unknown section.');
      }
      sections.add(section);
    }

    for (final section in [loyaltyCardsSection, shoppingItemsSection]) {
      if (data.containsKey(section) != sections.contains(section)) {
        throw const FormatException('Backup sections do not match its data.');
      }
    }

    return sections;
  }

  static List<LoyaltyCard> _readLoyaltyCards(Map<String, dynamic> data) {
    final rawCards = data[loyaltyCardsSection];
    if (rawCards is! List) {
      throw const FormatException('Loyalty card data is invalid.');
    }

    return rawCards.map((rawCard) {
      if (rawCard is! Map) {
        throw const FormatException('Loyalty card data is invalid.');
      }
      return LoyaltyCard.fromMap(Map<String, dynamic>.from(rawCard));
    }).toList();
  }

  static List<ShoppingItem> _readShoppingItems(Map<String, dynamic> data) {
    final rawItems = data[shoppingItemsSection];
    if (rawItems is! List) {
      throw const FormatException('Shopping item data is invalid.');
    }

    return rawItems.map((rawItem) {
      if (rawItem is! Map) {
        throw const FormatException('Shopping item data is invalid.');
      }
      return ShoppingItem.fromMap(Map<String, dynamic>.from(rawItem));
    }).toList();
  }
}
