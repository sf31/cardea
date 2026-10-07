import 'package:cardea/data/models/loyalty_card.model.dart';
import 'package:cardea/l10n/app_localizations.dart';
import 'package:cardea/ui/loyalty-card/loyalty_card.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'loyalty-card-manager/loyalty_card_manager.dart';
import 'loyalty_card_details.dart';

class LoyaltyCardItem extends StatelessWidget {
  final LoyaltyCard card;

  const LoyaltyCardItem({super.key, required this.card});

  static Color foregroundColorFor(Color backgroundColor) {
    return ThemeData.estimateBrightnessForColor(backgroundColor) ==
            Brightness.dark
        ? Colors.white
        : Colors.black;
  }

  static void openEditor(BuildContext context, LoyaltyCard card) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoyaltyCardManager(card: card, isNewCard: false),
      ),
    );
  }

  Future<void> _showDetails(BuildContext context) async {
    HapticFeedback.vibrate();
    final vm = Provider.of<LoyaltyCardViewModel>(context, listen: false);
    final success = await vm.incrementUsageCount(card);
    if (!context.mounted) return;
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)?.persistenceSaveError ?? '',
          ),
        ),
      );
    }
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder:
          (sheetContext) => LoyaltyCardDetails(
            card: card,
            onEdit: () {
              Navigator.of(sheetContext).pop();
              // Edit the stored card: [card] predates the usage increment.
              final current = vm.cardList.firstWhere(
                (c) => c.id == card.id,
                orElse: () => card,
              );
              openEditor(context, current);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foreground = foregroundColorFor(card.color);
    final name = card.name.trim();
    final initial = name.isEmpty ? '' : name.characters.first.toUpperCase();
    return Material(
      color: card.color,
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showDetails(context),
        onLongPress: () => openEditor(context, card),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: foreground.withValues(alpha: 0.2),
                    foregroundColor: foreground,
                    child: Text(
                      initial,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _BarcodeGlyph(color: foreground.withValues(alpha: 0.8)),
                ],
              ),
              Text(
                card.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 19,
                  height: 1.2,
                  fontWeight: FontWeight.bold,
                  color: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Decorative barcode hint drawn as a few vertical bars.
class _BarcodeGlyph extends StatelessWidget {
  final Color color;

  const _BarcodeGlyph({required this.color});

  static const _barWidths = [2.0, 1.0, 2.0, 3.0, 1.0, 2.0, 1.0, 2.0];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 1.5,
      children: [
        for (final width in _barWidths)
          ColoredBox(color: color, child: SizedBox(width: width, height: 18)),
      ],
    );
  }
}
