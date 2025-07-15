import 'dart:math';

import 'package:cardea/data/models/loyalty-card.model.dart';
import 'package:cardea/ui/loyalty-card/loyalty-card.viewmodel.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty-card-item.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty-card-scanner.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty=card-add-btn.dart';
import 'package:cardea/ui/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class LoyaltyCardList extends StatelessWidget {
  const LoyaltyCardList({super.key});

  void _sortBy(BuildContext context) async {
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
      body: Consumer<LoyaltyCardViewModel>(
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
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 20),
                  child: ElevatedButton(
                    onPressed:
                        () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LoyaltyCardScanner(),
                          ),
                        ),
                    child: Text('Add Card now'),
                  ),
                ),
              ],
            ),
          );

          return Scaffold(
            body: repo.cardList.isEmpty ? emptyCardList : cardList,
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
