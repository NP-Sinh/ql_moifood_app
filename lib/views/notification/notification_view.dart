import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/viewmodels/notification_viewmodel.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/views/notification/controller/notification_controller.dart';
import 'package:ql_moifood_app/views/notification/widgets/notification_empty.dart';
import 'package:ql_moifood_app/views/notification/widgets/notification_list_item.dart';

class NotificationView extends StatefulWidget {
  static const String routeName = '/notification';
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  late final NotificationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = NotificationController(context);
    Future.microtask(() => _controller.loadAllNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const PageStorageKey('notification_view'),
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildNotificationsList()),
        ],
      ),
    );
  }

  //  HEADER
  Widget _buildHeader() => Container(
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
    padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
    margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Row(
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
    ),
  );

  //  NOTIFICATIONS LIST
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
}
