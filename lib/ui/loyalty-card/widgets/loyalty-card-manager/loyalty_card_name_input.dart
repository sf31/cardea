import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class LoyaltyCardNameInput extends StatelessWidget {
  final TextEditingController nameController;

  const LoyaltyCardNameInput({super.key, required this.nameController});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        TextFormField(
          textCapitalization: TextCapitalization.sentences,
          onTapOutside: (evt) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          controller: nameController,
          decoration: InputDecoration(
            labelText: l10n?.loyaltyCardManagerNameLabel ?? '',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n?.loyaltyCardManagerMissingName ?? '';
            }
            return null;
          },
        ),
      ],
    );
  }
}
