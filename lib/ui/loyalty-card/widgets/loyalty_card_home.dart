import 'package:cardea/data/models/sort_option.model.dart';
import 'package:cardea/l10n/app_localizations.dart';
import 'package:cardea/ui/loyalty-card/loyalty_card.viewmodel.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty_card_add_btn.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty_card_empty.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty_card_find.dart';
import 'package:cardea/ui/settings/widgets/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cardea/ui/shared/feedback.dart';
import 'package:cardea/ui/shared/load_status.dart';

import 'loyalty_card_list.dart';
import 'loyalty_card_sort.dart';

class LoyaltyCardHome extends StatefulWidget {
  const LoyaltyCardHome({super.key});

  @override
  State<LoyaltyCardHome> createState() => _LoyaltyCardHomeState();
}

class _LoyaltyCardHomeState extends State<LoyaltyCardHome> {
  // Reopen the field when coming back to a filtered list.
  late bool _searching =
      context.read<LoyaltyCardViewModel>().filterString?.isNotEmpty ?? false;

  void _closeSearch() => setState(() => _searching = false);

  Future<void> _sortBy(BuildContext context, SortOption option) async {
    final vm = Provider.of<LoyaltyCardViewModel>(context, listen: false);
    final success = await vm.setSortBy(option);
    if (!context.mounted) return;
    if (!success) {
      showPersistenceError(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final canSearch = context.select<LoyaltyCardViewModel, bool>(
      (vm) => vm.isReady && vm.cardList.isNotEmpty,
    );
    return PopScope(
      canPop: !_searching,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        context.read<LoyaltyCardViewModel>().onFilter(null);
        _closeSearch();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n?.loyaltyCardSectionTitle ?? ''),
          actions: [
            Consumer<LoyaltyCardViewModel>(
              builder:
                  (context, vm, child) =>
                      vm.isReady
                          ? LoyaltyCardSort(
                            currentSortBy: vm.sortBy,
                            onSelected: (option) => _sortBy(context, option),
                          )
                          : const SizedBox.shrink(),
            ),
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
            if (vm.isLoading || vm.loadFailed) {
              return LoadStatus(failed: vm.loadFailed, onRetry: vm.loadCards);
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
                Expanded(
                  child: SingleChildScrollView(
                    // Room for the search button over the last row.
                    padding: EdgeInsets.only(bottom: _searching ? 0 : 72),
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
                if (_searching) ...[
                  const Divider(height: 1),
                  SafeArea(
                    top: false,
                    child: LoyaltyCardFind(onClose: _closeSearch),
                  ),
                ],
              ],
            );
          },
        ),
        floatingActionButton:
            canSearch && !_searching
                ? FloatingActionButton(
                  tooltip: l10n?.loyaltyCardSearchLabel,
                  onPressed: () => setState(() => _searching = true),
                  child: const Icon(Icons.search),
                )
                : null,
      ),
    );
  }
}
