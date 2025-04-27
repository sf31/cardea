import 'package:cardea/app/pages/shopping/shopping-list-item.dart';
import 'package:cardea/data/shopping-item.entity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../state/shopping-item.provider.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  bool showNewItem = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _submit() {
    final userInput = _controller.text;
    if (userInput.isEmpty) return;
    Provider.of<ShoppingItemProvider>(
      context,
      listen: false,
    ).upsert(ShoppingItem(id: const Uuid().v4(), name: userInput));
    _controller.clear();
    setState(() {
      showNewItem = false;
    });
  }

  void _onNewItem() {
    setState(() {
      showNewItem = true;
      _focusNode.requestFocus();
    });
  }

  void _onSaveItem() {
    final userInput = _controller.text;
    if (userInput.isEmpty) return;

    Provider.of<ShoppingItemProvider>(
      context,
      listen: false,
    ).upsert(ShoppingItem(id: const Uuid().v4(), name: userInput));
    _controller.clear();
    setState(() {
      showNewItem = false;
    });
  }

  void _dismissNewItem() {
    _controller.clear();
    setState(() {
      showNewItem = !showNewItem;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shopping List')),
      body: Consumer<ShoppingItemProvider>(
        builder: (context, provider, child) {
          if (provider.itemList.isEmpty && !showNewItem) {
            return const Center(
              child: Text(
                'No items added yet',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.itemList.length + (showNewItem ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < provider.itemList.length) {
                final item = provider.itemList[index];
                return ShoppingListItem(
                  item: item,
                  removeCallback: (id) {
                    provider.removeById(id);
                  },
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TextField(
                  focusNode: _focusNode,
                  controller: _controller,
                  onSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: 'New Item',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: _submit,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children:
            showNewItem
                ? [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: FloatingActionButton(
                      onPressed: _dismissNewItem,
                      backgroundColor: Colors.grey[200],
                      child: const Icon(Icons.close),
                    ),
                  ),
                  FloatingActionButton.extended(
                    onPressed: _onSaveItem,
                    label: const Text('Save'),
                    icon: const Icon(Icons.check),
                    // backgroundColor: showNewItem ? Colors.grey[200] : null,
                  ),
                ]
                : [
                  FloatingActionButton.extended(
                    onPressed: _onNewItem,
                    label: const Text('New Item'),
                    icon: const Icon(Icons.add),
                    // backgroundColor: showNewItem ? Colors.grey[200] : null,
                  ),
                ],
      ),
    );
  }
}
