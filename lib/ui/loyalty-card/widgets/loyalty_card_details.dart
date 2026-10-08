import 'package:barcode_widget/barcode_widget.dart';
import 'package:cardea/data/models/loyalty_card.model.dart';
import 'package:cardea/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../barcode_format.dart';
import 'loyalty_card_item.dart';

class LoyaltyCardDetails extends StatefulWidget {
  final LoyaltyCard card;
  final VoidCallback onEdit;

  const LoyaltyCardDetails({
    super.key,
    required this.card,
    required this.onEdit,
  });

  @override
  State<LoyaltyCardDetails> createState() => _LoyaltyCardDetailsState();
}

class _LoyaltyCardDetailsState extends State<LoyaltyCardDetails> {
  bool _copied = false;

  Future<void> _copyBarcode() async {
    await Clipboard.setData(ClipboardData(text: widget.card.barcode));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _copied = false);
  }

  Widget _barcodeFallback() {
    return Padding(
      padding: const EdgeInsets.all(35),
      child: SelectableText(
        widget.card.barcode,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final foreground = LoyaltyCardItem.foregroundColorFor(widget.card.color);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header in the card's own colour, so the sheet reads as that card.
          Container(
            color: widget.card.color,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            child: Column(
              spacing: 18,
              children: [
                Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: foreground.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          widget.card.name,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(color: foreground),
                        ),
                      ),
                    ),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: foreground.withValues(alpha: 0.2),
                        foregroundColor: foreground,
                      ),
                      onPressed: widget.onEdit,
                      icon: const Icon(Icons.edit),
                      label: Text(l10n?.editBtnLabel ?? ''),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Always black on white so scanners can read it in dark mode too.
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      if (barcodeFor(widget.card.barcodeFormat)
                          case final barcode?)
                        BarcodeWidget(
                          barcode: barcode,
                          data: widget.card.barcode,
                          padding: const EdgeInsets.all(35),
                          drawText: false,
                          errorBuilder: (context, error) => _barcodeFallback(),
                        )
                      else
                        _barcodeFallback(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          widget.card.barcode,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: _copyBarcode,
                  icon: Icon(_copied ? Icons.check : Icons.copy),
                  label: Text(
                    _copied
                        ? l10n?.copiedToClipboardLabel ?? ''
                        : l10n?.copyToClipboardBtnLabel ?? '',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
