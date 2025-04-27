import 'dart:ui';

class LoyaltyCard {
  String id;
  String name;
  String barcode;
  Color color;
  int usageCount;
  DateTime updatedAt;

  LoyaltyCard({
    required this.id,
    required this.name,
    required this.barcode,
    required this.color,
    required this.usageCount,
    required this.updatedAt,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'color': color.toARGB32(),
      'usageCount': usageCount,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory LoyaltyCard.fromMap(Map<String, dynamic> map) {
    return LoyaltyCard(
      id: map['id'],
      name: map['name'],
      barcode: map['barcode'],
      color: Color(map['color']),
      usageCount: map['usageCount'] ?? 0,
      updatedAt:
          map['updatedAt'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
              : DateTime.now(),
    );
  }
}
