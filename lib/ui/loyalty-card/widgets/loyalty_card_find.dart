import 'package:cardea/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../loyalty_card.viewmodel.dart';

class LoyaltyCardFind extends StatefulWidget {
  final FocusNode findFocusNode;

  const LoyaltyCardFind({super.key, required this.findFocusNode});

  @override
  State<LoyaltyCardFind> createState() => _LoyaltyCardFindState();
}

class _LoyaltyCardFindState extends State<LoyaltyCardFind> {
  final _filterController = TextEditingController();
  late final LoyaltyCardViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<LoyaltyCardViewModel>();
    _filterController.text = _viewModel.filterString ?? '';
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  void _clear() {
    _viewModel.onFilter(null);
    _filterController.clear();
    widget.findFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: SearchBar(
        controller: _filterController,
        focusNode: widget.findFocusNode,
        onChanged: _viewModel.onFilter,
        onTapOutside: (_) => widget.findFocusNode.unfocus(),
        elevation: const WidgetStatePropertyAll(0),
        hintText: AppLocalizations.of(context)?.loyaltyCardSearchLabel ?? '',
        leading: const Icon(Icons.search),
        trailing: [
          if (_filterController.text.isNotEmpty)
            IconButton(
              tooltip: MaterialLocalizations.of(context).clearButtonTooltip,
              onPressed: _clear,
              icon: const Icon(Icons.close),
            ),
        ],
      ),
    );
  }
}
