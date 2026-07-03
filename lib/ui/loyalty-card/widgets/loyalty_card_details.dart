import 'package:barcode_widget/barcode_widget.dart';
import 'package:cardea/data/models/loyalty_card.model.dart';
import 'package:cardea/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _copied = false);
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
        BarcodeWidget(
          barcode: Barcode.code128(),
          data: widget.card.barcode,
          padding: EdgeInsets.all(35),
          drawText: false,
        ),
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
