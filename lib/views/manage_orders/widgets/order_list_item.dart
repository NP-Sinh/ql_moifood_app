import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/order.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/viewmodels/order_viewmodel.dart';
import 'package:ql_moifood_app/views/manage_orders/widgets/order_card.dart';

class OrderListItem extends StatefulWidget {
  final Order order;
  final VoidCallback? onTap;
  final VoidCallback? onConfirm;
  final VoidCallback? onCompleted;
  final VoidCallback? onCancel;

  const OrderListItem({
    super.key,
    required this.order,
    this.onTap,
    this.onConfirm,
    this.onCompleted,
    this.onCancel,
  });

  @override
  State<OrderListItem> createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final status = widget.order.orderStatus ?? OrderStatus.pending;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: OrderCard(
        order: widget.order,
        isHovered: _isHovered,
        onTap: widget.onTap,
        actionButtons: _buildActionButtons(status),
        hoverBorderColor: AppColor.orange,
      ),
    );
  }

  Widget _buildActionButtons(String status) {
    List<Widget> buttons = [];

    // Xem chi tiết
    buttons.add(
      CustomButton(
        tooltip: 'Xem chi tiết',
        icon: Icon(
          Icons.visibility_outlined,
          color: Colors.grey.shade600,
          size: 20,
        ),
        onTap: widget.onTap,
        width: 44,
        height: 44,
        iconSize: 20,
        borderRadius: 12,
        gradientColors: [Colors.grey.shade200, Colors.grey.shade100],
        showShadow: false,
      ),
    );

    switch (status) {
      case OrderStatus.pending:
        if (widget.onConfirm != null) {
          buttons.add(const SizedBox(width: 8));
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
          buttons.add(const SizedBox(width: 8));
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
        if (widget.onCompleted != null) {
          buttons.add(const SizedBox(width: 8));
          buttons.add(
            CustomButton(
              tooltip: 'Hoàn thành',
              icon: const Icon(
                Icons.task_alt_rounded,
                color: Colors.white,
                size: 20,
              ),
              onTap: widget.onCompleted,
              width: 44,
              height: 44,
              iconSize: 20,
              borderRadius: 12,
              gradientColors: [Colors.green.shade500, Colors.green.shade700],
            ),
          );
        }
        if (widget.onCancel != null) {
          buttons.add(const SizedBox(width: 8));
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
      default:
        break;
    }

    return Row(mainAxisSize: MainAxisSize.min, children: buttons);
  }
}
