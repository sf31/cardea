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
        Text(card.name, style: TextStyle(fontSize: 30, color: Colors.black)),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: BarcodeWidget(
              barcode: Barcode.code128(),
              data: card.barcode,
            ),
          ),
        ),
      ],
    );
  }
}
