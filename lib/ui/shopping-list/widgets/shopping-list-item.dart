import 'package:cardea/data/models/shopping-item.model.dart';
import 'package:flutter/material.dart';

class ShoppingListItem extends StatelessWidget {
  final Function(String id) completeCb;
  final ShoppingItem item;

  const ShoppingListItem({
    super.key,
    required this.item,
    required this.completeCb,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${item.name} -- ${item.updatedAt} -- ${item.completedAt}'),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          completeCb(item.id);
        },
      ),
      onTap: () {
        // Implement edit functionality here
      },
    );
  }
}
