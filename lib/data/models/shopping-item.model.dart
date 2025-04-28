import 'base.model.dart';

class ShoppingItem extends BaseModel {
  String id;
  String name;
  @override
  DateTime updatedAt = DateTime.now();

  ShoppingItem({required this.id, required this.name, DateTime? updatedAt})
    : super() {
    this.updatedAt = updatedAt ?? DateTime.now();
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'updated_at': updatedAt.millisecondsSinceEpoch,
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
    );
  }

  @override
  BaseModel copyWith({DateTime? updatedAt}) {
    return ShoppingItem(
      id: id,
      name: name,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
