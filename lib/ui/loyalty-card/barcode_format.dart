import 'package:barcode_widget/barcode_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart' show BarcodeFormat;

/// Formats a user can pick in the card form.
const selectableBarcodeFormats = [
  BarcodeFormat.code128,
  BarcodeFormat.code39,
  BarcodeFormat.code93,
  BarcodeFormat.codabar,
  BarcodeFormat.ean13,
  BarcodeFormat.ean8,
  BarcodeFormat.upcA,
  BarcodeFormat.upcE,
  BarcodeFormat.itf,
  BarcodeFormat.qrCode,
  BarcodeFormat.dataMatrix,
  BarcodeFormat.pdf417,
  BarcodeFormat.aztec,
];

/// The renderer for [format], or `null` when it cannot be drawn.
Barcode? barcodeFor(BarcodeFormat format) {
  switch (format) {
    case BarcodeFormat.code128:
      return Barcode.code128();
    case BarcodeFormat.code39:
      return Barcode.code39();
    case BarcodeFormat.code93:
      return Barcode.code93();
    case BarcodeFormat.codabar:
      return Barcode.codabar();
    case BarcodeFormat.dataMatrix:
      return Barcode.dataMatrix();
    case BarcodeFormat.ean13:
      return Barcode.ean13();
    case BarcodeFormat.ean8:
      return Barcode.ean8();
    case BarcodeFormat.itf:
      return Barcode.itf();
    case BarcodeFormat.qrCode:
      return Barcode.qrCode();
    case BarcodeFormat.upcA:
      return Barcode.upcA();
    case BarcodeFormat.upcE:
      return Barcode.upcE();
    case BarcodeFormat.pdf417:
      return Barcode.pdf417();
    case BarcodeFormat.aztec:
      return Barcode.aztec();
    case BarcodeFormat.unknown:
    case BarcodeFormat.all:
      return null;
  }
}

/// The standard name of [format], or `null` when it has none.
String? barcodeFormatName(BarcodeFormat format) {
  switch (format) {
    case BarcodeFormat.code128:
      return 'Code 128';
    case BarcodeFormat.code39:
      return 'Code 39';
    case BarcodeFormat.code93:
      return 'Code 93';
    case BarcodeFormat.codabar:
      return 'Codabar';
    case BarcodeFormat.dataMatrix:
      return 'Data Matrix';
    case BarcodeFormat.ean13:
      return 'EAN-13';
    case BarcodeFormat.ean8:
      return 'EAN-8';
    case BarcodeFormat.itf:
      return 'ITF';
    case BarcodeFormat.qrCode:
      return 'QR code';
    case BarcodeFormat.upcA:
      return 'UPC-A';
    case BarcodeFormat.upcE:
      return 'UPC-E';
    case BarcodeFormat.pdf417:
      return 'PDF417';
    case BarcodeFormat.aztec:
      return 'Aztec';
    case BarcodeFormat.unknown:
    case BarcodeFormat.all:
      return null;
  }
}
