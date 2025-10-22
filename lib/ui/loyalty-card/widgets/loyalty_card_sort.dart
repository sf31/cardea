import 'package:cardea/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

enum SortOption { alphabetical, mostUsed }

class LoyaltyCardSort extends StatelessWidget {
  final SortOption currentSortBy;

  const LoyaltyCardSort({super.key, required this.currentSortBy});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SimpleDialog(
      title: Text(l10n?.loyaltyCardSortBy ?? ''),
      children: [
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, SortOption.alphabetical);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n?.loyaltyCardSortByName ?? ''),
              if (currentSortBy == SortOption.alphabetical)
                const Icon(Icons.check, color: Colors.green),
            ],
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, SortOption.mostUsed);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n?.loyaltyCardSortByUsage ?? ''),
              if (currentSortBy == SortOption.mostUsed)
                const Icon(Icons.check, color: Colors.green),
            ],
          ),
        ),
      ],
    );
  }
}
