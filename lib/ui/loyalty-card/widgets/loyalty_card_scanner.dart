import 'package:cardea/data/models/loyalty_card.model.dart';
import 'package:cardea/ui/loyalty-card/widgets/loaylty_card_manager.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uuid/uuid.dart';

class LoyaltyCardScanner extends StatelessWidget {
  final MobileScannerController _controller = MobileScannerController();

  LoyaltyCardScanner({super.key});

  void _handleBarcode(BarcodeCapture barcodes, BuildContext context) {
    Barcode? barcode = barcodes.barcodes.firstOrNull;
    String? value = barcode?.displayValue;

    if (value == null) return;

    _controller.dispose();
    LoyaltyCard card = LoyaltyCard(
      id: const Uuid().v4(),
      name: '',
      barcode: value,
      color: Colors.blue,
      usageCount: 0,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoyaltyCardManager(card: card)),
    );
  }

  void _manualAdd(BuildContext context) {
    LoyaltyCard card = LoyaltyCard(
      id: const Uuid().v4(),
      name: '',
      barcode: '',
      color: Colors.blue,
      usageCount: 0,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoyaltyCardManager(card: card)),
    );
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Scan your card',
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _manualAdd(context),
                          child: Text('Add Manually'),
                        ),
                      ],
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
