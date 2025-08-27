import 'package:cardea/ui/loyalty-card/widgets/loyalty_card_scanner.dart';
import 'package:flutter/material.dart';

class LoyaltyCardAddBtn extends StatelessWidget {
  const LoyaltyCardAddBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50, bottom: 20),
      child: FilledButton.icon(
        icon: Icon(Icons.add),
        onPressed:
            () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => LoyaltyCardScanner()),
            ),
        label: Text('New Card'),
      ),
    );
  }
}
