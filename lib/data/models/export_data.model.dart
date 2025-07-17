import 'dart:convert';

class ExportData {
  final int cardCount;
  final int shoppingListCount;

  ExportData({required this.cardCount, required this.shoppingListCount});

  String toJson() {
    return jsonEncode({
      'cardCount': cardCount,
      'shoppingListCount': shoppingListCount,
    });
  }
}
