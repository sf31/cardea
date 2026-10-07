import 'package:cardea/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

enum SortOption { alphabetical, mostUsed }

class LoyaltyCardSort extends StatelessWidget {
  final SortOption currentSortBy;
  final ValueChanged<SortOption> onSelected;

  const LoyaltyCardSort({
    super.key,
    required this.currentSortBy,
    required this.onSelected,
  });

  static String labelFor(SortOption option, AppLocalizations? l10n) {
    switch (option) {
      case SortOption.alphabetical:
        return l10n?.loyaltyCardSortByName ?? '';
      case SortOption.mostUsed:
        return l10n?.loyaltyCardSortByUsage ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MenuAnchor(
      menuChildren: [
        for (final option in SortOption.values)
          MenuItemButton(
            onPressed: () => onSelected(option),
            trailingIcon:
                option == currentSortBy ? const Icon(Icons.check) : null,
            child: Text(labelFor(option, l10n)),
          ),
      ],
      builder:
          (context, controller, child) => ActionChip(
            tooltip: l10n?.loyaltyCardSortBy,
            avatar: const Icon(Icons.sort),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(labelFor(currentSortBy, l10n)),
                const Icon(Icons.arrow_drop_down, size: 18),
              ],
            ),
            onPressed:
                () =>
                    controller.isOpen ? controller.close() : controller.open(),
          ),
    );
  }
}
