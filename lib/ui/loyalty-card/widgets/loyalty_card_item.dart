import 'package:cardea/data/models/loyalty_card.model.dart';
import 'package:cardea/ui/loyalty-card/loyalty_card.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'loaylty_card_manager.dart';
import 'loyalty_card_details.dart';

class LoyaltyCardItem extends StatelessWidget {
  final LoyaltyCard card;

  const LoyaltyCardItem({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.vibrate();
        Provider.of<LoyaltyCardViewModel>(
          context,
          listen: false,
        ).incrementUsageCount(card);
        showModalBottomSheet(
          showDragHandle: true,
          context: context,
          backgroundColor: Colors.white,
          builder: (BuildContext context) {
            return LoyaltyCardDetails(card: card);
          },
        );
      },
      onLongPress: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LoyaltyCardManager(card: card),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: card.color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              card.name,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
