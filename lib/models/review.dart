class Review {
  final int reviewId;
  final int userId;
  final String fullName;
  final String? phone;
  final int rating;
  final String comment;
  final DateTime? createdAt;
  final int foodId;
  final String foodName;
  final String? foodImageUrl;
  final double price;

  const Review({
    required this.reviewId,
    required this.userId,
    required this.fullName,
    this.phone,
    required this.rating,
    required this.comment,
    this.createdAt,
    required this.foodId,
    required this.foodName,
    this.foodImageUrl,
    required this.price,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    final foodData = json['food'] as Map<String, dynamic>?;

    String? imageUrl = foodData?['foodImageUrl'] ?? json['foodImageUrl'];
    if (imageUrl != null &&
        imageUrl.isNotEmpty &&
        !imageUrl.startsWith('http')) {
      imageUrl = "https://localhost:7128$imageUrl";
    }

    return Review(
      reviewId: json['reviewId'] ?? 0,
      userId: json['userId'] ?? 0,
      fullName: json['fullName'] ?? '',
      phone: json['phone'],
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      foodId: foodData?['foodId'] ?? json['foodId'] ?? 0,
      foodName: foodData?['foodName'] ?? json['foodName'] ?? '',
      foodImageUrl: imageUrl,
      price: (foodData?['price'] ?? json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewId': reviewId,
      'userId': userId,
      'fullName': fullName,
      'phone': phone,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt?.toIso8601String(),
      'foodId': foodId,
      'foodName': foodName,
      'foodImageUrl': foodImageUrl,
      'price': price,
    };
  }
}
