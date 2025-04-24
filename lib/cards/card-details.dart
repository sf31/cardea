import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

import 'card.repo.dart';

class CardDetails extends StatelessWidget {
  final LoyaltyCard card;

  const CardDetails({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            card.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 30, color: Colors.black),
          ),
        ),
        BarcodeWidget(
          barcode: Barcode.code128(),
          data: card.barcode,
          padding: EdgeInsets.all(35),
          textPadding: 20,
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
      ],
    );
  }
}
