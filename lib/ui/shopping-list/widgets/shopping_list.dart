import 'package:cardea/data/models/shopping_item.model.dart';
import 'package:cardea/ui/shopping-list/widgets/shopping_list_todo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../settings/settings.dart';
import '../shopping_item.viewmodel.dart';
import 'empty_shopping_liist.dart';
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

  void onNameChanged(String name, bool dismiss) {
    final itemToEdit = _itemToEdit;

    if (name.isNotEmpty) {
      if (itemToEdit == null) {
        _getViewModel().upsert(ShoppingItem.fromName(name));
      } else {
        final newItem = itemToEdit.copyWith(name: name);
        _getViewModel().upsert(newItem);
        setState(() {
          _itemToEdit = null;
          _showNewItem = false;
        });
      }
    }

    if (dismiss) setState(() => _showNewItem = false);
  }

  void onItemComplete(ShoppingItem item) {
    _getViewModel().removeById(item.id);
  }

  void onItemEdit(ShoppingItem item) {
    if (_itemToEdit != null) return;
    setState(() => _showNewItem = true);
    setState(() => _itemToEdit = item);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
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
            return EmptyShoppingList();
          }
          return Column(
            children: [
              ShoppingListTodo(
                itemList: provider.itemList,
                onItemComplete: onItemComplete,
                onItemEdit: onItemEdit,
              ),
              _showNewItem
                  ? InputShoppingItem(
                    onNameConfirm: onNameChanged,
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
                label: const Text('New Item'),
                icon: const Icon(Icons.add),
              ),
    );
  }
}
