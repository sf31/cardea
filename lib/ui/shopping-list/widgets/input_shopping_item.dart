import 'package:flutter/material.dart';

class InputShoppingItem extends StatefulWidget {
  final String? name;
  final void Function(String text, bool isChecked) onNameConfirm;

  const InputShoppingItem({super.key, required this.onNameConfirm, this.name});

  @override
  State<InputShoppingItem> createState() => _InputShoppingItemState();
}

class _InputShoppingItemState extends State<InputShoppingItem> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _submit(bool dismiss) {
    widget.onNameConfirm(_controller.text, dismiss);
    _controller.clear();
  }

  @override
  void initState() {
    super.initState();
    _controller.text = widget.name ?? '';
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
          hintText: 'Enter item name',
          // labelText: 'New Item',
          border: const OutlineInputBorder(),
          prefixIconColor: Colors.red,
          prefixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _submit(true),
          ),
          suffixIconColor: Colors.green,
          suffixIcon: IconButton(
            icon: const Icon(Icons.checklist),
            onPressed: () => _submit(false),
          ),
        ),
      ),
    );
  }
}
