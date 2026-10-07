import 'package:cardea/l10n/app_localizations.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty-card-manager/loyalty_card_manager.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty_card_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart' show BarcodeFormat;

void main() {
  testWidgets('typing the number opens an empty Code 128 card', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: LoyaltyCardScanner(),
      ),
    );
    await tester.pump();

    expect(
      find.text('Point the camera at the barcode on your card'),
      findsOneWidget,
    );
    expect(find.text("No barcode, or it won't scan?"), findsOneWidget);

    await tester.tap(find.text('Type the card number'));
    await tester.pumpAndSettle();

    final manager = tester.widget<LoyaltyCardManager>(
      find.byType(LoyaltyCardManager),
    );
    expect(manager.isNewCard, isTrue);
    expect(manager.card.barcode, isEmpty);
    expect(manager.card.barcodeFormat, BarcodeFormat.code128);
  });
}
