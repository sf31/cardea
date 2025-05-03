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

  void dismissOnSubmit() {
    setState(() {
      showNewItem = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    showNewItem = false;
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
              ShoppingListTodo(itemList: provider.itemList),
              showNewItem
                  ? InputShoppingItem(dismissOnSubmit: dismissOnSubmit)
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

// floatingActionButton: Row(
//   mainAxisAlignment: MainAxisAlignment.end,
//   children:
//       showNewItem
//           ? [
//             Padding(
//               padding: const EdgeInsets.only(right: 16.0),
//               child: FloatingActionButton(
//                 onPressed: () => setState(() {
//                   showNewItem = false;
//                 }),
//                 backgroundColor: Colors.grey[200],
//                 child: const Icon(Icons.close),
//               ),
//             ),
//             FloatingActionButton.extended(
//               onPressed: (),
//               label: const Text('Save'),
//               icon: const Icon(Icons.check),
//               // backgroundColor: showNewItem ? Colors.grey[200] : null,
//             ),
//           ]
//           : [
//             FloatingActionButton.extended(
//               onPressed: _onNewItem,
//               label: const Text('New Item'),
//               icon: const Icon(Icons.add),
//               // backgroundColor: showNewItem ? Colors.grey[200] : null,
//             ),
//           ],
// ),
