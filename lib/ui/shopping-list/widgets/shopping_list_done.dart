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
  bool _isClearing = false;

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

  Future<void> _clearCompleted(ShoppingItemViewModel vm) async {
    if (_isClearing) return;

    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(l10n?.shoppingListClearCompletedTitle ?? ''),
            content: Text(l10n?.shoppingListClearCompletedBody ?? ''),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n?.cancelBtnLabel ?? ''),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n?.deleteBtnLabel ?? ''),
              ),
            ],
          ),
    );
    if (!mounted || confirmed != true) return;

    setState(() => _isClearing = true);
    var success = true;
    final completedIds = vm.itemListDone.map((item) => item.id).toList();
    for (final id in completedIds) {
      if (!await vm.removeById(id)) {
        success = false;
        break;
      }
    }

    if (!mounted) return;
    setState(() => _isClearing = false);
    if (!success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n?.persistenceSaveError ?? '')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingItemViewModel>(
      builder: (context, vm, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(
                            context,
                          )?.shoppingListCompletedSectionTitle(
                            vm.itemListDone.length,
                          ) ??
                          '',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    tooltip:
                        MaterialLocalizations.of(context).closeButtonTooltip,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton.icon(
                  onPressed:
                      _isClearing || vm.itemListDone.isEmpty
                          ? null
                          : () => _clearCompleted(vm),
                  icon: const Icon(Icons.delete_sweep),
                  label: Text(
                    AppLocalizations.of(
                          context,
                        )?.shoppingListClearCompletedBtn ??
                        '',
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child:
                  vm.itemListDone.isEmpty
                      ? Center(
                        child: Text(
                          AppLocalizations.of(
                                context,
                              )?.shoppingListNoCompletedLabel ??
                              '',
                        ),
                      )
                      : ListView.builder(
                        itemCount: vm.itemListDone.length,
                        itemBuilder: (context, index) {
                          final item = vm.itemListDone[index];
                          return ListTile(
                            leading: IconButton(
                              icon: const Icon(Icons.check_box),
                              onPressed:
                                  _isClearing
                                      ? null
                                      : () async {
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
                      ),
            ),
          ],
        );
      },
    );
  }
}
