import 'dart:math';

import 'package:cardea/data/models/loyalty_card.model.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty_card_scanner.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class LoyaltyCardAddBtn extends StatelessWidget {
  const LoyaltyCardAddBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => LoyaltyCardScanner()));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey, width: 2),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.add, color: Colors.grey, size: 30),
                ),
                Text(
                  'New Card',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

LoyaltyCard debugCard() {
  return LoyaltyCard(
    id: Uuid().v4(),
    name: 'Card ${Random(100)}',
    barcode: '123',
    color: Colors.red,
    usageCount: 0,
  );
}
