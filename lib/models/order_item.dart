class OrderItem {
  final int orderItemId;
  final int? orderId;
  final int? foodId;
  final String? foodName;
  final String foodImageUrl;
  final int quantity;
  final double price;
  final String? note;

  OrderItem({
    required this.orderItemId,
    this.orderId,
    this.foodId,
    this.foodName,
    required this.foodImageUrl,
    required this.quantity,
    required this.price,
    this.note,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    String img = json['foodImageUrl'] ?? '';
    if (!img.startsWith('http')) {
      img = "http://localhost:5046$img";
    }
    return OrderItem(
      orderItemId: json['orderItemId'] ?? 0,
      orderId: json['orderId'],
      foodId: json['foodId'],
      foodName: json['foodName'],
      foodImageUrl: img,
      quantity: json['quantity'],
      price: (json['price'] ?? 0).toDouble(),
      note: json['note'],
    );
  }
  Map<String, dynamic> toJson() => {
    'orderItemId': orderItemId,
    'orderId': orderId,
    'foodId': foodId,
    'foodName': foodName,
    'foodImageUrl': foodImageUrl,
    'quantity': quantity,
    'price': price,
    'note': note,
  };
}
