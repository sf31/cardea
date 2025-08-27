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
      childAspectRatio: 2,
      padding: const EdgeInsets.all(10),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [...cardList.map((card) => LoyaltyCardItem(card: card))],
    );
  }
}
