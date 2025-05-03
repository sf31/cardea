import 'package:cardea/data/models/shopping-item.model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shopping-item.viewmodel.dart';

class InputShoppingItem extends StatefulWidget {
  final VoidCallback dismissOnSubmit;

  const InputShoppingItem({super.key, required this.dismissOnSubmit});

  @override
  State<InputShoppingItem> createState() => _InputShoppingItemState();
}

class _InputShoppingItemState extends State<InputShoppingItem> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _submit(bool dismiss) {
    final userInput = _controller.text;
    if (dismiss) widget.dismissOnSubmit();
    if (userInput.isEmpty) return;
    Provider.of<ShoppingItemViewModel>(
      context,
      listen: false,
    ).upsert(ShoppingItem.fromName(userInput));
    _controller.clear();
  }

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(7.0),
      child: TextField(
        focusNode: _focusNode,
        controller: _controller,
        onSubmitted: (_) => _submit(true),
        decoration: InputDecoration(
          labelText: 'New Item',
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: const Icon(Icons.checklist),
            onPressed: () => _submit(false),
          ),
        ),
      ),
    );
  }
}
