import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/order.dart';
import 'package:ql_moifood_app/resources/utils/formatter.dart';
import 'package:ql_moifood_app/views/manage_orders/modal/widgets/info_card_wrapper.dart';
import 'package:ql_moifood_app/views/manage_orders/modal/widgets/info_row.dart';

class OrderPaymentCard extends StatelessWidget {
  final Order order;

  const OrderPaymentCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final paymentInfo = order.payments.isNotEmpty
        ? '${order.payments.first.methodName} - ${order.payments.first.paymentStatus}'
        : 'Chưa có thông tin thanh toán';

    return InfoCardWrapper(
      title: 'Thông tin thanh toán',
      icon: Icons.payment_outlined,
      child: Column(
        children: [
          InfoRow(
            icon: Icons.credit_card,
            label: 'Phương thức',
            value: paymentInfo,
          ),
          const Divider(height: 16),
          InfoRow(
            icon: Icons.access_time,
            label: 'Thời gian tạo',
            value:
                '${formatDateTime(order.createdAt)} - ${formatDateTime2(order.createdAt)}',
          ),
        ],
      ),
    );
  }
}