import 'package:cardea/data/shopping-item.entity.dart';
import 'package:flutter/material.dart';

class ShoppingListItem extends StatelessWidget {
  final Function removeCallback;
  final ShoppingItem item;

  const ShoppingListItem({
    super.key,
    required this.item,
    required this.removeCallback,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${item.name} -- ${item.updatedAt}'),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          removeCallback(item.id);
        },
      ),
      onTap: () {
        // Implement edit functionality here
      },
    );
  }
}
