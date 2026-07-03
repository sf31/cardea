import 'package:cardea/data/models/shopping_item.model.dart';
import 'package:cardea/l10n/app_localizations.dart';
import 'package:cardea/ui/shopping-list/widgets/shopping_list_todo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../settings/widgets/settings.dart';
import '../shopping_item.viewmodel.dart';
import 'input_shopping_item.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  bool _showNewItem = false;
  ShoppingItem? _itemToEdit;

  ShoppingItemViewModel _getViewModel() {
    return Provider.of<ShoppingItemViewModel>(context, listen: false);
  }

  void _showPersistenceError(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? 'Unable to save changes.')),
    );
  }

  Future<bool> onNameChanged(String name, bool dismiss) async {
    final itemToEdit = _itemToEdit;
    bool success = true;

    if (name.isNotEmpty) {
      final vm = _getViewModel();
      if (itemToEdit == null) {
        success = await vm.upsert(ShoppingItem.fromName(name));
      } else {
        final newItem = itemToEdit.copyWith(name: name);
        success = await vm.upsert(newItem);
      }
      if (!mounted) return false;
      if (!success) {
        _showPersistenceError(vm.errorMessage);
        return false;
      }
      if (itemToEdit != null) {
        setState(() {
          _itemToEdit = null;
          _showNewItem = false;
        });
      }
    }

    if (dismiss) setState(() => _showNewItem = false);
    return true;
  }

  void onItemEdit(ShoppingItem item) {
    if (_itemToEdit != null) return;
    setState(() => _showNewItem = true);
    setState(() => _itemToEdit = item);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.shoppingListSectionTitle ?? ''),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => Settings()));
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Consumer<ShoppingItemViewModel>(
        builder: (context, provider, child) {
          if (provider.itemList.isEmpty && !_showNewItem) {
            return Center(
              child: Text(
                l10n?.shoppingListEmptyLabel ?? '',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          }
          return Column(
            children: [
              ShoppingListTodo(
                onItemEdit: onItemEdit,
                showNewItem: _showNewItem,
              ),
              _showNewItem
                  ? InputShoppingItem(
                    onNameConfirm: onNameChanged,
                    focusLostCallback:
                        () => setState(() {
                          _showNewItem = false;
                          _itemToEdit = null;
                        }),
                    name: _itemToEdit?.name,
                  )
                  : SizedBox(),
            ],
          );
        },
      ),
      floatingActionButton:
          _showNewItem
              ? SizedBox()
              : FloatingActionButton.extended(
                onPressed: () => setState(() => _showNewItem = !_showNewItem),
                label: Text(l10n?.shoppingListNewItemBtn ?? ''),
                icon: const Icon(Icons.add),
              ),
    );
  }
}
