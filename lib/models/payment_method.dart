import 'payment.dart';

class PaymentMethod {
  final int methodId;
  final String name;
  final List<Payment> payments;

  PaymentMethod({
    required this.methodId,
    required this.name,
    required this.payments,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      methodId: json['methodId'] ?? 0,
      name: json['name'] ?? '',
      payments:
          (json['payments'] as List<dynamic>?)
              ?.map((e) => Payment.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'methodId': methodId,
    'name': name,
    'payments': payments.map((e) => e.toJson()).toList(),
  };
}
