import 'package:uuid/uuid.dart';

import 'base.model.dart';

class ShoppingItem extends BaseModel {
  @override
  String id;
  String name;
  @override
  DateTime updatedAt = DateTime.now();
  DateTime? completedAt;

  ShoppingItem({
    required this.id,
    required this.name,
    DateTime? updatedAt,
    this.completedAt,
  }) : super() {
    this.updatedAt = updatedAt ?? DateTime.now();
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'completed_at': completedAt?.millisecondsSinceEpoch,
    };
  }

  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map['id'],
      name: map['name'],
      updatedAt:
          map['updated_at'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'])
              : DateTime.now(),
      completedAt:
          map['completed_at'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['completed_at'])
              : null,
    );
  }

  factory ShoppingItem.fromName(String name) {
    return ShoppingItem(
      id: Uuid().v4(),
      name: name,
      updatedAt: DateTime.now(),
      completedAt: null,
    );
  }

  @override
  ShoppingItem copyWith({DateTime? updatedAt, String? name}) {
    return ShoppingItem(
      id: id,
      name: name ?? this.name,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt,
    );
  }
}
