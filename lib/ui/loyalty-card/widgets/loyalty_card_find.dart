import 'package:cardea/utils/theme.utils.dart';
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(10),
      child: TextFormField(
        style: themedInputTextStyle(context),
        onChanged: (e) => _viewModel.onFilter(e),
        autofocus: false,
        focusNode: widget.findFocusNode,
        onTapOutside: (evt) => widget.findFocusNode.unfocus(),
        // onTapOutside: (evt) => FocusManager.instance.primaryFocus?.unfocus(),
        controller: _filterController,
        decoration: themedInputDecoration(context).copyWith(
          hintStyle: TextStyle(color: Colors.grey[500]),
          hintText: 'Find a card',
          prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(25),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(25),
          ),
          suffixIcon:
              _filterController.text.isNotEmpty
                  ? InkWell(
                    onTap: () {
                      final vm = Provider.of<LoyaltyCardViewModel>(
                        context,
                        listen: false,
                      );
                      vm.onFilter(null);
                      _filterController.text = '';
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: Icon(Icons.close, color: Colors.grey[500]),
                  )
                  : null,
        ),
      ),
    );
  }
}
