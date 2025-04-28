import 'dart:ui';

import 'package:cardea/data/base.entity.dart';

class LoyaltyCard extends BaseEntity {
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

  @override
  BaseEntity copyWith({DateTime? updatedAt}) {
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
