import 'package:cardea/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../shopping_item.viewmodel.dart';

class ShoppingListDone extends StatefulWidget {
  const ShoppingListDone({super.key});

  @override
  State<ShoppingListDone> createState() => _ShoppingListDoneState();
}

class _ShoppingListDoneState extends State<ShoppingListDone> {
  Future<void> _onItemComplete(ShoppingItemViewModel vm, String id) async {
    final success = await vm.toggleCompleted(id);
    if (!mounted) return;
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)?.persistenceSaveError ?? '',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingItemViewModel>(
      builder: (context, vm, child) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: vm.itemListDone.length,
          itemBuilder: (context, index) {
            final item = vm.itemListDone[index];
            return ListTile(
              leading: IconButton(
                icon: const Icon(Icons.check_box),
                onPressed: () async {
                  await _onItemComplete(vm, item.id);
                  HapticFeedback.vibrate();
                },
              ),
              title: Text(
                item.name,
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
