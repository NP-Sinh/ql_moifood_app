import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ql_moifood_app/models/user.dart';
import 'package:ql_moifood_app/viewmodels/user_viewmodel.dart';
import 'package:ql_moifood_app/resources/widgets/dialogs/app_utils.dart';
import 'package:ql_moifood_app/resources/widgets/dialogs/configs/snackbar_config.dart';
import 'package:ql_moifood_app/views/customer/modal/user_form.dart';
import 'package:ql_moifood_app/resources/widgets/buttons/custom_button.dart'; 

class UserController {
  final BuildContext context;
  late final UserViewModel _viewModel;

  UserController(this.context) {
    _viewModel = context.read<UserViewModel>();
  }

  // Tải danh sách người dùng
  Future<void> loadUsers() async {
    await _viewModel.fetchUsers();
    if (_viewModel.errorMessage != null && context.mounted) {
      AppUtils.showSnackBar(
        context,
        _viewModel.errorMessage!,
        type: SnackBarType.error,
      );
    }
  }

  // Tìm kiếm người dùng
  Future<void> searchUsers(String keyword) async {
    await _viewModel.searchUsers(keyword);
    if (_viewModel.errorMessage != null && context.mounted) {
      AppUtils.showSnackBar(
        context,
        _viewModel.errorMessage!,
        type: SnackBarType.error,
      );
    }
  }

  // Xác nhận thay đổi trạng thái active
  void confirmSetActive(User user, bool newStatus) {
    final actionText = newStatus ? "Kích hoạt" : "Vô hiệu hóa";
    final actionColor = newStatus ? Colors.green : Colors.red;

    AppUtils.showConfirmDialog(
      context,
      title: 'Xác nhận $actionText',
      message:
          'Bạn có chắc muốn $actionText tài khoản "${user.fullName}" (Email: ${user.email}) không?',
      confirmText: actionText,
      confirmColor: actionColor,
    ).then((confirmed) async {
      if (confirmed == true) {
        final success = await _viewModel.setActiveUser(
          userId: user.userId,
          isActive: newStatus,
        );
        if (context.mounted) {
          AppUtils.showSnackBar(
            context,
            success
                ? 'Đã $actionText tài khoản ${user.fullName}'
                : _viewModel.errorMessage ?? '$actionText thất bại',
            type: success ? SnackBarType.success : SnackBarType.error,
          );
        }
      }
    });
  }

  void showViewUserModal(User user) {
    AppUtils.showBaseModal(
      context,
      title: 'Chi tiết Người dùng',
      child: UserForm(user: user), 
      // Thêm nút Đóng
      secondaryAction: CustomButton(
        label: 'Đóng',
        onTap: () => Navigator.of(context).pop(),
        gradientColors: [Colors.grey.shade500, Colors.grey.shade600],
      ),
    );
  }
}