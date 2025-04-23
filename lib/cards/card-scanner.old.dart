import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'add-card-details.dart';

class CardScanner extends StatefulWidget {
  const CardScanner({super.key});

  @override
  State<CardScanner> createState() => _CardScanner();
}

class _CardScanner extends State<CardScanner> {
  Barcode? _barcode;
  final MobileScannerController _controller = MobileScannerController();

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan your card',
        overflow: TextOverflow.fade,
        style: TextStyle(
          color: Colors.white,
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    var displayValue = value.displayValue;

    // if (displayValue != null ) {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(builder: (context) => AddCardDetails(barcodeValue: displayValue)),
    //   );
    // }

    return Text(
      value.displayValue ?? 'No display value',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    Barcode? barcode = barcodes.barcodes.firstOrNull;
    String? value = barcode?.displayValue;

    if (value != null) {
      _controller.stop();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddCardDetails(barcodeValue: value),
        ),
      );
    }
    // if (mounted) {
    //   setState(() {
    //     _barcode = barcodes.barcodes.firstOrNull;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    _controller.start();
    return Scaffold(
      appBar: AppBar(title: const Text('Add Card')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(onDetect: _handleBarcode, controller: _controller),
          // MobileScanner(
          //     controller: MobileScannerController(),
          //     onDetect: (BarcodeCapture barcodes) {
          //   Barcode? barcode = barcodes.barcodes.firstOrNull;
          //   String? value = barcode?.displayValue;
          //   var intValue = Random().nextInt(10000).toString();
          //   if (value != null) {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(builder: (context) => AddCardDetails(barcodeValue: intValue)),
          //     );
          //   }
          // }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 200,
              color: const Color.fromRGBO(0, 0, 0, 0.6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Center(child: _buildBarcode(_barcode))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
