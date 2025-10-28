import 'package:flutter/material.dart';
import 'package:ql_moifood_app/viewmodels/order_viewmodel.dart';

class OrderStatusHelper {
  static String getStatusDisplayName(String status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Chờ xác nhận';
      case OrderStatus.confirmed:
        return 'Đã xác nhận';
      case OrderStatus.completed:
        return 'Đã hoàn thành';
      case OrderStatus.cancelled:
        return 'Đã hủy';
      default:
        return status;
    }
  }

  static Color getStatusColor(String status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange.shade600;
      case OrderStatus.confirmed:
        return Colors.blue.shade600;
      case OrderStatus.completed:
        return Colors.green.shade600;
      case OrderStatus.cancelled:
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  static IconData getStatusIcon(String status) {
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
