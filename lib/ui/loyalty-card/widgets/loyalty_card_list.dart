import 'package:cardea/data/models/loyalty_card.model.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty_card_item.dart';
import 'package:flutter/material.dart';

class LoyaltyCardGrid extends StatelessWidget {
  final List<LoyaltyCard> cardList;

  const LoyaltyCardGrid({super.key, required this.cardList});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      // Standard payment card proportions (85.6 × 54 mm).
      childAspectRatio: 1.586,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [...cardList.map((card) => LoyaltyCardItem(card: card))],
    );
  }
}
