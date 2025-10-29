import 'package:flutter/material.dart';

class OrderStatusHelper {
  static String getStatusDisplayName(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending': 
        return 'Chờ xác nhận';
      case 'confirmed': 
        return 'Đã xác nhận';
      case 'completed': 
        return 'Đã hoàn thành';
      case 'cancelled': 
        return 'Đã hủy';
      default:
        return status ?? "N/A";
    }
  }

  static Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending': 
        return Colors.orange.shade600;
      case 'confirmed': 
        return Colors.blue.shade600;
      case 'completed': 
        return Colors.green.shade600;
      case 'cancelled': 
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  static IconData getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending': 
        return Icons.pending_actions_rounded;
      case 'confirmed': 
        return Icons.hourglass_top_rounded;
      case 'completed': 
        return Icons.check_circle_outline_rounded;
      case 'cancelled': 
        return Icons.cancel_outlined;
      default:
        return Icons.list_alt_rounded;
    }
  }
}