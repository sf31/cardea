import 'dart:ui';

import 'package:mobile_scanner/mobile_scanner.dart';

import 'base.model.dart';

class LoyaltyCard extends BaseModel {
  @override
  String id;
  String name;
  String barcode;
  BarcodeFormat barcodeFormat;
  Color color;
  int usageCount;
  @override
  DateTime updatedAt;

  LoyaltyCard({
    required this.id,
    required this.name,
    required this.barcode,
    this.barcodeFormat = BarcodeFormat.code128,
    required this.color,
    required this.usageCount,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'barcode_format': barcodeFormat.rawValue,
      'color': color.toARGB32(),
      'usage_count': usageCount,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory LoyaltyCard.fromMap(Map<String, dynamic> map) {
    final barcodeFormat = _barcodeFormatFromMap(map['barcode_format']);
    return LoyaltyCard(
      id: map['id'],
      name: map['name'],
      barcode: map['barcode'],
      barcodeFormat: barcodeFormat,
      color: Color(map['color']),
      usageCount: map['usage_count'] ?? 0,
      updatedAt:
          map['updated_at'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'])
              : DateTime.now(),
    );
  }

  @override
  BaseModel copyWith({DateTime? updatedAt}) {
    return LoyaltyCard(
      id: id,
      name: name,
      barcode: barcode,
      barcodeFormat: barcodeFormat,
      color: color,
      usageCount: usageCount,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static BarcodeFormat _barcodeFormatFromMap(Object? value) {
    if (value is int) {
      try {
        return BarcodeFormat.fromRawValue(value);
      } on ArgumentError {
        // Fall through to the legacy default for unknown persisted values.
      }
    }
    return BarcodeFormat.code128;
  }
}
