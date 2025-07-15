import 'dart:convert';

import 'package:cardea/ui/shopping-list/shopping-item.viewmodel.dart';

import '../../domain/import_export_usecase.dart';
import '../../ui/loyalty-card/loyalty-card.viewmodel.dart';
import '../models/loyalty-card.model.dart';

class ImportExportJsonUseCase implements ImportExportUseCase {
  final LoyaltyCardViewModel loyaltyCardViewModel;
  final ShoppingItemViewModel shoppingItemViewModel;

  ImportExportJsonUseCase({
    required this.loyaltyCardViewModel,
    required this.shoppingItemViewModel,
  });

  @override
  Future<String> exportDataToJson() async {
    final loyaltyCards = await loyaltyCardViewModel.repository.getAll();
    final data = {
      'loyaltyCards': loyaltyCards.map((e) => e.toMapCompact()).toList(),
    };
    return jsonEncode(data);
  }

  @override
  Future<void> importDataFromJson(String json) async {
    try {
      final data = jsonDecode(json);
      final loyaltyCardsRaw = data['loyaltyCards'];
      final loyaltyCards =
          loyaltyCardsRaw.map((e) => LoyaltyCard.fromMapCompact(e)).toList();

      await loyaltyCardViewModel.repository.clear();
      loyaltyCardViewModel.addMultiple(loyaltyCards);
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
