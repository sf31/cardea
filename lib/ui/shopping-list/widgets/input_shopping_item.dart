import 'package:cardea/l10n/app_localizations.dart';
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
    final submittedText = _controller.text;
    setState(() => _isSubmitting = true);

    final success = await widget.onNameConfirm(submittedText, dismiss);
    if (!mounted) return;
    if (success && _controller.text == submittedText) _controller.clear();
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
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      onTapOutside: (evt) {
        _focusNode.unfocus();
        widget.focusLostCallback();
      },
      focusNode: _focusNode,
      controller: _controller,
      textInputAction: TextInputAction.done,
      onSubmitted: _isSubmitting ? null : (_) => _submit(true),
      decoration: InputDecoration(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        hintText: AppLocalizations.of(context)?.shoppingListInputHint,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.add_circle, color: colorScheme.primary),
          onPressed: _isSubmitting ? null : () => _submit(false),
        ),
      ),
    );
  }
}
