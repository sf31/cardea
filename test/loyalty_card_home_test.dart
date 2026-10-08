import 'package:cardea/data/models/loyalty_card.model.dart';
import 'package:cardea/data/repositories/loyalty_card.repository.dart';
import 'package:cardea/l10n/app_localizations.dart';
import 'package:cardea/ui/loyalty-card/loyalty_card.viewmodel.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty-card-manager/loyalty_card_manager.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty_card_details.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty_card_home.dart';
import 'package:cardea/data/models/sort_option.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class MemoryLoyaltyCardRepository implements LoyaltyCardRepository {
  MemoryLoyaltyCardRepository(this.cards);
  final List<LoyaltyCard> cards;
  SortOption sortBy = SortOption.alphabetical;

  @override
  Future<List<LoyaltyCard>> getAll() async => List.of(cards);
  @override
  Future<void> update(LoyaltyCard card) async {
    cards[cards.indexWhere((entry) => entry.id == card.id)] = card;
  }

  @override
  Future<SortOption> getSortBy() async => sortBy;
  @override
  Future<void> setSortBy(SortOption option) async => sortBy = option;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

LoyaltyCard card(String name, {int usageCount = 0}) => LoyaltyCard(
  id: name,
  name: name,
  barcode: '123456',
  color: Colors.blue,
  usageCount: usageCount,
);

Future<MemoryLoyaltyCardRepository> showWallet(
  WidgetTester tester,
  List<LoyaltyCard> cards,
) async {
  final repository = MemoryLoyaltyCardRepository(cards);
  final vm = LoyaltyCardViewModel(repository: repository);
  addTearDown(vm.dispose);
  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: vm,
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: LoyaltyCardHome(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return repository;
}

void main() {
  testWidgets('app bar holds sort and settings; search is a button', (
    tester,
  ) async {
    await showWallet(tester, [card('Bookshop'), card('Gym')]);

    Finder inAppBar(Finder finder) =>
        find.descendant(of: find.byType(AppBar), matching: finder);
    expect(inAppBar(find.byTooltip('Sort by')), findsOneWidget);
    expect(inAppBar(find.byIcon(Icons.settings)), findsOneWidget);
    expect(find.byType(SearchBar), findsNothing);
    expect(
      find.widgetWithIcon(FloatingActionButton, Icons.search),
      findsOneWidget,
    );
    expect(find.text('New Card'), findsOneWidget);
  });

  testWidgets('sort menu reorders cards and persists the choice', (
    tester,
  ) async {
    final repository = await showWallet(tester, [
      card('Bookshop', usageCount: 1),
      card('Gym', usageCount: 5),
    ]);
    double top(String name) => tester.getTopLeft(find.text(name)).dy;
    double left(String name) => tester.getTopLeft(find.text(name)).dx;
    expect(left('Bookshop'), lessThan(left('Gym')));
    expect(top('Bookshop'), top('Gym'));

    await tester.tap(find.byTooltip('Sort by'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Most used'));
    await tester.pumpAndSettle();

    expect(repository.sortBy, SortOption.mostUsed);
    expect(left('Gym'), lessThan(left('Bookshop')));
  });

  testWidgets('search button opens a bottom field that filters and closes', (
    tester,
  ) async {
    await showWallet(tester, [card('Bookshop'), card('Gym')]);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byType(SearchBar), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
    final searchTop = tester.getTopLeft(find.byType(SearchBar)).dy;
    expect(searchTop, greaterThan(tester.getTopLeft(find.text('Gym')).dy));

    await tester.enterText(find.byType(SearchBar), 'gy');
    await tester.pump();
    expect(find.text('Gym'), findsOneWidget);
    expect(find.text('Bookshop'), findsNothing);

    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();

    expect(find.byType(SearchBar), findsNothing);
    expect(find.text('Bookshop'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('back closes the search and clears the filter', (tester) async {
    await showWallet(tester, [card('Bookshop'), card('Gym')]);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(SearchBar), 'gy');
    await tester.pump();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byType(SearchBar), findsNothing);
    expect(find.text('Bookshop'), findsOneWidget);
  });

  testWidgets('tapping a card opens its barcode sheet with an Edit action', (
    tester,
  ) async {
    final repository = await showWallet(tester, [
      card('Bookshop', usageCount: 2),
    ]);

    await tester.tap(find.text('Bookshop'));
    await tester.pumpAndSettle();

    expect(find.byType(LoyaltyCardDetails), findsOneWidget);
    expect(repository.cards.single.usageCount, 3);
    expect(
      find.descendant(
        of: find.byType(LoyaltyCardDetails),
        matching: find.byWidgetPredicate(
          (widget) => widget is Container && widget.color == Colors.blue,
        ),
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    expect(find.byType(LoyaltyCardDetails), findsNothing);
    final manager = tester.widget<LoyaltyCardManager>(
      find.byType(LoyaltyCardManager),
    );
    expect(manager.isNewCard, isFalse);
    expect(manager.card.usageCount, 3);
  });

  testWidgets('long press still opens the editor', (tester) async {
    await showWallet(tester, [card('Bookshop')]);

    await tester.longPress(find.text('Bookshop'));
    await tester.pumpAndSettle();

    expect(find.byType(LoyaltyCardManager), findsOneWidget);
  });
}
