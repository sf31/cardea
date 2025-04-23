import 'package:flutter/material.dart';

import 'card.repo.dart';

class CardDetails extends StatelessWidget {
  final LoyaltyCard card;

  const CardDetails({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(card.name)),
      body: Center(child: Text(card.barcode)),
    );
  }
}
