import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/order.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/utils/formatter.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/viewmodels/order_viewmodel.dart';
import 'package:ql_moifood_app/views/manage_orders/controller/order_controller.dart';

class OrderCard extends StatefulWidget {
  final Order order;
  final bool isHovered;
  final VoidCallback? onViewDetails;
  final VoidCallback? onConfirm;
  final VoidCallback? onDeliver;
  final VoidCallback? onCancel;

  const OrderCard({
    super.key,
    required this.order,
    this.isHovered = false,
    this.onViewDetails,
    this.onConfirm,
    this.onDeliver,
    this.onCancel,
  });
  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    final status = widget.order.orderStatus ?? OrderStatus.pending;
    final controller = OrderController(context);
    final statusColor = controller.getStatusColor(status);
    final statusName = controller.getStatusDisplayName(status);
    final isCancelled = status == OrderStatus.cancelled;

    final List<Color> bgGradient = isCancelled
        ? [Colors.grey.shade200, Colors.grey.shade100]
        : [Colors.white, Colors.grey.shade50];

    final Color hoverColor = statusColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: bgGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isHovered
              ? hoverColor.withValues(alpha: 0.3)
              : (isCancelled ? Colors.grey.shade300 : Colors.grey.shade200),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.isHovered
                ? hoverColor.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: widget.isHovered ? 20 : 10,
            offset: Offset(0, widget.isHovered ? 8 : 4),
            spreadRadius: widget.isHovered ? 2 : 0,
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
                    'Đơn hàng #${widget.order.orderId}',
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
                    formatVND(widget.order.totalAmount),
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
                    formatDateTime2(widget.order.createdAt ?? DateTime.now()),
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
            _buildActionButtons(status),
          ],
        ),
      ),
    );
  }
  Widget _buildActionButtons(String status) {
     List<Widget> buttons = [];
     buttons.add(
      CustomButton(
        tooltip: 'Xem chi tiết',
        icon: Icon(Icons.visibility_outlined, color: Colors.grey.shade600, size: 20),
        onTap: widget.onViewDetails,
        width: 44, height: 44, iconSize: 20, borderRadius: 12,
        gradientColors: [Colors.grey.shade200, Colors.grey.shade100],
        showShadow: false,
      )
    );
    // Nút tùy theo trạng thái
    switch (status) {
      case OrderStatus.pending:
        if (widget.onConfirm != null) { 
          if (buttons.isNotEmpty) buttons.add(const SizedBox(width: 8));
          buttons.add(CustomButton(
            tooltip: 'Xác nhận đơn',
            icon: const Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 20),
            onTap: widget.onConfirm,
            width: 44, height: 44, iconSize: 20, borderRadius: 12,
            gradientColors: [Colors.blue.shade500, Colors.blue.shade700],
          ));
        }
        if (widget.onCancel != null) { 
           if (buttons.isNotEmpty) buttons.add(const SizedBox(width: 8));
           buttons.add(CustomButton(
            tooltip: 'Hủy đơn',
            icon: const Icon(Icons.cancel_outlined, color: Colors.white, size: 20),
            onTap: widget.onCancel,
            width: 44, height: 44, iconSize: 20, borderRadius: 12,
            gradientColors: [Colors.red.shade500, Colors.red.shade700],
          ));
        }
        break;
      case OrderStatus.confirmed:
        if (widget.onDeliver != null) { 
           if (buttons.isNotEmpty) buttons.add(const SizedBox(width: 8));
           buttons.add(CustomButton(
            tooltip: 'Hoàn thành',
            icon: const Icon(Icons.task_alt_rounded, color: Colors.white, size: 20),
            onTap: widget.onDeliver,
            width: 44, height: 44, iconSize: 20, borderRadius: 12,
            gradientColors: [Colors.green.shade500, Colors.green.shade700],
          ));
        }
         if (widget.onCancel != null) {
           if (buttons.isNotEmpty) buttons.add(const SizedBox(width: 8));
           buttons.add(CustomButton(
            tooltip: 'Hủy đơn',
            icon: const Icon(Icons.cancel_outlined, color: Colors.white, size: 20),
            onTap: widget.onCancel,
            width: 44, height: 44, iconSize: 20, borderRadius: 12,
            gradientColors: [Colors.red.shade500, Colors.red.shade700],
          ));
        }
        break;
      case OrderStatus.completed:
      case OrderStatus.cancelled:
        break;
    }
    return Row(
       mainAxisSize: MainAxisSize.min,
       children: buttons,
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
