import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/viewmodels/notification_viewmodel.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/viewmodels/user_viewmodel.dart';
import 'package:ql_moifood_app/views/customer/controller/user_controller.dart';
import 'package:ql_moifood_app/views/notification/controller/notification_controller.dart';
import 'package:ql_moifood_app/views/notification/widgets/notification_empty.dart';
import 'package:ql_moifood_app/views/notification/widgets/notification_list_item.dart';
import 'package:ql_moifood_app/views/notification/widgets/notification_user_list_item.dart';
import 'package:ql_moifood_app/views/notification/widgets/user_send_list%20item.dart';

class NotificationView extends StatefulWidget {
  static const String routeName = '/notification';
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView>
    with TickerProviderStateMixin {
  late final NotificationController _controller;
  late final UserController _userController;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = NotificationController(context);
    _userController = UserController(context);
    _tabController = TabController(length: 3, vsync: this);

    // Load data
    Future.microtask(() => _controller.loadGlobalNotifications());
    Future.microtask(() => _controller.loadUserNotifications());
    Future.microtask(() => _userController.loadUsers());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const PageStorageKey('notification_view'),
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
              children: [
                _buildGlobalNotificationsList(),
                _buildUserNotificationsList(),
                _buildUsersList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // HEADER
  Widget _buildHeader() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text(
        'Quản lý Thông báo',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      Row(
        children: [
          Consumer<NotificationViewModel>(
            builder: (context, vm, _) => CustomButton(
              label: "Gửi toàn hệ thống",
              icon: const Icon(
                Icons.campaign_rounded,
                color: Colors.white,
                size: 20,
              ),
              height: 48,
              fontSize: 14,
              gradientColors: AppColor.btnAdd,
              onTap: vm.isSending
                  ? null
                  : _controller.showSendGlobalNotificationModal,
            ),
          ),
        ],
      ),
    ],
  );

  // Build tab
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
            Tab(text: 'Thông báo chung'),
            Tab(text: 'Thông báo riêng'),
            Tab(text: 'Danh sách khách hàng'),
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

  // TAB 1: GLOBAL NOTIFICATIONS LIST
  Widget _buildGlobalNotificationsList() {
    return Consumer<NotificationViewModel>(
      builder: (context, vm, _) {
        // Loading state
        if (vm.isLoadingGlobal && vm.globalNotifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error state
        if (vm.errorMessage != null && vm.globalNotifications.isEmpty) {
          return NotificationEmpty(
            message: 'Lỗi: ${vm.errorMessage}',
            icon: Icons.error_outline_rounded,
            onRefresh: _controller.loadGlobalNotifications,
          );
        }

        // Empty state
        if (vm.globalNotifications.isEmpty) {
          return NotificationEmpty(
            message: 'Chưa có thông báo chung nào.',
            icon: Icons.notifications_none_rounded,
            onRefresh: _controller.loadGlobalNotifications,
          );
        }

        // List view
        return RefreshIndicator(
          onRefresh: _controller.loadGlobalNotifications,
          child: ListView.builder(
            itemCount: vm.globalNotifications.length,
            itemBuilder: (context, index) {
              final globalNotification = vm.globalNotifications[index];
              return NotificationListItem(
                key: ValueKey(globalNotification.globalNotificationId),
                globalNotification: globalNotification,
                onView: () =>
                    _controller.showViewNotificationModal(globalNotification),
              );
            },
          ),
        );
      },
    );
  }

  // TAB 2: USER NOTIFICATIONS LIST
  Widget _buildUserNotificationsList() {
    return Consumer<NotificationViewModel>(
      builder: (context, vm, _) {
        // Loading state
        if (vm.isLoadingUser && vm.userNotifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error state
        if (vm.errorMessage != null && vm.userNotifications.isEmpty) {
          return NotificationEmpty(
            message: 'Lỗi: ${vm.errorMessage}',
            icon: Icons.error_outline_rounded,
            onRefresh: () {
              _controller.loadUserNotifications();
            },
          );
        }

        // Empty state
        if (vm.userNotifications.isEmpty) {
          return NotificationEmpty(
            message: 'Chưa có thông báo riêng nào.',
            icon: Icons.notifications_none_rounded,
            onRefresh: () {
              _controller.loadUserNotifications();
            },
          );
        }

        // List view
        return RefreshIndicator(
          onRefresh: () async {
            _controller.loadUserNotifications();
          },
          child: ListView.builder(
            itemCount: vm.userNotifications.length,
            itemBuilder: (context, index) {
              final userNotification = vm.userNotifications[index];
              return NotificationUserListItem(
                key: ValueKey(userNotification.notificationId),
                notification: userNotification,
                onView: () =>
                    _controller.showViewUserNotificationModal(userNotification),
                onDelete: () =>
                    _controller.confirmDeleteUserNotification(userNotification),
              );
            },
          ),
        );
      },
    );
  }

  // TAB 3: USERS LIST
  Widget _buildUsersList() {
    return Consumer<UserViewModel>(
      builder: (context, vm, _) {
        // Loading state
        if (vm.isLoading && vm.activeUsers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error state
        if (vm.errorMessage != null && vm.activeUsers.isEmpty) {
          return NotificationEmpty(
            message: 'Lỗi: ${vm.errorMessage}',
            icon: Icons.error_outline_rounded,
            onRefresh: _userController.loadUsers,
          );
        }

        // Empty state
        if (vm.activeUsers.isEmpty) {
          return NotificationEmpty(
            message: 'Chưa có danh sách khách hàng',
            icon: Icons.person_off_outlined,
            onRefresh: _userController.loadUsers,
          );
        }

        // List view
        return RefreshIndicator(
          onRefresh: _userController.loadUsers,
          child: ListView.builder(
            itemCount: vm.activeUsers.length,
            itemBuilder: (context, index) {
              final user = vm.activeUsers[index];
              return UserSendListItem(user: user, controller: _controller);
            },
          ),
        );
      },
    );
  }
}
