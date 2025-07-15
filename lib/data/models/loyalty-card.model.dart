import 'dart:ui';

import 'package:uuid/uuid.dart';

import 'base.model.dart';

class LoyaltyCard extends BaseModel {
  @override
  String id;
  String name;
  String barcode;
  Color color;
  int usageCount;
  @override
  DateTime updatedAt;

  LoyaltyCard({
    required this.id,
    required this.name,
    required this.barcode,
    required this.color,
    required this.usageCount,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'color': color.toARGB32(),
      'usage_count': usageCount,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  Map<String, Object?> toMapCompact() {
    return {'name': name, 'barcode': barcode, 'color': color.toARGB32()};
  }

  factory LoyaltyCard.fromMap(Map<String, dynamic> map) {
    return LoyaltyCard(
      id: map['id'],
      name: map['name'],
      barcode: map['barcode'],
      color: Color(map['color']),
      usageCount: map['usage_count'] ?? 0,
      updatedAt:
          map['updated_at'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'])
              : DateTime.now(),
    );
  }

  factory LoyaltyCard.fromMapCompact(Map<String, dynamic> map) {
    if (!map.containsKey('name') || !map.containsKey('barcode')) {
      throw ArgumentError('Map must contain "name" and "barcode" keys');
    }

    return LoyaltyCard(
      id: const Uuid().v4(),
      name: map['name'],
      barcode: map['barcode'],
      color: Color(map['color'] ?? 0xFFFFFFFF),
      usageCount: 0,
      updatedAt: DateTime.now(),
    );
  }

  @override
  BaseModel copyWith({DateTime? updatedAt}) {
    return LoyaltyCard(
      id: id,
      name: name,
      barcode: barcode,
      color: color,
      usageCount: usageCount,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
