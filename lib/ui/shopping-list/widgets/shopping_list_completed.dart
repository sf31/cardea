import 'package:cardea/data/models/shopping_item.model.dart';
import 'package:flutter/material.dart';

class ShoppingListCompleted extends StatelessWidget {
  final List<ShoppingItem> itemList;

  const ShoppingListCompleted({super.key, required this.itemList});

  @override
  Widget build(BuildContext context) {
    final completedCount =
        itemList.where((item) => item.completedAt != null).toList().length;
    return ExpansionTile(
      title: Text('Completed $completedCount'),
      // children: [
      //   ListTile(title: Text('aaa')),
      //   ListTile(title: Text('bbb')),
      //   ListTile(title: Text('ccc')),
      //   ListTile(title: Text('ddd')),
      //   ListTile(title: Text('eee')),
      // ],
      children: <Widget>[
        ListView.builder(
          itemCount: completedCount,
          itemBuilder: (context, index) {
            return ListTile(title: Text(itemList[index].name));
          },
        ),
      ],
    );
  }
}
