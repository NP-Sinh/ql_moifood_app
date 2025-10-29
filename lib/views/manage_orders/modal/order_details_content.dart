import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/order.dart';
import 'package:ql_moifood_app/views/manage_orders/modal/widgets/order_customer_card.dart';
import 'package:ql_moifood_app/views/manage_orders/modal/widgets/order_items_card.dart';
import 'package:ql_moifood_app/views/manage_orders/modal/widgets/order_payment_card.dart';
import 'package:ql_moifood_app/views/manage_orders/modal/widgets/order_status_card.dart';
import 'package:ql_moifood_app/views/manage_orders/modal/widgets/order_total_card.dart';

class OrderDetailsContent extends StatelessWidget {
  final Order order;
  final Function(String newStatus)? onStatusChange;

  const OrderDetailsContent({
    super.key,
    required this.order,
    this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrderStatusCard(order: order, onStatusChange: onStatusChange),
          const SizedBox(height: 16),
          OrderCustomerCard(order: order),
          const SizedBox(height: 16),
          OrderPaymentCard(order: order),
          const SizedBox(height: 16),
          OrderItemsCard(order: order),
          const SizedBox(height: 16),
          OrderTotalCard(totalAmount: order.totalAmount),
        ],
      ),
    );
  }
}
