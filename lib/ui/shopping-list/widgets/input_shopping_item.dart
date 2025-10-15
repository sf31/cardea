import 'package:cardea/l10n/app_localizations.dart';
import 'package:cardea/utils/theme.utils.dart';
import 'package:flutter/material.dart';

class InputShoppingItem extends StatefulWidget {
  final String? name;
  final void Function(String text, bool isChecked) onNameConfirm;
  final void Function() focusLostCallback;

  const InputShoppingItem({
    super.key,
    required this.onNameConfirm,
    required this.focusLostCallback,
    this.name,
  });

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
      padding: EdgeInsets.all(0.0),
      child: TextField(
        onTapOutside: (evt) => widget.focusLostCallback(),
        focusNode: _focusNode,
        controller: _controller,
        onSubmitted: (_) => _submit(true),
        style: themedInputTextStyle(context),
        decoration: themedInputDecoration(context).copyWith(
          hintText: AppLocalizations.of(context)?.shoppingListInputHint,
          border: null,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.format_list_bulleted_add,
              color: Colors.green[600],
            ),
            onPressed: () => _submit(false),
          ),
        ),
      ),
    );
  }
}
