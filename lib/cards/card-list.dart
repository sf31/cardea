import 'package:cardea/cards/card.repo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'card-item.dart';
import 'card-scanner.dart';

class CardList extends StatelessWidget {
  const CardList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CardRepo>(
      builder: (context, repo, child) {
        final cardList = GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(10),
          crossAxisSpacing: 10,
          children: repo.cardList.map((card) => CardItem(card: card)).toList(),
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
                MaterialPageRoute(builder: (context) => CardScanner()),
                // MaterialPageRoute(
                //   builder: (context) => AddCardDetails(barcodeValue: 'aaaa'),
                // ),
              );
            },
          ),
        );
      },
    );
  }
}
