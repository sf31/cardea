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

class _ShoppingListTodoState extends State<ShoppingListTodo>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  ShoppingItemViewModel _getViewModel() {
    return Provider.of<ShoppingItemViewModel>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    _scrollToBottom();
  }

  void _onItemComplete(ShoppingItem item) {
    _getViewModel().removeById(item.id);
  }

  void _scrollToBottom() {
    if (!widget.showNewItem) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingItemViewModel>(
      builder: (context, vm, child) {
        _scrollToBottom();

        return Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: vm.itemList.length,
            itemBuilder: (context, index) {
              final item = vm.itemList[index];
              return ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.check_box_outline_blank),
                  onPressed: () {
                    _onItemComplete(item);
                    HapticFeedback.vibrate();
                  },
                ),
                title: Text(item.name),
                onTap: () {
                  widget.onItemEdit(item);
                  // HapticFeedback.vibrate();
                },
                onLongPress: () {
                  widget.onItemEdit(item);
                },
              );
            },
          ),
        );
      },
    );
  }
}
