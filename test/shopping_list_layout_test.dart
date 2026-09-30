import 'package:cardea/data/models/shopping_item.model.dart';
import 'package:cardea/data/repositories/shopping_item.repository.dart';
import 'package:cardea/l10n/app_localizations.dart';
import 'package:cardea/ui/shopping-list/shopping_item.viewmodel.dart';
import 'package:cardea/ui/shopping-list/widgets/shopping_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class MemoryShoppingRepository implements ShoppingItemRepository {
  MemoryShoppingRepository(this.items);
  final List<ShoppingItem> items;

  @override
  Future<List<ShoppingItem>> getAll() async => List.of(items);
  @override
  Future<void> create(ShoppingItem item) async => items.add(item);
  @override
  Future<void> update(ShoppingItem item) async {
    items[items.indexWhere((entry) => entry.id == item.id)] = item;
  }

  @override
  Future<void> delete(String id) async =>
      items.removeWhere((item) => item.id == id);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

ShoppingItem completed(String name) =>
    ShoppingItem(id: name, name: name, completedAt: DateTime(2026));

Future<ShoppingItemViewModel> showShopping(
  WidgetTester tester,
  List<ShoppingItem> items, {
  double textScale = 1,
}) async {
  final vm = ShoppingItemViewModel(repository: MemoryShoppingRepository(items));
  addTearDown(vm.dispose);
  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: vm,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder:
            (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(textScale)),
              child: child!,
            ),
        home: Scaffold(
          body: const ShoppingList(),
          bottomNavigationBar: NavigationBar(
            selectedIndex: 1,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.wallet), label: 'Cards'),
              NavigationDestination(
                icon: Icon(Icons.shopping_basket),
                label: 'Shopping',
              ),
            ],
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return vm;
}

void main() {
  testWidgets('actions stay fixed as active items change and scroll', (
    tester,
  ) async {
    final vm = await showShopping(tester, [
      ShoppingItem.fromName('Milk'),
      completed('Bread'),
    ]);
    final original = tester.getRect(find.text('Completed (1)'));
    expect(find.text('Bread'), findsNothing);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Completed (1)'),
      ),
      findsOneWidget,
    );
    for (var i = 0; i < 30; i++) {
      await vm.upsert(ShoppingItem.fromName('Item $i'));
    }
    await tester.pumpAndSettle();
    expect(tester.getRect(find.text('Completed (1)')), original);
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -600),
    );
    await tester.pumpAndSettle();
    expect(tester.getRect(find.text('Completed (1)')), original);
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -3000),
    );
    await tester.pumpAndSettle();
    final lastRow = tester.getRect(find.widgetWithText(ListTile, 'Item 29'));
    final fab = tester.getRect(find.byType(FloatingActionButton));
    expect(lastRow.bottom, lessThanOrEqualTo(fab.top));
    await tester.tap(find.text('Completed (1)'));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.text('Bread'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsNothing);
  });

  testWidgets(
    'restoring the last completed item updates sheet and active list',
    (tester) async {
      await showShopping(tester, [completed('Bread')]);
      expect(find.text('Everything is checked off.'), findsOneWidget);
      await tester.tap(find.text('Completed (1)'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.check_box));
      await tester.pumpAndSettle();
      expect(find.text('No completed items.'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.text('Bread'), findsOneWidget);
      expect(find.text('Completed (0)'), findsOneWidget);
    },
  );

  testWidgets('new item preserves plus, Done and outside-tap behavior', (
    tester,
  ) async {
    final vm = await showShopping(tester, []);
    await tester.tap(find.text('New Item'));
    await tester.pumpAndSettle();
    expect(tester.testTextInput.isVisible, isTrue);
    expect(find.byType(FloatingActionButton), findsNothing);
    await tester.enterText(find.byType(TextField), 'Milk');
    await tester.tap(find.byIcon(Icons.add_circle));
    await tester.pumpAndSettle();
    expect(vm.itemList.single.name, 'Milk');
    expect(tester.testTextInput.isVisible, isTrue);
    await tester.enterText(find.byType(TextField), 'Bread');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(vm.itemList.length, 2);
    expect(tester.testTextInput.isVisible, isFalse);
    expect(find.text('New Item'), findsOneWidget);
    await tester.tap(find.text('New Item'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Milk'));
    await tester.pumpAndSettle();
    expect(tester.testTextInput.isVisible, isFalse);
    expect(find.text('New Item'), findsOneWidget);
  });

  testWidgets('sheet scrolls long completed lists on a small screen', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await showShopping(
      tester,
      List.generate(40, (i) => completed('Done $i')),
      textScale: 1.5,
    );
    await tester.tap(find.byTooltip('Completed (40)'));
    await tester.pumpAndSettle();
    final list = find.descendant(
      of: find.byType(BottomSheet),
      matching: find.byType(ListView),
    );
    await tester.scrollUntilVisible(
      find.text('Done 39'),
      300,
      scrollable: find.descendant(of: list, matching: find.byType(Scrollable)),
    );
    expect(find.text('Done 39'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('clear completed retains confirmation and updates the sheet', (
    tester,
  ) async {
    final vm = await showShopping(tester, [completed('Bread')]);
    await tester.tap(find.text('Completed (1)'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.delete_sweep));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(vm.itemListDone, hasLength(1));
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(vm.itemListDone, isEmpty);
    expect(find.text('No completed items.'), findsOneWidget);
  });
}
