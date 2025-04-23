import 'package:flutter/material.dart';

class AddCardDetails extends StatefulWidget {
  final String barcodeValue;

  const AddCardDetails({super.key, required this.barcodeValue});

  @override
  State<AddCardDetails> createState() => _AddCardDetailsState();
}

class _AddCardDetailsState extends State<AddCardDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Card')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text('Scan a barcode: ${widget.barcodeValue}')],
        ),
      ),
    );
  }
}
