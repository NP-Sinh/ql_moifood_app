import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/order.dart';
import 'package:ql_moifood_app/viewmodels/order_viewmodel.dart';
import 'package:ql_moifood_app/views/manage_orders/modal/widgets/order_action_buttons.dart';
import 'package:ql_moifood_app/views/manage_orders/widgets/order_status_helper.dart';

class OrderStatusCard extends StatelessWidget {
  final Order order;
  final Function(String newStatus)? onStatusChange;

  const OrderStatusCard({
    super.key,
    required this.order,
    this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    final status = order.orderStatus ?? 'N/A';
    final statusColor = OrderStatusHelper.getStatusColor(status);
    final statusIcon = OrderStatusHelper.getStatusIcon(status);
    final statusName = OrderStatusHelper.getStatusDisplayName(status);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor.withValues(alpha: 0.1),
            statusColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trạng thái đơn hàng',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        statusName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Action Buttons
          if (onStatusChange != null && _canChangeStatus(status))
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: OrderActionButtons(
                status: status,
                onStatusChange: onStatusChange,
              ),
            ),
        ],
      ),
    );
  }

  bool _canChangeStatus(String status) {
    return status != OrderStatus.completed && status != OrderStatus.cancelled;
  }
}