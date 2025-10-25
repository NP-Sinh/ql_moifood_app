class Food {
  final int foodId;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String? categoryName;
  final bool isAvailable;
  final bool isActive;

  Food({
    required this.foodId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.categoryName,
    required this.isAvailable,
    required this.isActive,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    String img = json['imageUrl'] ?? '';
    if (!img.startsWith('http')) {
      img = "http://10.0.2.2:5046$img";
    }

    return Food(
      foodId: json['foodId'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: img,
      categoryName: json['category'] != null ? json['category']['name'] : null,
      isAvailable: json['isAvailable'] ?? false,
      isActive: json['isActive'] ?? false,
    );
  }
}