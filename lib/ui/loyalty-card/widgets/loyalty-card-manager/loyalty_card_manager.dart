import 'package:cardea/data/models/loyalty_card.model.dart';
import 'package:cardea/l10n/app_localizations.dart';
import 'package:cardea/ui/loyalty-card/loyalty_card.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loyalty_card_barcode_input.dart';
import 'loyalty_card_color_picker.dart';
import 'loyalty_card_name_input.dart';

class LoyaltyCardManager extends StatefulWidget {
  final LoyaltyCard card;
  final bool isNewCard;

  const LoyaltyCardManager({
    super.key,
    required this.card,
    this.isNewCard = false,
  });

  @override
  State<LoyaltyCardManager> createState() => _LoyaltyCardManagerState();
}

class _LoyaltyCardManagerState extends State<LoyaltyCardManager> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _barcodeController = TextEditingController();

  Color pickerColor = Color(0xff2de700);
  Color currentColor = Color(0xff2de700);

  @override
  void initState() {
    super.initState();
    currentColor = widget.card.color;
    _nameController.text = widget.card.name;
    _barcodeController.text = widget.card.barcode;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final barcode = _barcodeController.text;

      Provider.of<LoyaltyCardViewModel>(context, listen: false).upsert(
        LoyaltyCard(
          id: widget.card.id,
          name: name,
          barcode: barcode,
          color: currentColor,
          usageCount: widget.card.usageCount,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  void _onDelete() {
    Provider.of<LoyaltyCardViewModel>(
      context,
      listen: false,
    ).removeById(widget.card.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final title =
        widget.isNewCard
            ? localizations?.loyaltyCardManagerTitleNew
            : localizations?.loyaltyCardManagerTitleEdit;
    final confirmLabel =
        widget.isNewCard
            ? localizations?.addBtnLabel
            : localizations?.saveBtnLabel;

    final actions =
        widget.isNewCard
            ? [
              ElevatedButton(
                onPressed: _onSave,
                child: Text(confirmLabel ?? ''),
              ),
            ]
            : [
              TextButton(
                onPressed: _onDelete,
                child: Text(localizations?.deleteBtnLabel ?? ''),
              ),
              ElevatedButton(
                onPressed: _onSave,
                child: Text(confirmLabel ?? ''),
              ),
            ];

    return Scaffold(
      appBar: AppBar(title: Text(title ?? '')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 20,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Icon(
                  Icons.card_membership,
                  size: 100,
                  color: currentColor,
                ),
              ),
              LoyaltyCardNameInput(nameController: _nameController),
              LoyaltyCardBarcodeInput(barcodeController: _barcodeController),
              LoyaltyCardColorPicker(
                color: currentColor,
                onColorSelected:
                    (color) => setState(() => currentColor = color),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: actions,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
