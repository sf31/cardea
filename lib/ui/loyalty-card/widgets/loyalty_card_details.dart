import 'package:barcode_widget/barcode_widget.dart';
import 'package:cardea/data/models/loyalty_card.model.dart';
import 'package:cardea/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart' show BarcodeFormat;

class LoyaltyCardDetails extends StatefulWidget {
  final LoyaltyCard card;

  const LoyaltyCardDetails({super.key, required this.card});

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

  Barcode? _barcodeForFormat() {
    switch (widget.card.barcodeFormat) {
      case BarcodeFormat.code128:
        return Barcode.code128();
      case BarcodeFormat.code39:
        return Barcode.code39();
      case BarcodeFormat.code93:
        return Barcode.code93();
      case BarcodeFormat.codabar:
        return Barcode.codabar();
      case BarcodeFormat.dataMatrix:
        return Barcode.dataMatrix();
      case BarcodeFormat.ean13:
        return Barcode.ean13();
      case BarcodeFormat.ean8:
        return Barcode.ean8();
      case BarcodeFormat.itf:
        return Barcode.itf();
      case BarcodeFormat.qrCode:
        return Barcode.qrCode();
      case BarcodeFormat.upcA:
        return Barcode.upcA();
      case BarcodeFormat.upcE:
        return Barcode.upcE();
      case BarcodeFormat.pdf417:
        return Barcode.pdf417();
      case BarcodeFormat.aztec:
        return Barcode.aztec();
      case BarcodeFormat.unknown:
      case BarcodeFormat.all:
        return null;
    }
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
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            widget.card.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 30, color: Colors.black),
          ),
        ),
        if (_barcodeForFormat() case final barcode?)
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
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 20,
            children: [
              Text(
                widget.card.barcode,
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              _copied
                  ? TextButton(
                    onPressed: () {},
                    child: Text(l10n?.copiedToClipboardLabel ?? ''),
                  )
                  : TextButton(
                    onPressed: _copyBarcode,
                    child: Text(l10n?.copyToClipboardBtnLabel ?? ''),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
