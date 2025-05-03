import 'package:cardea/data/models/shopping-item.model.dart';
import 'package:cardea/ui/shopping-list/widgets/shopping-list-todo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shopping-item.viewmodel.dart';
import 'empty-shopping-list.dart';
import 'input-shopping-item.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  bool showNewItem = false;
  ShoppingItem? itemToEdit;

  _getViewModel() {
    return Provider.of<ShoppingItemViewModel>(context, listen: false);
  }

  void onNameChanged(String name, bool dismiss) {
    final itemToEdit = this.itemToEdit;

    if (name.isNotEmpty) {
      if (itemToEdit == null) {
        _getViewModel().upsert(ShoppingItem.fromName(name));
      } else {
        final newItem = itemToEdit.copyWith(name: name);
        _getViewModel().upsert(newItem);
        setState(() {
          this.itemToEdit = null;
          showNewItem = false;
        });
      }
    }

    if (dismiss) setState(() => showNewItem = false);
  }

  void onItemComplete(ShoppingItem item) {
    _getViewModel().removeById(item.id);
  }

  void onItemEdit(ShoppingItem item) {
    if (itemToEdit != null) return;
    setState(() => showNewItem = true);
    setState(() => itemToEdit = item);
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
      appBar: AppBar(title: Text('Shopping List')),
      body: Consumer<ShoppingItemViewModel>(
        builder: (context, provider, child) {
          if (provider.itemList.isEmpty && !showNewItem) {
            return EmptyShoppingList();
          }

          return Column(
            children: [
              ShoppingListTodo(
                itemList: provider.itemList,
                onItemComplete: onItemComplete,
                onItemEdit: onItemEdit,
              ),
              showNewItem
                  ? InputShoppingItem(
                    onNameConfirm: onNameChanged,
                    name: itemToEdit?.name,
                  )
                  : SizedBox(),
            ],
          );
        },
      ),
      floatingActionButton:
          showNewItem
              ? SizedBox()
              : FloatingActionButton.extended(
                onPressed: () => setState(() => showNewItem = !showNewItem),
                label: const Text('New Item'),
                icon: const Icon(Icons.add),
              ),
    );
  }
}
