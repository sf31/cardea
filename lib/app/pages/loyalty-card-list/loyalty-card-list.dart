import 'dart:math';

import 'package:cardea/app/pages/loyalty-card-list/loyalty-card-item.dart';
import 'package:cardea/app/pages/loyalty-card-list/loyalty-card-scanner.dart';
import 'package:cardea/app/pages/loyalty-card-list/loyalty=card-add-btn.dart';
import 'package:cardea/app/state/loyaly-card.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../data/loyalty-card.entity.dart';
import '../settings/settings.dart';

class LoyaltyCardList extends StatelessWidget {
  const LoyaltyCardList({super.key});

  void _sortBy(BuildContext context) async {
    final repo = Provider.of<LoyaltyCardProvider>(context, listen: false);
    final List<String> options = ['alphabetical', 'most-used'];
    final prefs = await SharedPreferences.getInstance();
    final sortBy = prefs.getString('sortBy') ?? 'alphabetical';

    final selectedOption = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Sort by'),
          children:
              options.map((option) {
                return SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, option);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(option),
                      if (sortBy == option)
                        const Icon(Icons.check, color: Colors.green),
                    ],
                  ),
                );
              }).toList(),
        );
      },
    );

    if (selectedOption != null) {
      // repo.setSortPreference(selectedOption);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your cards'),
        actions: [
          IconButton(
            onPressed: () {
              _sortBy(context);
            },
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
      body: Consumer<LoyaltyCardProvider>(
        builder: (context, repo, child) {
          final cardList = GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 2,
            padding: const EdgeInsets.all(10),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              ...repo.cardList.map((card) => LoyaltyCardItem(card: card)),
              LoyaltyCardAddBtn(),
            ],
          );

          final emptyCardList = Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'No Card added yet',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          );

          return Scaffold(
            body: repo.cardList.isEmpty ? emptyCardList : cardList,
            floatingActionButton: FloatingActionButton.extended(
              icon: Icon(Icons.add),
              label: Text('Add Card'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LoyaltyCardScanner()),
                  // MaterialPageRoute(
                  //   builder: (context) => ManageCard(card: debugCard()),
                  // ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

LoyaltyCard debugCard() {
  return LoyaltyCard(
    id: Uuid().v4(),
    name: 'Card ${Random(100).toString()}',
    barcode: '123',
    color: Colors.red,
    usageCount: 0,
  );
}
