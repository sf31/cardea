import 'package:cardea/l10n/app_localizations.dart';
import 'package:cardea/utils/theme.utils.dart';
import 'package:flutter/material.dart';

class InputShoppingItem extends StatefulWidget {
  final String? name;
  final Future<bool> Function(String text, bool isChecked) onNameConfirm;
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
  bool _isSubmitting = false;

  Future<void> _submit(bool dismiss) async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    final success = await widget.onNameConfirm(_controller.text, dismiss);
    if (!mounted) return;
    if (success) _controller.clear();
    setState(() => _isSubmitting = false);
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
        enabled: !_isSubmitting,
        onTapOutside: (evt) => widget.focusLostCallback(),
        focusNode: _focusNode,
        controller: _controller,
        onSubmitted: _isSubmitting ? null : (_) => _submit(true),
        style: themedInputTextStyle(context),
        decoration: themedInputDecoration(context).copyWith(
          hintText: AppLocalizations.of(context)?.shoppingListInputHint,
          border: null,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.add_circle, color: Colors.green[600]),
            onPressed: _isSubmitting ? null : () => _submit(false),
          ),
        ),
      ),
    );
  }
}
