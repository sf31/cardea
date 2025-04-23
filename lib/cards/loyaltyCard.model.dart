class LoyaltyCard {
  String id;
  String name;
  String barcode;
  int color;
  String imageUrl;

  LoyaltyCard({
    required this.id,
    required this.name,
    required this.barcode,
    required this.color,
    required this.imageUrl,
  });

  factory LoyaltyCard.fromJson(Map<String, dynamic> json) {
    return LoyaltyCard(
      id: json['id'],
      name: json['name'],
      barcode: json['barcode'],
      color: json['color'],
      imageUrl: json['imageUrl'],
    );
  }
}