import 'dart:convert';

import 'package:cardea/data/models/backup_data.model.dart';
import 'package:cardea/data/models/loyalty_card.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final card = LoyaltyCard(
    id: 'card-1',
    name: 'Card',
    barcode: '123',
    color: Colors.blue,
    usageCount: 0,
  );

  test('versioned export omits unselected sections', () {
    final backup = BackupData(loyaltyCards: [card]);
    final data = jsonDecode(backup.toJson()) as Map<String, dynamic>;

    expect(data['formatVersion'], 1);
    expect(data['includedSections'], ['loyaltyCards']);
    expect(data['loyaltyCards'], isA<List>());
    expect(data.containsKey('shoppingItems'), isFalse);
  });

  test('an explicitly selected empty section remains included', () {
    final backup = BackupData(shoppingItems: const []);
    final data = jsonDecode(backup.toJson()) as Map<String, dynamic>;

    expect(data['includedSections'], ['shoppingItems']);
    expect(data['shoppingItems'], isEmpty);
  });

  test('legacy exports remain readable', () {
    final backup = BackupData.fromJson(
      jsonEncode({
        'loyaltyCards': [card.toMap()],
        'shoppingItems': [],
      }),
    );

    expect(backup.loyaltyCards, hasLength(1));
    expect(backup.shoppingItems, isEmpty);
  });

  test('unsupported versions are rejected', () {
    expect(
      () => BackupData.fromJson(
        jsonEncode({'formatVersion': 2, 'includedSections': []}),
      ),
      throwsFormatException,
    );
  });
}
