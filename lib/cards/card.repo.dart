import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

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

  static createTable(Database db) {
    const String sql = '''
      CREATE TABLE cards(
        id TEXT PRIMARY KEY,
        name TEXT,
        barcode TEXT,
        color NUMBER,
        imageUrl TEXT
      )
    ''';
    return db.execute(sql);
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'color': color.toARGB32(),
      'imageUrl': imageUrl,
    };
  }

  static toLoyaltyCard(Map<String, dynamic> map) {
    return LoyaltyCard(
      id: map['id'],
      name: map['name'],
      barcode: map['barcode'],
      color: Color(map['color']),
      imageUrl: map['imageUrl'],
    );
  }

  @override
  String toString() {
    return 'Card{id: $id, name: $name, barcode: $barcode, color: $color, imageUrl: $imageUrl}';
  }
}

class CardRepo extends ChangeNotifier {
  final List<LoyaltyCard> _cardList = [];
  final Database database;
  String _sortBy = 'alphabetical';

  CardRepo({required this.database}) {
    _loadCards();
  }

  UnmodifiableListView<LoyaltyCard> get cardList =>
      UnmodifiableListView(_cardList);

  void add(LoyaltyCard card) {
    int currentIndex = _cardList.indexWhere((c) => c.id == card.id);
    if (currentIndex != -1) {
      _cardList[currentIndex] = card;
      _update(card);
    } else {
      _cardList.add(card);
      _insert(card);
    }
    _sortCards();
    notifyListeners();
  }

  void removeById(String id) {
    _cardList.removeWhere((card) => card.id == id);
    _delete(id);
    notifyListeners();
  }

  void setSortPreference(String sortBy) async {
    _sortBy = sortBy;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sortBy', sortBy);
    _sortCards();
    notifyListeners();
  }

  void _sortCards() {
    if (_sortBy == 'alphabetical') {
      _cardList.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortBy == 'most-used') {
      _cardList.sort((a, b) => b.name.compareTo(a.name));
      // Add logic for "most-used" sorting if applicable
    }
  }

  Future<void> _insert(LoyaltyCard card) async {
    await database.insert(
      'cards',
      card.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _delete(String id) async {
    await database.delete('cards', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> _update(LoyaltyCard card) async {
    await database.update(
      'cards',
      card.toMap(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
  }

  Future<void> _loadCards() async {
    final List<Map<String, dynamic>> maps = await database.query('cards');
    _cardList.clear();
    for (var map in maps) {
      _cardList.add(LoyaltyCard.toLoyaltyCard(map));
    }
    final prefs = await SharedPreferences.getInstance();
    _sortBy = prefs.getString('sortBy') ?? 'alphabetical';
    _sortCards();
    notifyListeners();
  }
}
