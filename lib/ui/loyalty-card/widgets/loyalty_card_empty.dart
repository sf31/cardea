import 'package:cardea/ui/loyalty-card/widgets/loyalty_card_add_btn.dart';
import 'package:flutter/material.dart';

class LoyaltyCardEmpty extends StatelessWidget {
  const LoyaltyCardEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 20,
        children: [
          Text(
            'Mmmh... nothing here yet!',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
          Text(
            'Tap the + button below to add your first Card.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
          LoyaltyCardAddBtn(),
        ],
      ),
    );
  }
}
