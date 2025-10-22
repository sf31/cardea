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

class LoyaltyCardHome extends StatelessWidget {
  final FocusNode findFocusNode = FocusNode();
  final ValueNotifier<bool> atTop = ValueNotifier(false);

  LoyaltyCardHome({super.key});

  void _sortBy(BuildContext context) async {
    final vm = Provider.of<LoyaltyCardViewModel>(context, listen: false);
    final selectedOption = await showDialog<SortOption>(
      context: context,
      builder:
          (BuildContext context) => LoyaltyCardSort(currentSortBy: vm.sortBy),
    );

    // final selectedOption = await showDialog<String>(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return SimpleDialog(
    //       title: Text(AppLocalizations.of(context)?.loyaltyCardSortBy ?? ''),
    //       children:
    //           options.map((option) {
    //             return SimpleDialogOption(
    //               onPressed: () {
    //                 Navigator.pop(context, option);
    //               },
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Text(option),
    //                   if (sortBy == option)
    //                     const Icon(Icons.check, color: Colors.green),
    //                 ],
    //               ),
    //             );
    //           }).toList(),
    //     );
    //   },
    // );

    if (selectedOption != null) {
      vm.setSortBy(selectedOption);
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
            onPressed: () => _sortBy(context),
            icon: Icon(Icons.filter_list),
          ),
          IconButton(
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
          if (vm.cardList.isEmpty) return LoyaltyCardEmpty();

          var noResultsWidget = Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              l10n?.loyaltyCardEmptySearchResult(vm.filterString ?? '') ?? '',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );

          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification) {
                atTop.value =
                    notification.metrics.pixels <=
                    notification.metrics.minScrollExtent;
              } else if (notification is ScrollUpdateNotification) {
                atTop.value = false;
              }

              if (notification is OverscrollNotification && atTop.value) {
                findFocusNode.requestFocus();
              }
              return false;
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  LoyaltyCardFind(findFocusNode: findFocusNode),
                  vm.filteredCardList != null && vm.filteredCardList!.isEmpty
                      ? noResultsWidget
                      : LoyaltyCardGrid(
                        cardList: vm.filteredCardList ?? vm.cardList,
                      ),
                  LoyaltyCardAddBtn(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
