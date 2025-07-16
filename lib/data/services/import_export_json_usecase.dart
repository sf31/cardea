import 'dart:convert';

import 'package:cardea/ui/shopping-list/shopping-item.viewmodel.dart';

import '../../domain/import_export_usecase.dart';
import '../../ui/loyalty-card/loyalty-card.viewmodel.dart';
import '../models/loyalty-card.model.dart';
import '../models/shopping-item.model.dart';

class ImportExportJsonUseCase implements ImportExportUseCase {
  final LoyaltyCardViewModel loyaltyCardViewModel;
  final ShoppingItemViewModel shoppingItemViewModel;

  ImportExportJsonUseCase({
    required this.loyaltyCardViewModel,
    required this.shoppingItemViewModel,
  });

  @override
  Future<String> exportDataToJson(bool exportCards, bool exportShopping) async {
    final loyaltyCards = await loyaltyCardViewModel.repository.getAll();
    final shoppingItems = await shoppingItemViewModel.repository.getAll();

    final data = {
      'loyaltyCards':
          exportCards ? loyaltyCards.map((e) => e.toMap()).toList() : [],
      'shoppingItems':
          exportShopping ? shoppingItems.map((e) => e.toMap()).toList() : [],
    };
    return jsonEncode(data);
  }

  @override
  Future<void> importDataFromJson(String json) async {
    try {
      final data = jsonDecode(json);
      final loyaltyCardsRaw = data['loyaltyCards'] ?? [];
      final shoppingItemsRaw = data['shoppingItems'] ?? [];

      final loyaltyCards =
          loyaltyCardsRaw.map((e) => LoyaltyCard.fromMap(e)).toList();
      final shoppingItems =
          shoppingItemsRaw.map((e) => ShoppingItem.fromMap(e)).toList();

      await loyaltyCardViewModel.repository.clear();
      await shoppingItemViewModel.repository.clear();

      loyaltyCardViewModel.addMultiple(loyaltyCards);
      shoppingItemViewModel.addMultiple(shoppingItems);
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
