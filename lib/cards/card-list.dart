import 'package:cardea/cards/add-card-details.dart';
import 'package:cardea/cards/loyaltyCard.model.dart';
import 'package:flutter/material.dart';

import 'cardItem.dart';

class CardList extends StatelessWidget {
  CardList({super.key});

  final List<LoyaltyCard> cards = [
    LoyaltyCard(
      id: '1',
      name: 'Card 1',
      barcode: '1234567890',
      color: 0xffE5E5E5,
      imageUrl: 'https://via.placeholder.com/150',
    ),
    LoyaltyCard(
      id: '2',
      name: 'Card 2',
      barcode: '1234567890',
      color: 0xA93EF000,
      imageUrl: 'https://via.placeholder.com/150',
    ),
    LoyaltyCard(
      id: '3',
      name: 'Card 3',
      barcode: '1234567890',
      color: 0x626262,
      imageUrl: 'https://via.placeholder.com/150',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(10),
        crossAxisSpacing: 10,
        children: cards.map((card) => CardItem(card: card)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            // MaterialPageRoute(builder: (context) => CardScanner()),
            MaterialPageRoute(
              builder: (context) => AddCardDetails(barcodeValue: 'aaaa'),
            ),
          );
        },
      ),
    );
  }
}
