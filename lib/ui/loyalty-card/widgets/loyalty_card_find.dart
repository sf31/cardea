import 'package:cardea/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../loyalty_card.viewmodel.dart';

/// Search field shown at the bottom of the wallet, above the keyboard.
class LoyaltyCardFind extends StatefulWidget {
  final VoidCallback onClose;

  const LoyaltyCardFind({super.key, required this.onClose});

  @override
  State<LoyaltyCardFind> createState() => _LoyaltyCardFindState();
}

class _LoyaltyCardFindState extends State<LoyaltyCardFind> {
  final _filterController = TextEditingController();
  final _focusNode = FocusNode();
  late final LoyaltyCardViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<LoyaltyCardViewModel>();
    _filterController.text = _viewModel.filterString ?? '';
    // Only open the keyboard for a new search, not when coming back to a
    // filtered list.
    if (_filterController.text.isEmpty) _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _filterController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _close() {
    _viewModel.onFilter(null);
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: SearchBar(
        controller: _filterController,
        focusNode: _focusNode,
        onChanged: _viewModel.onFilter,
        // An empty search has nothing to keep on screen.
        onTapOutside:
            (_) =>
                _filterController.text.isEmpty
                    ? _close()
                    : _focusNode.unfocus(),
        elevation: const WidgetStatePropertyAll(0),
        hintText: AppLocalizations.of(context)?.loyaltyCardSearchLabel ?? '',
        leading: const Icon(Icons.search),
        trailing: [
          IconButton(
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            onPressed: _close,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
