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
        padding: EdgeInsets.all(8.0),
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(itemList[index].name),
            trailing: IconButton(
              icon: const Icon(Icons.check_box_outline_blank),
              onPressed: () => onItemComplete(itemList[index]),
            ),
            onTap: () => onItemEdit(itemList[index]),
          );
        },
      ),
    );
  }
}
