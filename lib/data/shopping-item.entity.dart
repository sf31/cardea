class ShoppingItem {
  String id;
  String name;

  ShoppingItem({required this.id, required this.name});

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name};
  }

  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(id: map['id'], name: map['name']);
  }
}
