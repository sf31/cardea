import 'package:cardea/data/models/shopping_item.model.dart';
import 'package:flutter/material.dart';

class ShoppingListTodo extends StatelessWidget {
  final List<ShoppingItem> itemList;
  final Function(ShoppingItem item) onItemComplete;
  final Function(ShoppingItem item) onItemEdit;

  const ShoppingListTodo({
    super.key,
    required this.itemList,
    required this.onItemComplete,
    required this.onItemEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: IconButton(
              icon: const Icon(Icons.check_box_outline_blank),
              onPressed: () => onItemComplete(itemList[index]),
            ),
            title: Text(itemList[index].name),
            onTap: () => onItemEdit(itemList[index]),
          );
        },
      ),
    );
  }
}
