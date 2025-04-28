import 'package:cardea/data/models/loyalty-card.model.dart';
import 'package:cardea/ui/loyalty-card/loyalty-card.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loaylty-card-manager.dart';
import 'loyalty-card-details.dart';

class LoyaltyCardItem extends StatelessWidget {
  final LoyaltyCard card;

  const LoyaltyCardItem({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    // make a rounded box
    return InkWell(
      onTap: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(builder: (context) => CardDetails(card: card)),
        // );
        Provider.of<LoyaltyCardViewModel>(
          context,
          listen: false,
        ).incrementUsageCount(card);
        showModalBottomSheet(
          showDragHandle: true,
          // isScrollControlled: true,
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
              '${card.name} (${card.usageCount})',
              overflow: TextOverflow.ellipsis,
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
