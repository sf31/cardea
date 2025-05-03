import 'package:cardea/data/models/shopping-item.model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shopping-item.viewmodel.dart';

class ShoppingListTodo extends StatelessWidget {
  final List<ShoppingItem> itemList;

  const ShoppingListTodo({super.key, required this.itemList});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: itemList.where((item) => item.completedAt == null).length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(itemList[index].name),
            trailing: IconButton(
              icon: const Icon(Icons.check_box_outline_blank),
              onPressed: () {
                Provider.of<ShoppingItemViewModel>(
                  context,
                  listen: false,
                ).removeById(itemList[index].id);
              },
            ),
            onTap: () {
              // Implement edit functionality here
              Provider.of<ShoppingItemViewModel>(
                context,
                listen: false,
              ).setCompleted(itemList[index].id);
            },
          );
        },
      ),
    );
  }
}
