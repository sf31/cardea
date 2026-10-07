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
    return LoyaltyCardFace(
      name: card.name,
      color: card.color,
      onTap: () => _showDetails(context),
      onLongPress: () => openEditor(context, card),
    );
  }
}

/// The card-shaped tile used in the wallet grid and the editor preview.
class LoyaltyCardFace extends StatelessWidget {
  final String name;
  final Color color;

  /// Card number shown under the name; the wallet grid leaves it out.
  final String? number;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const LoyaltyCardFace({
    super.key,
    required this.name,
    required this.color,
    this.number,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = LoyaltyCardItem.foregroundColorFor(color);
    final trimmed = name.trim();
    final initial =
        trimmed.isEmpty ? '' : trimmed.characters.first.toUpperCase();
    return Material(
      color: color,
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 19,
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                      color: foreground,
                    ),
                  ),
                  if (number case final number? when number.isNotEmpty)
                    Text(
                      number,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        letterSpacing: 1,
                        color: foreground.withValues(alpha: 0.85),
                      ),
                    ),
                ],
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
