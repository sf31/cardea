import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../loyalty_card.viewmodel.dart';

class LoyaltyCardFind extends StatefulWidget {
  const LoyaltyCardFind({super.key});

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
        style: TextStyle(color: Colors.grey[900]),
        cursorColor: Colors.grey[700],
        onChanged: (e) => _viewModel.onFilter(e),
        autofocus: false,
        onTapOutside: (evt) => FocusManager.instance.primaryFocus?.unfocus(),
        controller: _filterController,
        decoration: InputDecoration(
          fillColor: Colors.grey[300],
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300] ?? Colors.red),
            borderRadius: BorderRadius.circular(25),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300] ?? Colors.red),
            borderRadius: BorderRadius.circular(25),
          ),
          hintStyle: TextStyle(color: Colors.grey[700]),
          hintText: 'Find a card',
          prefixIcon: Icon(Icons.search, color: Colors.grey[700]),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          suffixIcon:
              _filterController.text.isNotEmpty
                  ? InkWell(
                    onTap: () {
                      final vm = Provider.of<LoyaltyCardViewModel>(
                        context,
                        listen: false,
                      );
                      vm.onFilter('');
                      _filterController.text = '';
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: Icon(Icons.close, color: Colors.grey[700]),
                  )
                  : null,
        ),
      ),
    );
  }
}
