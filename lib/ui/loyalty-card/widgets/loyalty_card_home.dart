import 'package:cardea/l10n/app_localizations.dart';
import 'package:cardea/ui/loyalty-card/loyalty_card.viewmodel.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty_card_add_btn.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty_card_empty.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty_card_find.dart';
import 'package:cardea/ui/settings/widgets/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loyalty_card_list.dart';
import 'loyalty_card_sort.dart';

class LoyaltyCardHome extends StatefulWidget {
  const LoyaltyCardHome({super.key});

  @override
  State<LoyaltyCardHome> createState() => _LoyaltyCardHomeState();
}

class _LoyaltyCardHomeState extends State<LoyaltyCardHome> {
  final FocusNode findFocusNode = FocusNode();

  @override
  void dispose() {
    findFocusNode.dispose();
    super.dispose();
  }

  Future<void> _sortBy(BuildContext context, SortOption option) async {
    final vm = Provider.of<LoyaltyCardViewModel>(context, listen: false);
    final success = await vm.setSortBy(option);
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
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.loyaltyCardSectionTitle ?? ''),
        actions: [
          IconButton(
            tooltip: l10n?.settingsSectionTitle,
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => Settings()));
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Consumer<LoyaltyCardViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  const CircularProgressIndicator(),
                  Text(l10n?.dataLoadingLabel ?? ''),
                ],
              ),
            );
          }
          if (vm.loadFailed) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16,
                  children: [
                    Text(
                      l10n?.dataLoadError ?? '',
                      textAlign: TextAlign.center,
                    ),
                    FilledButton(
                      onPressed: vm.loadCards,
                      child: Text(l10n?.retryBtnLabel ?? ''),
                    ),
                  ],
                ),
              ),
            );
          }
          if (vm.cardList.isEmpty) return const LoyaltyCardEmpty();

          var noResultsWidget = Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              l10n?.loyaltyCardEmptySearchResult(vm.filterString ?? '') ?? '',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          );

          return Column(
            children: [
              LoyaltyCardFind(findFocusNode: findFocusNode),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n?.loyaltyCardCount(vm.cardList.length) ?? '',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    LoyaltyCardSort(
                      currentSortBy: vm.sortBy,
                      onSelected: (option) => _sortBy(context, option),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      vm.filteredCardList != null &&
                              vm.filteredCardList!.isEmpty
                          ? noResultsWidget
                          : LoyaltyCardGrid(
                            cardList: vm.filteredCardList ?? vm.cardList,
                          ),
                      LoyaltyCardAddBtn(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
