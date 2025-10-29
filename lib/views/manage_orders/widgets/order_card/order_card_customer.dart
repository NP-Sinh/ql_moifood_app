import 'package:flutter/material.dart';
import 'package:ql_moifood_app/models/order.dart';

class OrderCardCustomer extends StatelessWidget {
  final Order order;
  final bool isCancelled;

  const OrderCardCustomer({
    super.key,
    required this.order,
    required this.isCancelled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
                'ID: #${order.userId}',
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
                order.fullName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isCancelled ? Colors.black54 : Colors.black87,
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
    );
  }
}