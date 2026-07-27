import 'package:cardea/data/models/loyalty_card.model.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty_card_details.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty_card_item.dart';
import 'package:cardea/ui/loyalty-card/loyalty_card.viewmodel.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  test('round-trips the barcode payload and detected format', () {
    final card = LoyaltyCard(
      id: 'card-1',
      name: 'QR card',
      barcode: 'https://example.test/member/42',
      barcodeFormat: BarcodeFormat.qrCode,
      color: Colors.blue,
      usageCount: 0,
    );

    final restored = LoyaltyCard.fromMap(card.toMap());

    expect(restored.barcode, card.barcode);
    expect(restored.barcodeFormat, BarcodeFormat.qrCode);
  });

  test('legacy cards without a format default to Code 128', () {
    final card = LoyaltyCard.fromMap({
      'id': 'legacy-card',
      'name': 'Legacy card',
      'barcode': '123456789',
      'color': Colors.blue.toARGB32(),
      'usage_count': 0,
      'updated_at': 0,
    });

    expect(card.barcodeFormat, BarcodeFormat.code128);
  });

  test('copyWith preserves the barcode format', () {
    final card = LoyaltyCard(
      id: 'card-1',
      name: 'QR card',
      barcode: 'payload',
      barcodeFormat: BarcodeFormat.qrCode,
      color: Colors.blue,
      usageCount: 0,
    );

    final copied = card.copyWith();

    expect((copied as LoyaltyCard).barcodeFormat, BarcodeFormat.qrCode);
  });

  testWidgets('renders a saved QR card with a QR barcode widget', (
    tester,
  ) async {
    final card = LoyaltyCard(
      id: 'card-1',
      name: 'QR card',
      barcode: 'https://example.test/member/42',
      barcodeFormat: BarcodeFormat.qrCode,
      color: Colors.blue,
      usageCount: 0,
    );

    await tester.pumpWidget(MaterialApp(home: LoyaltyCardDetails(card: card)));

    expect(find.byType(BarcodeWidget), findsOneWidget);
  });

  test('filters card names case-insensitively and preserves source order', () {
    final cards = [
      LoyaltyCard(
        id: 'card-1',
        name: 'Super Shop',
        barcode: '1',
        color: Colors.blue,
        usageCount: 0,
      ),
      LoyaltyCard(
        id: 'card-2',
        name: 'Bookshop',
        barcode: '2',
        color: Colors.blue,
        usageCount: 0,
      ),
    ];

    final results = LoyaltyCardViewModel.filterCards(cards, 'SHOP').toList();

    expect(results.map((card) => card.id), ['card-1', 'card-2']);
  });

  test('chooses readable card text for light and dark backgrounds', () {
    expect(LoyaltyCardItem.foregroundColorFor(Colors.yellow), Colors.black);
    expect(LoyaltyCardItem.foregroundColorFor(Colors.indigo), Colors.white);
  });
}
