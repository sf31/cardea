import 'dart:convert';

import '../../domain/import_export_usecase.dart';
import '../models/loyalty-card.model.dart';
import '../models/shopping-item.model.dart';
import '../repositories/loyalty-card.repository.dart';
import '../repositories/shopping-item.repository.dart';

class ImportExportJsonUseCase implements ImportExportUseCase {
  final LoyaltyCardRepository loyaltyCardRepository;
  final ShoppingItemRepository shoppingItemRepository;

  ImportExportJsonUseCase({
    required this.loyaltyCardRepository,
    required this.shoppingItemRepository,
  });

  @override
  Future<String> exportDataToJson() async {
    final loyaltyCards = await loyaltyCardRepository.getAll();
    final shoppingItems = await shoppingItemRepository.getAll();
    final data = {
      'loyaltyCards': loyaltyCards.map((e) => e.toMap()).toList(),
      'shoppingItems': shoppingItems.map((e) => e.toMap()).toList(),
    };
    return jsonEncode(data);
  }

  @override
  Future<void> importDataFromJson(String json) async {
    try {
      final data = jsonDecode(json);
      if (data is! Map ||
          !data.containsKey('loyaltyCards') ||
          !data.containsKey('shoppingItems')) {
        throw FormatException('Invalid JSON structure');
      }
      final loyaltyCardsRaw = data['loyaltyCards'];
      final shoppingItemsRaw = data['shoppingItems'];
      if (loyaltyCardsRaw is! List || shoppingItemsRaw is! List) {
        throw FormatException('Invalid JSON structure: lists expected');
      }
      final loyaltyCards =
          loyaltyCardsRaw
              .map((e) => LoyaltyCard.fromMap(e as Map<String, dynamic>))
              .toList();
      final shoppingItems =
          shoppingItemsRaw
              .map((e) => ShoppingItem.fromMap(e as Map<String, dynamic>))
              .toList();
      await loyaltyCardRepository.clear();
      await shoppingItemRepository.clear();
      for (final card in loyaltyCards) {
        await loyaltyCardRepository.create(card);
      }
      for (final item in shoppingItems) {
        await shoppingItemRepository.create(item);
      }
    } catch (e) {
      throw FormatException('Failed to import data: $e');
    }
  }

  @override
  Future<String> exportDataToQrCode() async {
    // Not implemented in this class
    throw UnimplementedError();
  }

  @override
  Future<void> importDataFromQrCode(String qrData) async {
    // Not implemented in this class
    throw UnimplementedError();
  }
}
