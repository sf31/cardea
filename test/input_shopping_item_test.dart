import 'dart:async';

import 'package:cardea/ui/shopping-list/widgets/input_shopping_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> showInput(
  WidgetTester tester, {
  required Future<bool> Function(String, bool) onConfirm,
  VoidCallback? onOutside,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 100, width: double.infinity),
            InputShoppingItem(
              onNameConfirm: onConfirm,
              focusLostCallback: onOutside ?? () {},
            ),
          ],
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets(
    'opens keyboard and retains it through repeated plus submissions',
    (tester) async {
      var pending = Completer<bool>();
      final submissions = <String>[];
      await showInput(
        tester,
        onConfirm: (text, dismiss) {
          submissions.add(text);
          expect(dismiss, isFalse);
          return pending.future;
        },
      );
      expect(tester.testTextInput.isVisible, isTrue);

      for (final name in ['Milk', 'Bread']) {
        await tester.enterText(find.byType(TextField), name);
        await tester.tap(find.byIcon(Icons.add_circle));
        await tester.pump();
        expect(tester.testTextInput.isVisible, isTrue);
        expect(
          tester.widget<TextField>(find.byType(TextField)).focusNode!.hasFocus,
          isTrue,
        );
        await tester.tap(find.byIcon(Icons.add_circle));
        await tester.pump();
        expect(submissions.where((text) => text == name).length, 1);

        pending.complete(true);
        await tester.pump();
        expect(
          tester.widget<TextField>(find.byType(TextField)).controller!.text,
          isEmpty,
        );
        expect(tester.testTextInput.isVisible, isTrue);
        pending = Completer<bool>();
      }
      expect(submissions, ['Milk', 'Bread']);
    },
  );

  testWidgets('keyboard Done submits and dismisses keyboard', (tester) async {
    final submissions = <String>[];
    await showInput(
      tester,
      onConfirm: (text, dismiss) async {
        submissions.add(text);
        expect(dismiss, isTrue);
        return true;
      },
    );
    await tester.enterText(find.byType(TextField), 'Milk');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(submissions, ['Milk']);
    expect(tester.testTextInput.isVisible, isFalse);
  });

  testWidgets('outside tap dismisses keyboard without submitting', (
    tester,
  ) async {
    var outsideTaps = 0;
    await showInput(
      tester,
      onConfirm: (_, _) async {
        fail('Outside taps must not submit');
      },
      onOutside: () => outsideTaps++,
    );
    await tester.tapAt(const Offset(20, 40));
    await tester.pump();
    expect(outsideTaps, 1);
    expect(tester.testTextInput.isVisible, isFalse);
  });

  testWidgets('failed save preserves text and keyboard', (tester) async {
    await showInput(tester, onConfirm: (_, _) async => false);
    await tester.enterText(find.byType(TextField), 'Milk');
    await tester.tap(find.byIcon(Icons.add_circle));
    await tester.pump();
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'Milk',
    );
    expect(tester.testTextInput.isVisible, isTrue);
  });

  testWidgets('save completion preserves text edited while saving', (
    tester,
  ) async {
    final pending = Completer<bool>();
    await showInput(tester, onConfirm: (_, _) => pending.future);
    await tester.enterText(find.byType(TextField), 'Milk');
    await tester.tap(find.byIcon(Icons.add_circle));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'Bread');
    pending.complete(true);
    await tester.pump();
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'Bread',
    );
    expect(tester.testTextInput.isVisible, isTrue);
  });
}
