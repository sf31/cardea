import 'package:flutter/material.dart';

import 'card-details.dart';
import 'card.repo.dart';

class CardItem extends StatelessWidget {
  final LoyaltyCard card;

  const CardItem({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    // make a rounded box
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CardDetails(card: card)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: card.color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            card.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
