import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/order.dart';
import 'order_card.dart';

class OrderListItem extends StatefulWidget {
  final Order order;
  final VoidCallback? onTap;
  final VoidCallback? onViewDetails;
  final VoidCallback? onConfirm;
  final VoidCallback? onDeliver;
  final VoidCallback? onCancel;

  const OrderListItem({
    super.key,
    required this.order,
    this.onTap,
    this.onViewDetails,
    this.onConfirm,
    this.onDeliver,
    this.onCancel,
  });

  @override
  State<OrderListItem> createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        child: OrderCard(
          order: widget.order,
          isHovered: _isHovered,
          onViewDetails: widget.onViewDetails,
          onConfirm: widget.onConfirm,
          onDeliver: widget.onDeliver,
          onCancel: widget.onCancel,
        ),
      ),
    );
  }
}
