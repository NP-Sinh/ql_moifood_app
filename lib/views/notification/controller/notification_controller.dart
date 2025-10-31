import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/models/notification.dart';
import 'package:ql_moifood_app/resources/widgets/dialogs/configs/snackbar_config.dart';
import 'package:ql_moifood_app/viewmodels/notification_viewmodel.dart';
import 'package:ql_moifood_app/resources/widgets/dialogs/app_utils.dart';
import 'package:ql_moifood_app/views/notification/modal/notification_form.dart';
import 'package:ql_moifood_app/views/notification/modal/notification_detail_form.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart';
import 'package:ql_moifood_app/resources/theme/colors.dart';

class NotificationController {
  final BuildContext context;
  late final NotificationViewModel _viewModel;

  NotificationController(this.context) {
    _viewModel = context.read<NotificationViewModel>();
  }

  // LOAD DATA
  Future<void> loadAllNotifications() async {
    await _viewModel.fetchAllNotifications();
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
    String selectedType = 'info';

    AppUtils.showBaseModal(
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
                      if (success) loadAllNotifications();
                    }
                  }
                },
        ),
      ),
    );
  }

  // SEND TO USER
  void showSendToUserModal() {
    final formKey = GlobalKey<FormState>();
    final userIdController = TextEditingController();
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    String selectedType = 'info';

    AppUtils.showBaseModal(
      context,
      title: 'Gửi thông báo cho người dùng',
      width: 800,
      child: NotificationForm(
        formKey: formKey,
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
                    final userId = int.tryParse(userIdController.text.trim());
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
                      if (success) loadAllNotifications();
                    }
                  }
                },
        ),
      ),
    );
  }

  //  VIEW DETAIL
  void showViewNotificationModal(NotificationModel notification) {
    AppUtils.showBaseModal(
      context,
      title: 'Chi tiết Thông báo',
      child: NotificationDetailForm(notification: notification),
      secondaryAction: CustomButton(
        label: 'Đóng',
        onTap: () => Navigator.of(context).pop(),
        gradientColors: [Colors.grey.shade500, Colors.grey.shade600],
      ),
    );
  }

  //  DELETE
  void confirmDeleteNotification(NotificationModel notification) {
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
