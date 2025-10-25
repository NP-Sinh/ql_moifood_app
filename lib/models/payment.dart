class Payment {
  final int paymentId;
  final int orderId;
  final int methodId;
  final String methodName;
  final double amount;
  final String? transactionId;
  final String paymentStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Payment({
    required this.paymentId,
    required this.orderId,
    required this.methodId,
    required this.methodName,
    required this.amount,
    this.transactionId,
    required this.paymentStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentId: json['paymentId'] ?? 0,
      orderId: json['orderId'] ?? 0,
      methodId: json['methodId'] ?? 0,
      methodName: json['methodName'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      transactionId: json['transactionId'],
      paymentStatus: json['paymentStatus'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'paymentId': paymentId,
    'orderId': orderId,
    'methodId': methodId,
    'methodName': methodName,
    'amount': amount,
    'transactionId': transactionId,
    'paymentStatus': paymentStatus,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}