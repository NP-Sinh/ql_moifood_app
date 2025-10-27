class Food {
  final int foodId;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int categoryId;
  final String? categoryName;
  final bool isAvailable;
  final bool isActive;

  Food({
    required this.foodId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    this.categoryName,
    required this.isAvailable,
    required this.isActive,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    String img = json['imageUrl'] ?? '';
    if (!img.startsWith('http')) {
      img = "http://localhost:5046$img";
    }

    return Food(
      foodId: json['foodId'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: img,
      categoryId: json['categoryId'] ?? 0,
      categoryName: json['category'] != null ? json['category']['name'] : null,
      isAvailable: json['isAvailable'] ?? false,
      isActive: json['isActive'] ?? false,
    );
  }
}
