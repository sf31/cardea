import 'package:cardea/cards/card.repo.dart';
import 'package:cardea/cards/manage-card.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uuid/uuid.dart';

class CardScanner extends StatelessWidget {
  final MobileScannerController _controller = MobileScannerController();

  CardScanner({super.key});

  void _handleBarcode(BarcodeCapture barcodes, BuildContext context) {
    Barcode? barcode = barcodes.barcodes.firstOrNull;
    String? value = barcode?.displayValue;

    if (value != null) {
      _controller.dispose();
      LoyaltyCard card = LoyaltyCard(
        id: const Uuid().v4(),
        name: 'New Card',
        barcode: value,
        color: Colors.blue,
        usageCount: 0,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ManageCard(card: card)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Card')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (BarcodeCapture barcodes) {
              _handleBarcode(barcodes, context);
            },
            controller: _controller,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 200,
              color: const Color.fromRGBO(0, 0, 0, 0.6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Center(
                      child: const Text(
                        'Scan your card',
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
