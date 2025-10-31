import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/models/global_notification.dart';
import 'package:ql_moifood_app/models/notification.dart';
import 'package:ql_moifood_app/models/user.dart';
import 'package:ql_moifood_app/resources/widgets/dialogs/configs/snackbar_config.dart';
import 'package:ql_moifood_app/viewmodels/notification_viewmodel.dart';
import 'package:ql_moifood_app/resources/widgets/dialogs/app_utils.dart';
import 'package:ql_moifood_app/views/notification/modal/notification_form.dart';
import 'package:ql_moifood_app/views/notification/modal/notification_detail_form.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';
import 'package:ql_moifood_app/views/notification/modal/notification_user_detail.dart';

class NotificationController {
  final BuildContext context;
  late final NotificationViewModel _viewModel;

  NotificationController(this.context) {
    _viewModel = context.read<NotificationViewModel>();
  }

  // load Global Notifications
  Future<void> loadGlobalNotifications() async {
    await _viewModel.fetchGlobalNotifications();
    if (_viewModel.errorMessage != null && context.mounted) {
      AppUtils.showSnackBar(
        context,
        _viewModel.errorMessage!,
        type: SnackBarType.error,
      );
    }
  }

  // load user Notifications
  Future<void> loadUserNotifications([int? userId]) async {
    await _viewModel.fetchNotificationsByUserId(userId);
    if (_viewModel.errorMessage != null && context.mounted) {
      AppUtils.showSnackBar(
        context,
        _viewModel.errorMessage!,
        type: SnackBarType.error,
      );
    }
  }

  // SEND GLOBAL NOTIFICATION
  void showSendGlobalNotificationModal() {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    String selectedType = 'System';

    AppUtils.showBaseModal(
      width: 500,
      maxHeight: 600,
      context,
      title: 'Gửi thông báo toàn hệ thống',
      child: NotificationForm(
        formKey: formKey,
        titleController: titleController,
        messageController: messageController,
        initialType: selectedType,
        onTypeChanged: (type) => selectedType = type,
      ),
      secondaryAction: CustomButton(
        label: 'Hủy',
        onTap: () => Navigator.of(context).pop(),
        gradientColors: AppColor.btnCancel,
        showShadow: false,
      ),
      primaryAction: Consumer<NotificationViewModel>(
        builder: (context, vm, _) => CustomButton(
          label: vm.isSending ? 'Đang gửi...' : 'Gửi thông báo',
          icon: vm.isSending
              ? Container(
                  width: 18,
                  height: 18,
                  margin: const EdgeInsets.only(right: 8),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.send_rounded, color: Colors.white, size: 18),
          gradientColors: AppColor.btnAdd,
          onTap: vm.isSending
              ? null
              : () async {
                  if (formKey.currentState?.validate() == true) {
                    final success = await vm.sendGlobalNotification(
                      title: titleController.text.trim(),
                      message: messageController.text.trim(),
                      type: selectedType,
                    );
                    if (context.mounted) {
                      Navigator.pop(context);
                      AppUtils.showSnackBar(
                        context,
                        success
                            ? 'Đã gửi thông báo đến tất cả người dùng'
                            : vm.errorMessage ?? 'Gửi thất bại',
                        type: success
                            ? SnackBarType.success
                            : SnackBarType.error,
                      );
                      if (success) loadGlobalNotifications();
                    }
                  }
                },
        ),
      ),
    );
  }

  // SEND TO USER
  void showSendToUserModal({User? targetUser}) {
    final formKey = GlobalKey<FormState>();
    final userIdController = targetUser == null
        ? TextEditingController()
        : null;
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    String selectedType = 'System';

    AppUtils.showBaseModal(
      context,
      width: 600,
      title: targetUser != null
          ? 'Gửi thông báo tới: ${targetUser.fullName}'
          : 'Gửi thông báo cho người dùng',
      child: NotificationForm(
        formKey: formKey,
        targetUser: targetUser,
        userIdController: userIdController,
        titleController: titleController,
        messageController: messageController,
        initialType: selectedType,
        onTypeChanged: (type) => selectedType = type,
        isPersonal: true,
      ),
      secondaryAction: CustomButton(
        label: 'Hủy',
        onTap: () => Navigator.of(context).pop(),
        gradientColors: AppColor.btnCancel,
        showShadow: false,
      ),
      primaryAction: Consumer<NotificationViewModel>(
        builder: (context, vm, _) => CustomButton(
          label: vm.isSending ? 'Đang gửi...' : 'Gửi thông báo',
          icon: vm.isSending
              ? Container(
                  width: 18,
                  height: 18,
                  margin: const EdgeInsets.only(right: 8),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.send_rounded, color: Colors.white, size: 18),
          gradientColors: AppColor.btnAdd,
          onTap: vm.isSending
              ? null
              : () async {
                  if (formKey.currentState?.validate() == true) {
                    int? userId;
                    if (targetUser != null) {
                      userId = targetUser.userId;
                    } else if (userIdController != null) {
                      userId = int.tryParse(userIdController.text.trim());
                    }

                    if (userId == null) {
                      AppUtils.showSnackBar(
                        context,
                        'Mã người dùng không hợp lệ',
                        type: SnackBarType.error,
                      );
                      return;
                    }
                    final success = await vm.sendNotificationToUser(
                      userId: userId,
                      title: titleController.text.trim(),
                      message: messageController.text.trim(),
                      type: selectedType,
                    );
                    if (context.mounted) {
                      Navigator.pop(context);
                      AppUtils.showSnackBar(
                        context,
                        success
                            ? 'Đã gửi thông báo đến người dùng #$userId'
                            : vm.errorMessage ?? 'Gửi thất bại',
                        type: success
                            ? SnackBarType.success
                            : SnackBarType.error,
                      );
                    }
                  }
                },
        ),
      ),
    );
  }

  //  VIEW DETAIL
  void showViewNotificationModal(GlobalNotification globalNotification) {
    AppUtils.showBaseModal(
      context,
      title: 'Chi tiết Thông báo',
      child: NotificationDetailForm(globalNotification: globalNotification),
      secondaryAction: CustomButton(
        label: 'Đóng',
        onTap: () => Navigator.of(context).pop(),
        gradientColors: [Colors.grey.shade500, Colors.grey.shade600],
      ),
    );
  }

  void showViewUserNotificationModal(NotificationModel notification) {
    AppUtils.showBaseModal(
      context,
      title: 'Chi tiết Thông báo',
      child: NotificationUserDetail(notification: notification),
      secondaryAction: CustomButton(
        label: 'Đóng',
        onTap: () => Navigator.of(context).pop(),
        gradientColors: [Colors.grey.shade500, Colors.grey.shade600],
      ),
    );
  }

  //  DELETE
  void confirmDeleteUserNotification(NotificationModel notification) {
    AppUtils.showConfirmDialog(
      context,
      title: 'Xác nhận xóa',
      message: 'Bạn có chắc muốn xóa thông báo "${notification.title}" không?',
      confirmText: 'Xóa',
      confirmColor: Colors.redAccent,
    ).then((confirmed) async {
      if (confirmed == true) {
        final success = await _viewModel.deleteNotification(
          notification.notificationId,
        );
        if (context.mounted) {
          AppUtils.showSnackBar(
            context,
            success
                ? 'Đã xóa thông báo thành công'
                : _viewModel.errorMessage ?? 'Xóa thất bại',
            type: success ? SnackBarType.success : SnackBarType.error,
          );
        }
      }
    });
  }
}
