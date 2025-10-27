import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/order.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/utils/formatter.dart';
import 'package:ql_moifood_app/viewmodels/order_viewmodel.dart';
import 'package:ql_moifood_app/views/manage_orders/controller/order_controller.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final bool isHovered;
  final VoidCallback? onTap;
  final Widget? actionButtons;
  final Color? hoverBorderColor;

  const OrderCard({
    super.key,
    required this.order,
    this.isHovered = false,
    this.onTap,
    this.actionButtons,
    this.hoverBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    final status = order.orderStatus ?? OrderStatus.pending;
    final controller = OrderController(context);
    final statusColor = controller.getStatusColor(status);
    final statusName = controller.getStatusDisplayName(status);
    final isCancelled = status == OrderStatus.cancelled;

    final List<Color> bgGradient = isCancelled
        ? [Colors.grey.shade200, Colors.grey.shade100]
        : [Colors.white, Colors.grey.shade50];

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: bgGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHovered
                ? (hoverBorderColor ?? statusColor.withValues(alpha: 0.4))
                : (isCancelled ? Colors.grey.shade300 : Colors.grey.shade200),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isHovered
                  ? statusColor.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: isHovered ? 15 : 8,
              offset: Offset(0, isHovered ? 6 : 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon trạng thái
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [statusColor, statusColor.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  _getStatusIcon(status),
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),

              // Thông tin đơn hàng
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
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
                    const SizedBox(height: 5),
                    Text(
                      formatVND(order.totalAmount),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isCancelled
                            ? AppColor.primary.withValues(alpha: 0.5)
                            : AppColor.primary,
                        decoration: isCancelled
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      formatDateTime2(order.createdAt ?? DateTime.now()),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        decoration: isCancelled
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        statusName,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              if (actionButtons != null) actionButtons!,
            ],
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.pending_actions_rounded;
      case OrderStatus.confirmed:
        return Icons.hourglass_top_rounded;
      case OrderStatus.completed:
        return Icons.check_circle_outline_rounded;
      case OrderStatus.cancelled:
        return Icons.cancel_outlined;
      default:
        return Icons.list_alt_rounded;
    }
  }
}
