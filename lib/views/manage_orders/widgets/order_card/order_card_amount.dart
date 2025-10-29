import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/order.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/utils/formatter.dart';

class OrderCardAmount extends StatelessWidget {
  final Order order;
  final bool isCancelled;

  const OrderCardAmount({
    super.key,
    required this.order,
    required this.isCancelled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
                formatVND(order.totalAmount),
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
            formatDateTime2(order.createdAt ?? DateTime.now()),
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
    );
  }
}