import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/order.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/utils/formatter.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/viewmodels/order_viewmodel.dart';
import 'package:ql_moifood_app/views/manage_orders/widgets/order_status_helper.dart';

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
    final statusColor = OrderStatusHelper.getStatusColor(status);
    final statusName = OrderStatusHelper.getStatusDisplayName(status);
    final isCancelled = status == OrderStatus.cancelled;

    final List<Color> bgGradient = isCancelled
        ? [Colors.grey.shade200, Colors.grey.shade100]
        : [Colors.white, Colors.grey.shade50];

    final Color hoverColor = AppColor.orange;

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
                OrderStatusHelper.getStatusIcon(status),
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
                  // Order ID và Status
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Đơn hàng #${widget.order.orderId}',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: isCancelled
                                ? Colors.black54
                                : Colors.black87,
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
                  ),
                  const SizedBox(height: 10),

                  // Customer Info
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.person_outline,
                          size: 16,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ID: #${widget.order.userId}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                decoration: isCancelled
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.order.fullName,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isCancelled
                                    ? Colors.black54
                                    : Colors.black87,
                                decoration: isCancelled
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Amount và Time
                  Row(
                    children: [
                      // Amount
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isCancelled
                              ? Colors.grey.shade100
                              : AppColor.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.payments_outlined,
                              size: 14,
                              color: isCancelled
                                  ? Colors.grey.shade600
                                  : AppColor.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              formatVND(widget.order.totalAmount),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isCancelled
                                    ? Colors.grey.shade600
                                    : AppColor.primary,
                                decoration: isCancelled
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Time
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          formatDateTime2(
                            widget.order.createdAt ?? DateTime.now(),
                          ),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            decoration: isCancelled
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
        icon: Icon(
          Icons.visibility_outlined,
          color: Colors.grey.shade600,
          size: 20,
        ),
        onTap: widget.onViewDetails,
        width: 44,
        height: 44,
        iconSize: 20,
        borderRadius: 12,
        gradientColors: [Colors.grey.shade200, Colors.grey.shade100],
        showShadow: false,
      ),
    );

    // Nút tùy theo trạng thái
    switch (status) {
      case OrderStatus.pending:
        if (widget.onConfirm != null) {
          buttons.add(
            CustomButton(
              tooltip: 'Xác nhận đơn',
              icon: const Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.white,
                size: 20,
              ),
              onTap: widget.onConfirm,
              width: 44,
              height: 44,
              iconSize: 20,
              borderRadius: 12,
              gradientColors: [Colors.blue.shade500, Colors.blue.shade700],
            ),
          );
        }
        if (widget.onCancel != null) {
          if (buttons.isNotEmpty) buttons.add(const SizedBox(width: 8));
          buttons.add(
            CustomButton(
              tooltip: 'Hủy đơn',
              icon: const Icon(
                Icons.cancel_outlined,
                color: Colors.white,
                size: 20,
              ),
              onTap: widget.onCancel,
              width: 44,
              height: 44,
              iconSize: 20,
              borderRadius: 12,
              gradientColors: [Colors.red.shade500, Colors.red.shade700],
            ),
          );
        }
        break;
      case OrderStatus.confirmed:
        if (widget.onDeliver != null) {
          if (buttons.isNotEmpty) buttons.add(const SizedBox(width: 8));
          buttons.add(
            CustomButton(
              tooltip: 'Hoàn thành',
              icon: const Icon(
                Icons.task_alt_rounded,
                color: Colors.white,
                size: 20,
              ),
              onTap: widget.onDeliver,
              width: 44,
              height: 44,
              iconSize: 20,
              borderRadius: 12,
              gradientColors: [Colors.green.shade500, Colors.green.shade700],
            ),
          );
        }
        if (widget.onCancel != null) {
          if (buttons.isNotEmpty) buttons.add(const SizedBox(width: 8));
          buttons.add(
            CustomButton(
              tooltip: 'Hủy đơn',
              icon: const Icon(
                Icons.cancel_outlined,
                color: Colors.white,
                size: 20,
              ),
              onTap: widget.onCancel,
              width: 44,
              height: 44,
              iconSize: 20,
              borderRadius: 12,
              gradientColors: [Colors.red.shade500, Colors.red.shade700],
            ),
          );
        }
        break;
      case OrderStatus.completed:
      case OrderStatus.cancelled:
        break;
    }

    return Row(mainAxisSize: MainAxisSize.min, children: buttons);
  }
}
