import 'package:cardea/data/models/loyalty_card.model.dart';
import 'package:cardea/data/repositories/loyalty_card.repository.dart';
import 'package:cardea/l10n/app_localizations.dart';
import 'package:cardea/ui/loyalty-card/loyalty_card.viewmodel.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty-card-manager/loyalty_card_manager.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty_card_item.dart';
import 'package:cardea/data/models/sort_option.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart' show BarcodeFormat;
import 'package:provider/provider.dart';

class MemoryLoyaltyCardRepository implements LoyaltyCardRepository {
  MemoryLoyaltyCardRepository(this.cards);
  final List<LoyaltyCard> cards;

  @override
  Future<List<LoyaltyCard>> getAll() async => List.of(cards);
  @override
  Future<void> create(LoyaltyCard card) async => cards.add(card);
  @override
  Future<void> update(LoyaltyCard card) async {
    cards[cards.indexWhere((entry) => entry.id == card.id)] = card;
  }

  @override
  Future<SortOption> getSortBy() async => SortOption.alphabetical;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

LoyaltyCard newCard({
  String barcode = '',
  BarcodeFormat format = BarcodeFormat.code128,
  Color color = Colors.blue,
}) => LoyaltyCard(
  id: 'card-1',
  name: '',
  barcode: barcode,
  barcodeFormat: format,
  color: color,
  usageCount: 0,
);

/// Opens the manager on top of a blank page, so saving can pop it.
Future<MemoryLoyaltyCardRepository> showManager(
  WidgetTester tester,
  LoyaltyCard card, {
  bool isNewCard = true,
  List<LoyaltyCard> stored = const [],
}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final repository = MemoryLoyaltyCardRepository(List.of(stored));
  final vm = LoyaltyCardViewModel(repository: repository);
  addTearDown(vm.dispose);
  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: vm,
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  tester
      .state<NavigatorState>(find.byType(Navigator))
      .push(
        MaterialPageRoute<void>(
          builder: (_) => LoyaltyCardManager(card: card, isNewCard: isNewCard),
        ),
      );
  await tester.pumpAndSettle();
  return repository;
}

Finder field(String label) => find.widgetWithText(TextFormField, label);

Future<void> save(WidgetTester tester, String label) async {
  await tester.ensureVisible(find.widgetWithText(FilledButton, label));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(FilledButton, label));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('preview follows the typed name and picked color', (
    tester,
  ) async {
    final repository = await showManager(tester, newCard(barcode: '12345'));

    await tester.enterText(field('Card Name'), 'Gym');
    await tester.pump();
    final swatch = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          (widget.decoration as BoxDecoration?)?.color == Colors.teal.shade700,
    );
    await tester.ensureVisible(swatch);
    await tester.pumpAndSettle();
    await tester.tap(swatch);
    await tester.pump();

    final face = tester.widget<LoyaltyCardFace>(find.byType(LoyaltyCardFace));
    expect(face.name, 'Gym');
    expect(face.color, Colors.teal.shade700);
    expect(face.number, '12345');

    await save(tester, 'Add');
    expect(repository.cards.single.name, 'Gym');
    expect(
      repository.cards.single.color.toARGB32(),
      Colors.teal.shade700.toARGB32(),
    );
  });

  testWidgets('picks the type and checks the number against it', (
    tester,
  ) async {
    final repository = await showManager(tester, newCard());

    await tester.enterText(field('Card Name'), 'Shop');
    await tester.enterText(field('Card number'), '4006381333932');
    await tester.tap(find.byTooltip('Barcode type'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(MenuItemButton, 'EAN-13'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(TextFormField),
        matching: find.text('EAN-13'),
      ),
      findsOneWidget,
    );

    await save(tester, 'Add');
    expect(find.text('This number is not valid for EAN-13.'), findsOneWidget);
    expect(repository.cards, isEmpty);

    await tester.enterText(field('Card number'), '4006381333931');
    await save(tester, 'Add');
    expect(repository.cards.single.barcodeFormat, BarcodeFormat.ean13);
  });

  testWidgets(
    'an untouched scanned value saves even if the renderer rejects it',
    (tester) async {
      // Scanners report Codabar with its start/stop characters, which the
      // renderer would reject: an untouched scanned value must still save.
      final repository = await showManager(
        tester,
        newCard(barcode: 'A1234B', format: BarcodeFormat.codabar),
      );

      expect(
        find.descendant(
          of: field('Card number'),
          matching: find.text('Codabar'),
        ),
        findsOneWidget,
      );

      await tester.enterText(field('Card Name'), 'Library');
      await save(tester, 'Add');
      expect(repository.cards.single.barcode, 'A1234B');
    },
  );

  testWidgets('requires a card number', (tester) async {
    final repository = await showManager(tester, newCard());

    await tester.enterText(field('Card Name'), 'Shop');
    await save(tester, 'Add');

    expect(find.text('Please enter the card number.'), findsOneWidget);
    expect(repository.cards, isEmpty);
  });

  testWidgets('keeps a saved color that is not in the palette', (tester) async {
    const custom = Color(0xff2de700);
    final card = LoyaltyCard(
      id: 'card-1',
      name: 'Old card',
      barcode: '123',
      color: custom,
      usageCount: 4,
    );
    final repository = await showManager(
      tester,
      card,
      isNewCard: false,
      stored: [card],
    );

    final customSwatch = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          (widget.decoration as BoxDecoration?)?.color == custom,
    );
    expect(customSwatch, findsOneWidget);
    expect(
      find.descendant(of: customSwatch, matching: find.byIcon(Icons.check)),
      findsOneWidget,
    );

    await save(tester, 'Save');
    expect(repository.cards.single.color, custom);
    expect(repository.cards.single.usageCount, 4);
  });

  testWidgets('changing the type of a saved card re-checks its number', (
    tester,
  ) async {
    final card = LoyaltyCard(
      id: 'card-1',
      name: 'Old card',
      barcode: '12345',
      color: Colors.blue,
      usageCount: 0,
    );
    final repository = await showManager(
      tester,
      card,
      isNewCard: false,
      stored: [card],
    );

    await tester.tap(find.byTooltip('Barcode type'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(MenuItemButton, 'EAN-13'));
    await tester.pumpAndSettle();
    await save(tester, 'Save');

    expect(find.text('This number is not valid for EAN-13.'), findsOneWidget);
    expect(repository.cards.single.barcodeFormat, BarcodeFormat.code128);
  });
}
