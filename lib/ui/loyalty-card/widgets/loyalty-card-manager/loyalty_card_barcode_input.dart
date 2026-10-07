import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class LoyaltyCardBarcodeInput extends StatelessWidget {
  final TextEditingController barcodeController;
  final FormFieldValidator<String> validator;

  /// Shown inside the field, on the right: the barcode type.
  final Widget? suffix;

  const LoyaltyCardBarcodeInput({
    super.key,
    required this.barcodeController,
    required this.validator,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (evt) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      controller: barcodeController,
      decoration: InputDecoration(
        labelText:
            AppLocalizations.of(context)?.loyaltyCardManagerBarcodeLabel ?? '',
        border: const OutlineInputBorder(),
        suffixIcon: suffix,
      ),
      validator: validator,
    );
  }
}
