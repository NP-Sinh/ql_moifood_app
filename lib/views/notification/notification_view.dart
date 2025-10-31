import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/models/user.dart';
import 'package:ql_moifood_app/viewmodels/notification_viewmodel.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/viewmodels/user_viewmodel.dart';
import 'package:ql_moifood_app/views/customer/controller/user_controller.dart';
import 'package:ql_moifood_app/views/notification/controller/notification_controller.dart';
import 'package:ql_moifood_app/views/notification/widgets/notification_empty.dart';
import 'package:ql_moifood_app/views/notification/widgets/notification_list_item.dart';

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
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() => _controller.loadAllNotifications());
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
              children: [_buildNotificationsList(), buildTab2()],
            ),
          ),
        ],
      ),
    );
  }

  //  HEADER
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
              label: "Gửi cho người dùng",
              icon: const Icon(
                Icons.person_add_rounded,
                color: Colors.white,
                size: 20,
              ),
              height: 48,
              fontSize: 14,
              gradientColors: [Colors.blue.shade400, Colors.blue.shade600],
              onTap: vm.isSending ? null : _controller.showSendToUserModal,
            ),
          ),
          const SizedBox(width: 12),
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

  // build tab
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
            Tab(text: 'Danh sách thông báo'),
            Tab(text: 'Danh sách khách hàng'),
          ],
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

  // TAB 1: NOTIFICATIONS LIST
  Widget _buildNotificationsList() {
    return Consumer<NotificationViewModel>(
      builder: (context, vm, _) {
        // Loading state
        if (vm.isLoadingAll && vm.allNotifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error state
        if (vm.errorMessage != null && vm.allNotifications.isEmpty) {
          return NotificationEmpty(
            message: 'Lỗi: ${vm.errorMessage}',
            icon: Icons.error_outline_rounded,
            onRefresh: _controller.loadAllNotifications,
          );
        }

        // Empty state
        if (vm.allNotifications.isEmpty) {
          return NotificationEmpty(
            message: 'Chưa có thông báo nào.',
            icon: Icons.notifications_none_rounded,
            onRefresh: _controller.loadAllNotifications,
          );
        }

        // List view
        return RefreshIndicator(
          onRefresh: _controller.loadAllNotifications,
          child: ListView.builder(
            itemCount: vm.allNotifications.length,
            itemBuilder: (context, index) {
              final notification = vm.allNotifications[index];
              return NotificationListItem(
                key: ValueKey(notification.notificationId),
                notification: notification,
                onView: () =>
                    _controller.showViewNotificationModal(notification),
                onDelete: () =>
                    _controller.confirmDeleteNotification(notification),
              );
            },
          ),
        );
      },
    );
  }

  // Tab 2:
  Widget buildTab2() {
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
            message: 'chưa có danh sách khách hàng',
            icon: Icons.notifications_none_rounded,
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
              return _buildUserListItem(user);
            },
          ),
        );
      },
    );
  }

  // danh sách khách hàng
  Widget _buildUserListItem(User user) {
    return _UserSendListItem(user: user, controller: _controller);
  }
}


class _UserSendListItem extends StatefulWidget {
  final User user;
  final NotificationController controller;

  const _UserSendListItem({required this.user, required this.controller});

  @override
  State<_UserSendListItem> createState() => _UserSendListItemState();
}

class _UserSendListItemState extends State<_UserSendListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Icon Avatar
    final circleAvatar = CircleAvatar(
      radius: 28,
      backgroundColor: Colors.grey.shade200,
      backgroundImage:
          (widget.user.avatar != null && widget.user.avatar!.isNotEmpty)
          ? NetworkImage(widget.user.avatar!)
          : null,
      child: (widget.user.avatar == null || widget.user.avatar!.isEmpty)
          ? Icon(Icons.person_rounded, size: 28, color: Colors.grey.shade500)
          : null,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              _isHovered ? Colors.white : Colors.grey.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? AppColor.orange.withValues(alpha: 0.3)
                : Colors.grey.shade200,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? AppColor.orange.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: _isHovered ? 16 : 8,
              offset: Offset(0, _isHovered ? 6 : 4),
              spreadRadius: _isHovered ? 1 : 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Avatar 
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered
                          ? AppColor.primary.withValues(alpha: 0.3)
                          : Colors.transparent,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: circleAvatar,
              ),
              const SizedBox(width: 16),

              // Thông tin 
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.user.fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.user.email,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColor.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${widget.user.userId} - ${widget.user.phone ?? 'Chưa có SĐT'}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Vai trò
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: widget.user.role.toLowerCase() == 'admin'
                      ? AppColor.orange.withValues(alpha: 0.1)
                      : Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.user.role,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: widget.user.role.toLowerCase() == 'admin'
                        ? AppColor.orange
                        : Colors.blue.shade700,
                  ),
                ),
              ),
              const SizedBox(width: 24),

              // Nút Gửi
              CustomButton(
                tooltip: "Gửi thông báo cho người dùng này",
                icon: const Icon(Icons.send_rounded, color: Colors.white),
                width: 44,
                height: 44,
                iconSize: 22,
                gradientColors: [Colors.blue.shade400, Colors.blue.shade600],
                borderRadius: 12,
                onTap: () {
                  widget.controller.showSendToUserModal(
                    targetUser: widget.user,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
