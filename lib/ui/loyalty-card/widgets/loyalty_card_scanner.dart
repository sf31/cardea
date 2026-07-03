import 'package:cardea/data/models/loyalty_card.model.dart';
import 'package:cardea/l10n/app_localizations.dart';
import 'package:cardea/ui/loyalty-card/widgets/loyalty-card-manager/loyalty_card_manager.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uuid/uuid.dart';

class LoyaltyCardScanner extends StatefulWidget {
  const LoyaltyCardScanner({super.key});

  @override
  State<LoyaltyCardScanner> createState() => _LoyaltyCardScannerState();
}

class _LoyaltyCardScannerState extends State<LoyaltyCardScanner> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isNavigating = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (_isNavigating) return;
    Barcode? barcode = barcodes.barcodes.firstOrNull;
    String? value = barcode?.displayValue;

    if (value == null) return;

    _openCardManager(barcode: value);
  }

  void _manualAdd() {
    _openCardManager(barcode: '');
  }

  void _openCardManager({required String barcode}) {
    if (_isNavigating) return;
    _isNavigating = true;

    final card = LoyaltyCard(
      id: const Uuid().v4(),
      name: '',
      barcode: barcode,
      color: Colors.blue,
      usageCount: 0,
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoyaltyCardManager(card: card, isNewCard: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.loyaltyCardManagerTitleNew ?? '',
        ),
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (BarcodeCapture barcodes) {
              _handleBarcode(barcodes);
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
                        Text(
                          AppLocalizations.of(
                                context,
                              )?.loyaltyCardManagerScanLabel ??
                              '',
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        FilledButton(
                          onPressed: _manualAdd,
                          child: Text(
                            AppLocalizations.of(
                                  context,
                                )?.loyaltyCardManagerScanManually ??
                                '',
                          ),
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
