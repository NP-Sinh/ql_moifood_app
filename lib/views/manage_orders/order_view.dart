import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/viewmodels/order_viewmodel.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/views/manage_orders/controller/order_controller.dart';
import 'package:ql_moifood_app/views/manage_orders/widgets/order_status_helper.dart';
import 'widgets/order_list_item.dart';
import 'widgets/order_empty.dart';

class OrderView extends StatefulWidget {
  static const String routeName = '/order';
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> with TickerProviderStateMixin {
  late final OrderController _controller;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = OrderController(context);
    _tabController = TabController(
      length: OrderStatus.values.length,
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.loadOrdersByStatus(OrderStatus.values.first);
      }
    });
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final selectedStatus = OrderStatus.values[_tabController.index];
        _controller.loadOrdersByStatus(selectedStatus);
      }
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(() {});
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const PageStorageKey('order_view'),
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // Header và TabBar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(children: [_buildHeader(), _buildTabBar()]),
          ),
          // TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: OrderStatus.values
                  .map((status) => _buildOrderList(status))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Header
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Quản lý Đơn hàng',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            color: AppColor.primary,
            tooltip: 'Tải lại tất cả',
            onPressed: () => _controller.refreshAllOrders(),
          ),
        ],
      ),
    );
  }

  // TabBar "Pill" style
  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(22),
        ),
        padding: const EdgeInsets.all(4),
        child: TabBar(
          controller: _tabController,
          tabs: OrderStatus.values.map((status) {
            return Tab(text: OrderStatusHelper.getStatusDisplayName(status));
          }).toList(),
          indicator: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orangeAccent, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColor.primary.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          unselectedLabelColor: Colors.black54,
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          dividerColor: Colors.transparent,
        ),
      ),
    );
  }

  // Widget hiển thị danh sách đơn hàng cho một tab
  Widget _buildOrderList(String status) {
    return Consumer<OrderViewModel>(
      builder: (context, vm, _) {
        final orders = vm.getOrdersByStatus(status);
        if (vm.isLoading && orders.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.errorMessage != null && orders.isEmpty) {
          return OrderEmpty(
            message: 'Lỗi: ${vm.errorMessage}',
            icon: Icons.error_outline_rounded,
            onRefresh: () => _controller.loadOrdersByStatus(status),
          );
        }
        if (orders.isEmpty) {
          return OrderEmpty(
            message:
                'Không có đơn hàng nào ở trạng thái "${OrderStatusHelper.getStatusDisplayName(status)}".',
            icon: OrderStatusHelper.getStatusIcon(status),
            onRefresh: () => _controller.loadOrdersByStatus(status),
          );
        }
        return RefreshIndicator(
          onRefresh: _controller.refreshAllOrders,
          child: ListView.builder(
            key: PageStorageKey('order_list_$status'),
            itemCount: vm.getOrdersByStatus(status).length,
            itemBuilder: (context, index) {
              final order = vm.getOrdersByStatus(status)[index];
              return OrderListItem(
                key: ValueKey(order.orderId),
                order: order,
                onViewDetails: () => _controller.showOrderDetailsModal(order),
                onConfirm: status == OrderStatus.pending
                    ? () => _controller.confirmUpdateOrderStatus(
                        order,
                        OrderStatus.confirmed,
                      )
                    : null,
                onDeliver: status == OrderStatus.confirmed
                    ? () => _controller.confirmUpdateOrderStatus(
                        order,
                        OrderStatus.completed,
                      )
                    : null,
                onCancel:
                    (status == OrderStatus.pending ||
                        status == OrderStatus.confirmed)
                    ? () => _controller.confirmUpdateOrderStatus(
                        order,
                        OrderStatus.cancelled,
                      )
                    : null,
                onStatusChange: (newStatus) {
                  _controller.confirmUpdateOrderStatus(order, newStatus);
                },
              );
            },
          ),
        );
      },
    );
  }
}
