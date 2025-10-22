import 'package:flutter/material.dart';

class LoyaltyCardBarcodeInput extends StatelessWidget {
  final TextEditingController barcodeController;

  const LoyaltyCardBarcodeInput({super.key, required this.barcodeController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (evt) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      controller: barcodeController,
      decoration: const InputDecoration(
        labelText: 'Barcode',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
