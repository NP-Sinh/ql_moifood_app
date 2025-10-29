import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/order.dart';
import 'package:ql_moifood_app/views/manage_orders/widgets/order_status_helper.dart';

class OrderCardHeader extends StatelessWidget {
  final Order order;
  final String status;
  final Color statusColor;
  final bool isCancelled;

  const OrderCardHeader({
    super.key,
    required this.order,
    required this.status,
    required this.statusColor,
    required this.isCancelled,
  });

  @override
  Widget build(BuildContext context) {
    final statusName = OrderStatusHelper.getStatusDisplayName(status);

    return Row(
      children: [
        Expanded(
          child: Text(
            'Đơn hàng #${order.orderId}',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: isCancelled ? Colors.black54 : Colors.black87,
              decoration: isCancelled
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: statusColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                OrderStatusHelper.getStatusIcon(status),
                color: statusColor,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                statusName,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}