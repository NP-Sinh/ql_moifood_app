import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/viewmodels/payment_viewmodel.dart';
import 'package:ql_moifood_app/views/payment/controller/payment_controller.dart';

import 'package:ql_moifood_app/views/payment/widgets/payment_list_item.dart';

class PaymentView extends StatefulWidget {
  static const String routeName = '/payment';
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView>
    with TickerProviderStateMixin {
  late final PaymentController _controller;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = PaymentController(context);
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() => _controller.loadAllPaymentMethods());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const PageStorageKey('paymet_view'),
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // Header và TabBar
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: _buildHeader(),
                ),
                _buildTabBar(),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [buildTab1(), buildTab2()],
            ),
          ),
        ],
      ),
    );
  }

  // Header
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Quản lý phương thức thanh toán',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Consumer<PaymentViewModel>(
          builder: (context, vm, _) => CustomButton(
            label: "Thêm mới",
            icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
            height: 48,
            fontSize: 14,
            gradientColors: AppColor.btnAdd,
            onTap: vm.isLoading ? null : _controller.showAddFoodModal,
          ),
        ),
      ],
    );
  }

  // tab bar
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
          tabs: const [
            Tab(text: 'Danh sách thanh toán'),
            Tab(text: 'Phương thức thanh toán'),
            Tab(text: 'Null'),
          ],
          indicator: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.black.withValues(alpha: 0.9),
                AppColor.orange.withValues(alpha: 0.9),
              ],
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

  // Tab 1:danh sách thanh toán
  Widget buildTab1() {
    return Consumer<PaymentViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading && viewModel.paymentMethods.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.errorMessage != null &&
            viewModel.paymentMethods.isEmpty) {
          return Center(
            child: Text(
              "Lỗi: ${viewModel.errorMessage}",
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (viewModel.paymentMethods.isEmpty) {
          return const Center(
            child: Text("Không có phương thức thanh toán nào."),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _controller.loadAllPaymentMethods(),
          child: ListView.builder(
            itemCount: viewModel.paymentMethods.length,
            itemBuilder: (context, index) {
              final method = viewModel.paymentMethods[index];
              return PaymentListItem(
                paymentMethod: method,
                onEdit: () {
                  _controller.showEditFoodModal(method);
                },
                onDelete: () {
                  _controller.confirmPaymentMethod(method);
                },
              );
            },
          ),
        );
      },
    );
  }

  // Tab 2: danh sách phương thức thanh toán
  Widget buildTab2() {
    return Consumer<PaymentViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading && viewModel.paymentMethods.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.errorMessage != null &&
            viewModel.paymentMethods.isEmpty) {
          return Center(
            child: Text(
              "Lỗi: ${viewModel.errorMessage}",
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (viewModel.paymentMethods.isEmpty) {
          return const Center(
            child: Text("Không có phương thức thanh toán nào."),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _controller.loadAllPaymentMethods(),
          child: ListView.builder(
            itemCount: viewModel.paymentMethods.length,
            itemBuilder: (context, index) {
              final method = viewModel.paymentMethods[index];
              return PaymentListItem(
                paymentMethod: method,
                onEdit: () {
                  _controller.showEditFoodModal(method);
                },
                onDelete: () {
                  _controller.confirmPaymentMethod(method);
                },
              );
            },
          ),
        );
      },
    );
  }
}
