import 'package:cardea/data/models/loyalty_card.model.dart';
import 'package:cardea/l10n/app_localizations.dart';
import 'package:cardea/ui/loyalty-card/loyalty_card.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart' show BarcodeFormat;
import 'package:provider/provider.dart';
import 'package:cardea/ui/shared/feedback.dart';

import '../../barcode_format.dart';
import '../loyalty_card_item.dart';
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

  late Color currentColor = widget.card.color;
  late BarcodeFormat _barcodeFormat = widget.card.barcodeFormat;
  bool _isSaving = false;
  bool _isDeleting = false;

  bool get _isBusy => _isSaving || _isDeleting;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.card.name;
    _barcodeController.text = widget.card.barcode;
    // Keep the preview in sync with the typed name and number.
    _nameController.addListener(() => setState(() {}));
    _barcodeController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  String? _validateBarcode(String? value) {
    final l10n = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return l10n?.loyaltyCardManagerMissingBarcode ?? '';
    }
    // Only check what the user changed: an untouched scanned or saved value
    // is kept as-is, and the barcode sheet already falls back to plain text.
    if (value == widget.card.barcode &&
        _barcodeFormat == widget.card.barcodeFormat) {
      return null;
    }
    final barcode = barcodeFor(_barcodeFormat);
    if (barcode != null && !barcode.isValid(value)) {
      return l10n?.loyaltyCardManagerInvalidBarcode(
            barcodeFormatName(_barcodeFormat) ?? '',
          ) ??
          '';
    }
    return null;
  }

  Future<void> _onSave() async {
    if (_isBusy) return;
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final barcode = _barcodeController.text;
      final vm = Provider.of<LoyaltyCardViewModel>(context, listen: false);
      setState(() => _isSaving = true);

      final success = await vm.upsert(
        LoyaltyCard(
          id: widget.card.id,
          name: name,
          barcode: barcode,
          barcodeFormat: _barcodeFormat,
          color: currentColor,
          usageCount: widget.card.usageCount,
        ),
      );
      if (!mounted) return;
      if (!success) {
        setState(() => _isSaving = false);
        showPersistenceError(context);
        return;
      }
      Navigator.of(context).pop();
    }
  }

  Future<void> _onDelete() async {
    if (_isBusy) return;
    final localizations = AppLocalizations.of(context);
    final confirmed = await confirmAction(
      context,
      title: localizations?.loyaltyCardDeleteConfirmTitle ?? '',
      body: localizations?.loyaltyCardDeleteConfirmBody ?? '',
      confirmLabel: localizations?.deleteBtnLabel ?? '',
    );
    if (!mounted || !confirmed) return;

    final vm = Provider.of<LoyaltyCardViewModel>(context, listen: false);
    setState(() => _isDeleting = true);
    final success = await vm.removeById(widget.card.id);
    if (!mounted) return;
    if (!success) {
      setState(() => _isDeleting = false);
      showPersistenceError(context);
      return;
    }
    Navigator.of(context).pop();
  }

  /// The barcode type, shown inside the number field. Most people never
  /// need to change it, so it stays low-key.
  Widget _formatSuffix(AppLocalizations? localizations) {
    final label = localizations?.loyaltyCardManagerFormatLabel ?? '';
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
    return MenuAnchor(
      menuChildren: [
        for (final format in selectableBarcodeFormats)
          MenuItemButton(
            onPressed: () => setState(() => _barcodeFormat = format),
            trailingIcon:
                format == _barcodeFormat ? const Icon(Icons.check) : null,
            child: Text(barcodeFormatName(format) ?? ''),
          ),
      ],
      builder:
          (context, controller, child) => Tooltip(
            message: label,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                foregroundColor: style?.color,
                textStyle: style,
              ),
              onPressed:
                  () =>
                      controller.isOpen
                          ? controller.close()
                          : controller.open(),
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.arrow_drop_down, size: 18),
              label: Text(barcodeFormatName(_barcodeFormat) ?? label),
            ),
          ),
    );
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
    final name = _nameController.text.trim();

    return Scaffold(
      appBar: AppBar(title: Text(title ?? '')),
      body: AbsorbPointer(
        absorbing: _isBusy,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: AspectRatio(
                      aspectRatio: 1.586,
                      child: LoyaltyCardFace(
                        name:
                            name.isEmpty
                                ? localizations?.loyaltyCardManagerNameLabel ??
                                    ''
                                : name,
                        color: currentColor,
                        number: _barcodeController.text,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                LoyaltyCardNameInput(nameController: _nameController),
                const SizedBox(height: 20),
                LoyaltyCardBarcodeInput(
                  barcodeController: _barcodeController,
                  validator: _validateBarcode,
                  suffix: _formatSuffix(localizations),
                ),
                const SizedBox(height: 24),
                Text(
                  localizations?.loyaltyCardManagerColorLabel ?? '',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 12),
                LoyaltyCardColorPicker(
                  color: currentColor,
                  initialColor: widget.card.color,
                  onColorSelected:
                      (color) => setState(() => currentColor = color),
                ),
                const SizedBox(height: 32),
                Row(
                  spacing: 12,
                  children: [
                    if (!widget.isNewCard)
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                        ),
                        onPressed: _isBusy ? null : _onDelete,
                        icon: const Icon(Icons.delete_outline),
                        label: Text(localizations?.deleteBtnLabel ?? ''),
                      ),
                    const Spacer(),
                    FilledButton(
                      onPressed: _isBusy ? null : _onSave,
                      child: Text(confirmLabel ?? ''),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
