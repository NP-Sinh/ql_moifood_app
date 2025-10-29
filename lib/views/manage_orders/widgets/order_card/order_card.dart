import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/order.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/viewmodels/order_viewmodel.dart';
import 'package:ql_moifood_app/views/manage_orders/widgets/order_card/order_card_actions.dart';
import 'package:ql_moifood_app/views/manage_orders/widgets/order_card/order_card_amount.dart';
import 'package:ql_moifood_app/views/manage_orders/widgets/order_card/order_card_customer.dart';
import 'package:ql_moifood_app/views/manage_orders/widgets/order_card/order_card_header.dart';
import 'package:ql_moifood_app/views/manage_orders/widgets/order_status_helper.dart';


class OrderCard extends StatefulWidget {
  final Order order;
  final bool isHovered;
  final VoidCallback? onViewDetails;
  final Function(String newStatus)? onStatusChange;

  const OrderCard({
    super.key,
    required this.order,
    this.isHovered = false,
    this.onViewDetails,
    this.onStatusChange,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    final status = widget.order.orderStatus ?? OrderStatus.pending;
    final statusColor = OrderStatusHelper.getStatusColor(status);
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
            _buildStatusIcon(status, statusColor),
            const SizedBox(width: 16),

            // Thông tin đơn hàng
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrderCardHeader(
                    order: widget.order,
                    status: status,
                    statusColor: statusColor,
                    isCancelled: isCancelled,
                  ),
                  const SizedBox(height: 10),
                  OrderCardCustomer(
                    order: widget.order,
                    isCancelled: isCancelled,
                  ),
                  const SizedBox(height: 10),
                  OrderCardAmount(
                    order: widget.order,
                    isCancelled: isCancelled,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),
            OrderCardActions(
              status: status,
              onViewDetails: widget.onViewDetails,
              onStatusChange: widget.onStatusChange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(String status, Color statusColor) {
    return Container(
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
    );
  }
}