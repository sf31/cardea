import 'package:cardea/ui/loyalty-card/widgets/loyalty_card_add_btn.dart';
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class LoyaltyCardEmpty extends StatelessWidget {
  const LoyaltyCardEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            Text(
              AppLocalizations.of(context)?.loyaltyCardEmptyLabel ?? '',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              AppLocalizations.of(context)?.loyaltyCardEmptyBtn ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            LoyaltyCardAddBtn(),
          ],
        ),
      ),
    );
  }
}
