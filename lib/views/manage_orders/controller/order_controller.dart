// File: lib/views/manage_order/controller/order_controller.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/models/order.dart';
import 'package:ql_moifood_app/resources/widgets/dialogs/app_utils.dart';
import 'package:ql_moifood_app/resources/widgets/dialogs/configs/snackbar_config.dart';
import 'package:ql_moifood_app/viewmodels/order_viewmodel.dart';
import 'package:ql_moifood_app/views/manage_orders/modal/order_details_content.dart';
import 'package:ql_moifood_app/views/manage_orders/widgets/order_status_helper.dart';

class OrderController {
  final BuildContext context;
  late final OrderViewModel _viewModel;

  OrderController(this.context) {
    _viewModel = context.read<OrderViewModel>();
  }

  // Tải danh sách đơn hàng theo trạng thái
  Future<void> loadOrdersByStatus(String status) async {
    await _viewModel.fetchOrdersByStatus(status);
    if (_viewModel.errorMessage != null && context.mounted) {
      AppUtils.showSnackBar(
        context,
        'Lỗi tải đơn hàng ($status): ${_viewModel.errorMessage}',
        type: SnackBarType.error,
      );
    }
  }

  // Tải lại tất cả đơn hàng
  Future<void> refreshAllOrders() async {
    await _viewModel.fetchAllOrders();
    if (_viewModel.errorMessage != null && context.mounted) {
      AppUtils.showSnackBar(
        context,
        'Lỗi tải lại đơn hàng: ${_viewModel.errorMessage}',
        type: SnackBarType.error,
      );
    }
  }

  // Hiển thị xác nhận cập nhật trạng thái
  void confirmUpdateOrderStatus(Order order, String newStatus) {
    String newStatusDisplay = OrderStatusHelper.getStatusDisplayName(newStatus);
    String currentStatusDisplay = OrderStatusHelper.getStatusDisplayName(order.orderStatus ?? '');

    AppUtils.showConfirmDialog(
      context,
      title: 'Xác nhận cập nhật',
      message:
          'Chuyển trạng thái đơn hàng #${order.orderId} từ "$currentStatusDisplay" sang "$newStatusDisplay"?',
      confirmText: 'Cập nhật',
      confirmColor: OrderStatusHelper.getStatusColor(newStatus),
    ).then((confirmed) async {
      if (confirmed == true) {
        final success = await _viewModel.updateOrderStatus(
          orderId: order.orderId,
          oldStatus: order.orderStatus ?? OrderStatus.pending,
          newStatus: newStatus,
        );
        if (context.mounted) {
          AppUtils.showSnackBar(
            context,
            success
                ? 'Đã cập nhật trạng thái đơn hàng #${order.orderId}'
                : _viewModel.errorMessage ?? 'Cập nhật thất bại',
            type: success ? SnackBarType.success : SnackBarType.error,
          );
        }
      }
    });
  }

  // Chuyển đến màn hình chi tiết
  void showOrderDetailsModal(Order order) {
    AppUtils.showBaseModal(
      context,
      title: 'Chi tiết Đơn hàng #${order.orderId}',
      child: OrderDetailsContent(order: order),
    );
  }
}
