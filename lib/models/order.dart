import 'order_item.dart';
import 'payment.dart';

class Order {
  final int orderId;
  final int userId;
  final String fullName;
  final String? deliveryAddress;
  final String? note;
  final double totalAmount;
  final String? orderStatus;
  final String? paymentStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<OrderItem> orderItems;
  final List<Payment> payments;

  Order({
    required this.orderId,
    required this.userId,
    required this.fullName,
    this.deliveryAddress,
    this.note,
    required this.totalAmount,
    this.orderStatus,
    this.paymentStatus,
    this.createdAt,
    this.updatedAt,
    required this.orderItems,
    required this.payments,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'] ?? 0,
      userId: json['userId'] ?? 0,
      fullName: json['fullName'],
      deliveryAddress: json['deliveryAddress'],
      note: json['note'],
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      orderStatus: json['orderStatus'],
      paymentStatus: json['paymentStatus'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      orderItems:
          (json['orderItems'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e))
              .toList() ??
          [],
      payments:
          (json['payments'] as List<dynamic>?)
              ?.map((e) => Payment.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'userId': userId,
    'fullName': fullName,
    'deliveryAddress': deliveryAddress,
    'note': note,
    'totalAmount': totalAmount,
    'orderStatus': orderStatus,
    'paymentStatus': paymentStatus,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'orderItems': orderItems.map((e) => e.toJson()).toList(),
    'payments': payments.map((e) => e.toJson()).toList(),
  };
}
