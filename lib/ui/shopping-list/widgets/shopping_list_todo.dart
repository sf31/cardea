import 'package:cardea/data/models/shopping_item.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../shopping_item.viewmodel.dart';

class ShoppingListTodo extends StatefulWidget {
  final Function(ShoppingItem item) onItemEdit;
  final bool showNewItem;

  const ShoppingListTodo({
    super.key,
    required this.onItemEdit,
    required this.showNewItem,
  });

  @override
  State<ShoppingListTodo> createState() => _ShoppingListTodoState();
}

class _ShoppingListTodoState extends State<ShoppingListTodo> {
  ShoppingItemViewModel _getViewModel() {
    return Provider.of<ShoppingItemViewModel>(context, listen: false);
  }

  Future<void> _onItemComplete(ShoppingItem item) async {
    final vm = _getViewModel();
    final success = await vm.toggleCompleted(item.id);
    if (!mounted) return;
    if (!success && vm.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(vm.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingItemViewModel>(
      builder: (context, vm, child) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: vm.itemList.length,
          itemBuilder: (context, index) {
            final item = vm.itemList[index];
            return ListTile(
              leading: IconButton(
                icon: const Icon(Icons.check_box_outline_blank),
                onPressed: () async {
                  await _onItemComplete(item);
                  HapticFeedback.vibrate();
                },
              ),
              title: Text(item.name),
              onTap: () {
                // widget.onItemEdit(item);
                // HapticFeedback.vibrate();
              },
              onLongPress: () {
                widget.onItemEdit(item);
              },
            );
          },
        );
      },
    );
  }
}
