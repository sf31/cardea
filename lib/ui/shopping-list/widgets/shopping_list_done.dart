import 'package:cardea/data/models/shopping_item.model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shopping_item.viewmodel.dart';

class ShoppingListDone extends StatefulWidget {
  const ShoppingListDone({super.key});

  @override
  State<ShoppingListDone> createState() => _ShoppingListDoneState();
}

class _ShoppingListDoneState extends State<ShoppingListDone> {
  ShoppingItemViewModel _getViewModel() {
    return Provider.of<ShoppingItemViewModel>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemComplete(ShoppingItem item) {
    _getViewModel().setCompleted(item.id);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingItemViewModel>(
      builder: (context, vm, child) {
        return Expanded(
          child: ListView.builder(
            itemCount: vm.itemListDone.length,
            itemBuilder: (context, index) {
              final item = vm.itemListDone[index];
              return ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.check_box),
                  onPressed: () {
                    // _onItemComplete(item);
                    // HapticFeedback.vibrate();
                  },
                ),
                title: Text(
                  item.name,
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  // widget.onItemEdit(item);
                  // HapticFeedback.vibrate();
                },
                onLongPress: () {
                  // widget.onItemEdit(item);
                },
              ); // return ListTile(
              //   leading: IconButton(
              //     icon: const Icon(Icons.check_box_outline_blank),
              //     onPressed: () {
              //       _onItemComplete(item);
              //       HapticFeedback.vibrate();
              //     },
              //   ),
              //   title: Text(item.name),
              //   onTap: () {
              //     // widget.onItemEdit(item);
              //     HapticFeedback.vibrate();
              //   },
              //   onLongPress: () {
              //     // widget.onItemEdit(item);
              //   },
              // );
            },
          ),
        );
      },
    );
  }
}
