import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../loyalty_card.viewmodel.dart';

class LoyaltyCardSearch extends StatefulWidget {
  const LoyaltyCardSearch({super.key});

  @override
  State<LoyaltyCardSearch> createState() => _LoyaltyCardSearchState();
}

class _LoyaltyCardSearchState extends State<LoyaltyCardSearch> {
  final _filterController = TextEditingController();
  late final LoyaltyCardViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<LoyaltyCardViewModel>();
    _filterController.text = _viewModel.searchText ?? '';
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(10),
      child: TextFormField(
        onChanged: (e) => _viewModel.onSearch(e),
        autofocus: _viewModel.searchText == null,
        onTapOutside: (evt) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_viewModel.searchText == null) _viewModel.toggleSearch();
        },
        controller: _filterController,
        decoration: InputDecoration(
          labelText: 'Find a card',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          suffixIcon: InkWell(
            onTap: () {
              final vm = Provider.of<LoyaltyCardViewModel>(
                context,
                listen: false,
              );
              vm.toggleSearch();
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Icon(Icons.close, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
